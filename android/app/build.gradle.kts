import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------------------------------------------------------------------------
// SIGNING
// ---------------------------------------------------------------------------
// Create android/key.properties with:
//   storePassword=<password>
//   keyPassword=<password>
//   keyAlias=<alias>
//   storeFile=<path-to-.jks-file>
// key.properties is gitignored — never commit it.
// ---------------------------------------------------------------------------

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // TODO: Replace with your app's package name.
    namespace = "com.example.flutter_boilerplate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required for flutter_local_notifications timezone support.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Replace with your app's application ID.
        applicationId = "com.example.flutter_boilerplate"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasProp     = keystoreProperties.getProperty("keyAlias")
            val keyPasswordProp  = keystoreProperties.getProperty("keyPassword")
            val storeFileProp    = keystoreProperties.getProperty("storeFile")
            val storePasswordProp = keystoreProperties.getProperty("storePassword")

            if (storeFileProp != null) {
                keyAlias     = keyAliasProp
                keyPassword  = keyPasswordProp
                storeFile    = file(storeFileProp)
                storePassword = storePasswordProp
            }
        }
    }

    buildTypes {
        release {
            val hasReleaseKey = keystorePropertiesFile.exists() &&
                keystoreProperties.getProperty("storeFile") != null
            signingConfig = if (hasReleaseKey)
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // Required for isCoreLibraryDesugaringEnabled (Java 8+ time APIs on older Android).
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

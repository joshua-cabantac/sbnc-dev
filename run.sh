#!/bin/bash

if [ -f "pubspec.yaml" ]; then
	flutter run
elif [ -f "svelte.config.js" ]; then
	rm -rf build
	npm run build
	npm run tauri dev
elif [ -f "package.json" ]; then
	npm run dev
elif [ -f "*.py" ]; then
	if grep -q "spring-boot" pom.xml; then
		mvn spring-boot:run
	else
		mvn compile exec:java
	fi
elif [ -f "pom.xml" ]; then
	if grep -q "spring-boot" pom.xml; then
		mvn spring-boot:run
	else
		mvn compile exec:java
	fi
elif [ -f "build.gradle" ]; then
	if grep -q "spring-boot" build.gradle; then
		./gradlew bootRun
	else
		./gradlew run
	fi
elif [ -f "go.mod" ]; then
	if command -v air >/dev/null 2>&1; then
		air
	else
		go run .
	fi
elif [ -f "cargo.toml" ]; then
	cargo run
else
	echo "Unknown project type."
fi

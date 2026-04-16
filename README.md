# Contab App

Aplicación móvil de contabilidad personal desarrollada con **Flutter**, orientada a llevar el control de ingresos, gastos, cuentas y movimientos financieros de forma simple, ordenada y escalable.

## Descripción

**Contab App** es una aplicación enfocada en el registro y administración de finanzas personales. Su objetivo es permitir al usuario:

- registrar ingresos y gastos,
- organizar movimientos por categorías,
- administrar cuentas como efectivo, banco o tarjeta,
- visualizar información resumida desde un dashboard,
- y construir una base sólida para futuras mejoras como backend, sincronización y reportes avanzados.

El proyecto está siendo desarrollado bajo una arquitectura modular para facilitar el mantenimiento, la escalabilidad y la evolución del MVP.

---

## Objetivo del proyecto

Construir una aplicación móvil funcional para uso personal que permita gestionar operaciones contables básicas desde una interfaz clara, moderna y organizada.

Este proyecto inicia con un enfoque **local-first**, utilizando **SQLite** como almacenamiento local, con la posibilidad de integrar un backend en fases posteriores.

---

## Estado actual del proyecto

Actualmente el proyecto incluye:

- estructura base de carpetas organizada por módulos,
- tema visual base,
- dashboard principal,
- navegación inicial entre vistas,
- configuración de base de datos local con `sqflite`,
- tabla de tipos de movimiento,
- arquitectura inicial tipo MVC práctico para Flutter.

---

## Tecnologías utilizadas

- **Flutter**
- **Dart**
- **SQLite**
- **sqflite**
- **path**

---

## Arquitectura del proyecto

El proyecto sigue una organización modular por responsabilidades.

### Estructura general

```text
lib/
├── core/
│   ├── constants/
│   ├── database/
│   ├── theme/
│   └── utils/
├── shared/
│   ├── extensions/
│   └── widgets/
├── features/
│   ├── home/
│   └── tipo_movimiento/
└── main.dart

# Changelog

## [0.0.1] - 2025-12-24
### added
- first working version with `MockDb`, `MockCollection`, `MockRecord` classes




## [1.0.0] - 2026-03-05
### Added
- Initial release of MockDB.
- Dynamic collection registry via `MockDB.instance.collection<T>()`.
- Reactive Streams for real-time data monitoring.
- CRUD operations (Create, Find, Update, Clear).
- Robust `MockResult` wrapper with data and metadata getters.

### Changed
- Refactored architecture to use `part / part of` for modular mixins.
- Optimized `MockDB` singleton for better memory management.

### Fixed
- Resolved type-casting issues when accessing existing collections.
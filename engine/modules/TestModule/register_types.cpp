#include "register_types.h"

#include "core/class_db.h"
#include "TestModule.h"

void register_TestModule_types() {
	ClassDB::register_class<TestModule>();
}

void unregister_TestModule_types() {
	// Nothing to do here in this example.
}

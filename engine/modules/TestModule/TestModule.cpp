#include "TestModule.h"

void TestModule::add(int p_value) {
	count += p_value;
}

void TestModule::reset() {
	count = 0;
}

int TestModule::get_total() const {
	return count;
}

void TestModule::_bind_methods() {
	ClassDB::bind_method(D_METHOD("add", "value"), &TestModule::add);
	ClassDB::bind_method(D_METHOD("reset"), &TestModule::reset);
	ClassDB::bind_method(D_METHOD("get_total"), &TestModule::get_total);
}

TestModule::TestModule() {
	count = 0;
}

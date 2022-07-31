#ifndef TestModule_H
#define TestModule_H

#include "core/reference.h"

class TestModule : public Reference {
	GDCLASS(TestModule, Reference);

	int count;

protected:
	static void _bind_methods();

public:
	void add(int p_value);
	void reset();
	int get_total() const;

	TestModule();
};

#endif

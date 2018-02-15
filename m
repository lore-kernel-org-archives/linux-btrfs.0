Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:42356 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161045AbeBOTFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:33 -0500
Received: by mail-pg0-f66.google.com with SMTP id y8so493774pgr.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:32 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 05/27] libbtrfsutil: add qgroup inheritance helpers
Date: Thu, 15 Feb 2018 11:04:50 -0800
Message-Id: <b359d9884c99e9bf3d6c7a22584c6e365e13eb24.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We want to hide struct btrfs_qgroup_inherit from the user because that
comes from the Btrfs UAPI headers. Instead, wrap it in a struct
btrfs_util_qgroup_inherit and provide helpers to manipulate it. This
will be used for subvolume and snapshot creation.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile                                 |   3 +-
 libbtrfsutil/btrfsutil.h                 |  45 +++++++++
 libbtrfsutil/python/btrfsutilpy.h        |   6 ++
 libbtrfsutil/python/module.c             |   8 ++
 libbtrfsutil/python/qgroup.c             | 154 +++++++++++++++++++++++++++++++
 libbtrfsutil/python/setup.py             |   1 +
 libbtrfsutil/python/tests/test_qgroup.py |  36 ++++++++
 libbtrfsutil/qgroup.c                    |  83 +++++++++++++++++
 8 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 libbtrfsutil/python/qgroup.c
 create mode 100644 libbtrfsutil/python/tests/test_qgroup.py
 create mode 100644 libbtrfsutil/qgroup.c

diff --git a/Makefile b/Makefile
index 58b3eca4..fa32c50d 100644
--- a/Makefile
+++ b/Makefile
@@ -135,7 +135,8 @@ libbtrfsutil_major := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_MAJOR ([0-
 libbtrfsutil_minor := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_MINOR ([0-9])+$$/\1/p' libbtrfsutil/btrfsutil.h)
 libbtrfsutil_patch := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_PATCH ([0-9])+$$/\1/p' libbtrfsutil/btrfsutil.h)
 libbtrfsutil_version := $(libbtrfsutil_major).$(libbtrfsutil_minor).$(libbtrfsutil_patch)
-libbtrfsutil_objects = libbtrfsutil/errors.o libbtrfsutil/subvolume.o
+libbtrfsutil_objects = libbtrfsutil/errors.o libbtrfsutil/qgroup.o \
+		       libbtrfsutil/subvolume.o
 convert_objects = convert/main.o convert/common.o convert/source-fs.o \
 		  convert/source-ext2.o convert/source-reiserfs.o
 mkfs_objects = mkfs/main.o mkfs/common.o mkfs/rootdir.o
diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index ca36f695..76bf0b60 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -20,6 +20,7 @@
 #ifndef BTRFS_UTIL_H
 #define BTRFS_UTIL_H
 
+#include <stddef.h>
 #include <stdint.h>
 
 #define BTRFS_UTIL_VERSION_MAJOR 1
@@ -102,6 +103,50 @@ enum btrfs_util_error btrfs_util_subvolume_id(const char *path,
  */
 enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd, uint64_t *id_ret);
 
+struct btrfs_util_qgroup_inherit;
+
+/**
+ * btrfs_util_create_qgroup_inherit() - Create a qgroup inheritance specifier
+ * for btrfs_util_create_subvolume() or btrfs_util_create_snapshot().
+ * @flags: Must be zero.
+ * @ret: Returned qgroup inheritance specifier.
+ *
+ * The returned structure must be freed with
+ * btrfs_util_destroy_qgroup_inherit().
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_create_qgroup_inherit(int flags,
+						       struct btrfs_util_qgroup_inherit **ret);
+
+/**
+ * btrfs_util_destroy_qgroup_inherit() - Destroy a qgroup inheritance specifier
+ * previously created with btrfs_util_create_qgroup_inherit().
+ * @inherit: Specifier to destroy.
+ */
+void btrfs_util_destroy_qgroup_inherit(struct btrfs_util_qgroup_inherit *inherit);
+
+/**
+ * btrfs_util_qgroup_inherit_add_group() - Add inheritance from a qgroup to a
+ * qgroup inheritance specifier.
+ * @inherit: Specifier to modify. May be reallocated.
+ * @qgroupid: ID of qgroup to inherit from.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_qgroup_inherit_add_group(struct btrfs_util_qgroup_inherit **inherit,
+							  uint64_t qgroupid);
+
+/**
+ * btrfs_util_qgroup_inherit_get_groups() - Get the qgroups a qgroup inheritance
+ * specifier contains.
+ * @inherit: Qgroup inheritance specifier.
+ * @groups: Returned array of qgroup IDs.
+ * @n: Returned number of entries in the @groups array.
+ */
+void btrfs_util_qgroup_inherit_get_groups(const struct btrfs_util_qgroup_inherit *inherit,
+					  const uint64_t **groups, size_t *n);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index 9a04fda7..a36f2671 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -29,7 +29,13 @@
 
 #include <btrfsutil.h>
 
+typedef struct {
+	PyObject_HEAD
+	struct btrfs_util_qgroup_inherit *inherit;
+} QgroupInherit;
+
 extern PyTypeObject BtrfsUtilError_type;
+extern PyTypeObject QgroupInherit_type;
 
 /*
  * Helpers for path arguments based on posixmodule.c in CPython.
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index d492cbc7..de7d17a1 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -164,6 +164,10 @@ PyInit_btrfsutil(void)
 	if (PyType_Ready(&BtrfsUtilError_type) < 0)
 		return NULL;
 
+	QgroupInherit_type.tp_new = PyType_GenericNew;
+	if (PyType_Ready(&QgroupInherit_type) < 0)
+		return NULL;
+
 	m = PyModule_Create(&btrfsutilmodule);
 	if (!m)
 		return NULL;
@@ -172,6 +176,10 @@ PyInit_btrfsutil(void)
 	PyModule_AddObject(m, "BtrfsUtilError",
 			   (PyObject *)&BtrfsUtilError_type);
 
+	Py_INCREF(&QgroupInherit_type);
+	PyModule_AddObject(m, "QgroupInherit",
+			   (PyObject *)&QgroupInherit_type);
+
 	add_module_constants(m);
 
 	return m;
diff --git a/libbtrfsutil/python/qgroup.c b/libbtrfsutil/python/qgroup.c
new file mode 100644
index 00000000..69716d92
--- /dev/null
+++ b/libbtrfsutil/python/qgroup.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2018 Facebook
+ *
+ * This file is part of libbtrfsutil.
+ *
+ * libbtrfsutil is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * libbtrfsutil is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "btrfsutilpy.h"
+
+static void QgroupInherit_dealloc(QgroupInherit *self)
+{
+	btrfs_util_destroy_qgroup_inherit(self->inherit);
+	Py_TYPE(self)->tp_free((PyObject *)self);
+}
+
+static int QgroupInherit_init(QgroupInherit *self, PyObject *args,
+			      PyObject *kwds)
+{
+	static char *keywords[] = {NULL};
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, ":QgroupInherit",
+					 keywords))
+		return -1;
+
+	err = btrfs_util_create_qgroup_inherit(0, &self->inherit);
+	if (err) {
+		SetFromBtrfsUtilError(err);
+		return -1;
+	}
+
+	return 0;
+}
+
+static PyObject *QgroupInherit_getattro(QgroupInherit *self, PyObject *nameobj)
+{
+    const char *name = "";
+
+    if (PyUnicode_Check(nameobj)) {
+	    name = PyUnicode_AsUTF8(nameobj);
+	    if (!name)
+		    return NULL;
+    }
+
+    if (strcmp(name, "groups") == 0) {
+	    PyObject *ret, *tmp;
+	    const uint64_t *arr;
+	    size_t n, i;
+
+	    btrfs_util_qgroup_inherit_get_groups(self->inherit, &arr, &n);
+	    ret = PyList_New(n);
+	    if (!ret)
+		    return NULL;
+
+	    for (i = 0; i < n; i++) {
+		    tmp = PyLong_FromUnsignedLongLong(arr[i]);
+		    if (!tmp) {
+			    Py_DECREF(ret);
+			    return NULL;
+		    }
+		    PyList_SET_ITEM(ret, i, tmp);
+	    }
+
+	    return ret;
+    } else {
+	    return PyObject_GenericGetAttr((PyObject *)self, nameobj);
+    }
+}
+
+static PyObject *QgroupInherit_add_group(QgroupInherit *self, PyObject *args,
+					 PyObject *kwds)
+{
+	static char *keywords[] = {"qgroupid", NULL};
+	enum btrfs_util_error err;
+	uint64_t qgroupid;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "K:add_group", keywords,
+					 &qgroupid))
+		return NULL;
+
+	err = btrfs_util_qgroup_inherit_add_group(&self->inherit, qgroupid);
+	if (err) {
+		SetFromBtrfsUtilError(err);
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+static PyMethodDef QgroupInherit_methods[] = {
+	{"add_group", (PyCFunction)QgroupInherit_add_group,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "add_group(qgroupid)\n\n"
+	 "Add a qgroup to inherit from.\n\n"
+	 "Arguments:\n"
+	 "qgroupid -- ID of qgroup to add"},
+	{},
+};
+
+#define QgroupInherit_DOC	\
+	"QgroupInherit() -> new qgroup inheritance specifier\n\n"	\
+	"Create a new object which specifies what qgroups to inherit\n"	\
+	"from for create_subvolume() and create_snapshot()"
+
+PyTypeObject QgroupInherit_type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	"btrfsutil.QgroupInherit",		/* tp_name */
+	sizeof(QgroupInherit),			/* tp_basicsize */
+	0,					/* tp_itemsize */
+	(destructor)QgroupInherit_dealloc,	/* tp_dealloc */
+	NULL,					/* tp_print */
+	NULL,					/* tp_getattr */
+	NULL,					/* tp_setattr */
+	NULL,					/* tp_as_async */
+	NULL,					/* tp_repr */
+	NULL,					/* tp_as_number */
+	NULL,					/* tp_as_sequence */
+	NULL,					/* tp_as_mapping */
+	NULL,					/* tp_hash  */
+	NULL,					/* tp_call */
+	NULL,					/* tp_str */
+	(getattrofunc)QgroupInherit_getattro,	/* tp_getattro */
+	NULL,					/* tp_setattro */
+	NULL,					/* tp_as_buffer */
+	Py_TPFLAGS_DEFAULT,			/* tp_flags */
+	QgroupInherit_DOC,			/* tp_doc */
+	NULL,					/* tp_traverse */
+	NULL,					/* tp_clear */
+	NULL,					/* tp_richcompare */
+	0,					/* tp_weaklistoffset */
+	NULL,					/* tp_iter */
+	NULL,					/* tp_iternext */
+	QgroupInherit_methods,			/* tp_methods */
+	NULL,					/* tp_members */
+	NULL,					/* tp_getset */
+	NULL,					/* tp_base */
+	NULL,					/* tp_dict */
+	NULL,					/* tp_descr_get */
+	NULL,					/* tp_descr_set */
+	0,					/* tp_dictoffset */
+	(initproc)QgroupInherit_init,		/* tp_init */
+};
diff --git a/libbtrfsutil/python/setup.py b/libbtrfsutil/python/setup.py
index 57249829..06857084 100755
--- a/libbtrfsutil/python/setup.py
+++ b/libbtrfsutil/python/setup.py
@@ -91,6 +91,7 @@ module = Extension(
         'constants.c',
         'error.c',
         'module.c',
+        'qgroup.c',
         'subvolume.c',
     ],
     include_dirs=['..'],
diff --git a/libbtrfsutil/python/tests/test_qgroup.py b/libbtrfsutil/python/tests/test_qgroup.py
new file mode 100644
index 00000000..a590464b
--- /dev/null
+++ b/libbtrfsutil/python/tests/test_qgroup.py
@@ -0,0 +1,36 @@
+# Copyright (C) 2018 Facebook
+#
+# This file is part of libbtrfsutil.
+#
+# libbtrfsutil is free software: you can redistribute it and/or modify
+# it under the terms of the GNU Lesser General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# libbtrfsutil is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU Lesser General Public License for more details.
+#
+# You should have received a copy of the GNU Lesser General Public License
+# along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+
+import os
+import unittest
+
+import btrfsutil
+
+
+class TestQgroupInherit(unittest.TestCase):
+    def test_new(self):
+        inherit = btrfsutil.QgroupInherit()
+        self.assertEqual(inherit.groups, [])
+
+    def test_add_group(self):
+        inherit = btrfsutil.QgroupInherit()
+        inherit.add_group(1)
+        self.assertEqual(inherit.groups, [1])
+        inherit.add_group(2)
+        self.assertEqual(inherit.groups, [1, 2])
+        inherit.add_group(3)
+        self.assertEqual(inherit.groups, [1, 2, 3])
diff --git a/libbtrfsutil/qgroup.c b/libbtrfsutil/qgroup.c
new file mode 100644
index 00000000..d2916184
--- /dev/null
+++ b/libbtrfsutil/qgroup.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2018 Facebook
+ *
+ * This file is part of libbtrfsutil.
+ *
+ * libbtrfsutil is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * libbtrfsutil is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <errno.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/btrfs.h>
+
+#include "btrfsutil_internal.h"
+
+PUBLIC enum btrfs_util_error btrfs_util_create_qgroup_inherit(int flags,
+							      struct btrfs_util_qgroup_inherit **ret)
+{
+	struct btrfs_qgroup_inherit *inherit;
+
+	if (flags) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+
+	inherit = calloc(1, sizeof(*inherit));
+	if (!inherit)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+	/*
+	 * struct btrfs_util_qgroup_inherit is a lie; it's actually struct
+	 * btrfs_qgroup_inherit, but we abstract it away so that users don't
+	 * need to depend on the Btrfs UAPI headers.
+	 */
+	*ret = (struct btrfs_util_qgroup_inherit *)inherit;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC void btrfs_util_destroy_qgroup_inherit(struct btrfs_util_qgroup_inherit *inherit)
+{
+	free(inherit);
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_qgroup_inherit_add_group(struct btrfs_util_qgroup_inherit **inherit,
+								 uint64_t qgroupid)
+{
+	struct btrfs_qgroup_inherit *tmp = (struct btrfs_qgroup_inherit *)*inherit;
+
+	tmp = realloc(tmp, sizeof(*tmp) +
+		      (tmp->num_qgroups + 1) * sizeof(tmp->qgroups[0]));
+	if (!tmp)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+	tmp->qgroups[tmp->num_qgroups++] = qgroupid;
+
+	*inherit = (struct btrfs_util_qgroup_inherit *)tmp;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC void btrfs_util_qgroup_inherit_get_groups(const struct btrfs_util_qgroup_inherit *inherit,
+						 const uint64_t **groups,
+						 size_t *n)
+{
+	struct btrfs_qgroup_inherit *tmp = (struct btrfs_qgroup_inherit *)inherit;
+
+	/* Need to cast because __u64 != uint64_t. */
+	*groups = (const uint64_t *)&tmp->qgroups[0];
+	*n = tmp->num_qgroups;
+}
-- 
2.16.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:43074 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbeAZSl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:27 -0500
Received: by mail-pf0-f182.google.com with SMTP id y26so811954pfi.10
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:27 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 03/26] libbtrfsutil: add Python bindings
Date: Fri, 26 Jan 2018 10:40:51 -0800
Message-Id: <20e200f153166f54951dc6ea2730b13a360bf0b0.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The C libbtrfsutil library isn't very useful for scripting, so we also
want bindings for Python. Writing unit tests in Python is also much
easier than doing so in C. Only Python 3 is supported; if someone really
wants Python 2 support, they can write their own bindings. This commit
is just the scaffolding.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 INSTALL                               |   4 +
 Makefile                              |  36 ++++++
 Makefile.inc.in                       |   2 +
 configure.ac                          |  15 +++
 libbtrfsutil/README.md                |   5 +-
 libbtrfsutil/python/.gitignore        |   7 ++
 libbtrfsutil/python/btrfsutilpy.h     |  57 ++++++++++
 libbtrfsutil/python/error.c           | 202 ++++++++++++++++++++++++++++++++++
 libbtrfsutil/python/module.c          | 166 ++++++++++++++++++++++++++++
 libbtrfsutil/python/setup.py          | 100 +++++++++++++++++
 libbtrfsutil/python/tests/__init__.py |   0
 11 files changed, 593 insertions(+), 1 deletion(-)
 create mode 100644 libbtrfsutil/python/.gitignore
 create mode 100644 libbtrfsutil/python/btrfsutilpy.h
 create mode 100644 libbtrfsutil/python/error.c
 create mode 100644 libbtrfsutil/python/module.c
 create mode 100755 libbtrfsutil/python/setup.py
 create mode 100644 libbtrfsutil/python/tests/__init__.py

diff --git a/INSTALL b/INSTALL
index 819b92ea..24d6e24f 100644
--- a/INSTALL
+++ b/INSTALL
@@ -41,6 +41,10 @@ To build from the released tarballs:
     $ make
     $ make install
 
+To install the libbtrfsutil Python bindings:
+
+    $ make install_python
+
 You may disable building some parts like documentation, btrfs-convert or
 backtrace support. See ./configure --help for more.
 
diff --git a/Makefile b/Makefile
index 062f7f3c..02b03e81 100644
--- a/Makefile
+++ b/Makefile
@@ -144,8 +144,10 @@ endif
 
 ifeq ($(BUILD_VERBOSE),1)
   Q =
+  SETUP_PY_Q =
 else
   Q = @
+  SETUP_PY_Q = -q
 endif
 
 ifeq ("$(origin D)", "command line")
@@ -293,6 +295,9 @@ endif
 		$($(subst -,_,btrfs-$(@:%/$(notdir $@)=%)-cflags))
 
 all: $(progs) $(libs) $(lib_links) $(BUILDDIRS)
+ifeq ($(PYTHON_BINDINGS),1)
+all: libbtrfsutil_python
+endif
 $(SUBDIRS): $(BUILDDIRS)
 $(BUILDDIRS):
 	@echo "Making all in $(patsubst build-%,%,$@)"
@@ -336,6 +341,16 @@ test-inst: all
 
 test: test-fsck test-mkfs test-convert test-misc test-fuzz test-cli
 
+ifeq ($(PYTHON_BINDINGS),1)
+test-libbtrfsutil: libbtrfsutil_python
+	$(Q)cd libbtrfsutil/python; \
+		LD_LIBRARY_PATH=../.. $(PYTHON) -m unittest discover -v tests
+
+.PHONY: test-libbtrfsutil
+
+test: test-libbtrfsutil
+endif
+
 #
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
@@ -382,6 +397,15 @@ libbtrfsutil.so.0 libbtrfsutil.so: libbtrfsutil.so.$(libbtrfsutil_version)
 	@echo "    [LN]     $@"
 	$(Q)$(LN_S) -f $< $@
 
+ifeq ($(PYTHON_BINDINGS),1)
+libbtrfsutil_python: libbtrfsutil.so
+	@echo "    [PY]     libbtrfsutil"
+	$(Q)cd libbtrfsutil/python; \
+		CFLAGS= LDFLAGS= $(PYTHON) setup.py $(SETUP_PY_Q) build_ext -i build
+
+.PHONY: libbtrfsutil_python
+endif
+
 # keep intermediate files from the below implicit rules around
 .PRECIOUS: $(addsuffix .o,$(progs))
 
@@ -565,6 +589,10 @@ clean: $(CLEANDIRS)
 	      $(libs) $(lib_links) \
 	      $(progs_static) $(progs_extra) \
 	      libbtrfsutil/*.o libbtrfsutil/*.o.d
+ifeq ($(PYTHON_BINDINGS),1)
+	$(Q)cd libbtrfsutil/python; \
+		$(PYTHON) setup.py $(SETUP_PY_Q) clean -a
+endif
 
 clean-doc:
 	@echo "Cleaning Documentation"
@@ -599,6 +627,14 @@ ifneq ($(udevdir),)
 	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
 endif
 
+ifeq ($(PYTHON_BINDINGS),1)
+install_python: libbtrfsutil_python
+	$(Q)cd libbtrfsutil/python; \
+		$(PYTHON) setup.py install --skip-build $(if $(DESTDIR),--root $(DESTDIR)) --prefix $(prefix)
+
+.PHONY: install_python
+endif
+
 install-static: $(progs_static) $(INSTALLDIRS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_static) $(DESTDIR)$(bindir)
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 56271903..408e00d2 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -14,6 +14,8 @@ DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 BTRFSCONVERT_REISERFS = @BTRFSCONVERT_REISERFS@
 BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
+PYTHON_BINDINGS = @PYTHON_BINDINGS@
+PYTHON = @PYTHON@
 
 SUBST_CFLAGS = @CFLAGS@
 SUBST_LDFLAGS = @LDFLAGS@
diff --git a/configure.ac b/configure.ac
index 290dc1d5..5e2905d5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -199,6 +199,19 @@ fi
 AS_IF([test "x$enable_zstd" = xyes], [BTRFSRESTORE_ZSTD=1], [BTRFSRESTORE_ZSTD=0])
 AC_SUBST(BTRFSRESTORE_ZSTD)
 
+AC_ARG_ENABLE([python],
+	AS_HELP_STRING([--disable-python], [do not build libbtrfsutil Python bindings]),
+	[], [enable_python=yes]
+)
+
+if test "x$enable_python" = xyes; then
+	AM_PATH_PYTHON([3.4])
+fi
+
+AS_IF([test "x$enable_python" = xyes], [PYTHON_BINDINGS=1], [PYTHON_BINDINGS=0])
+AC_SUBST(PYTHON_BINDINGS)
+AC_SUBST(PYTHON)
+
 # udev v190 introduced the btrfs builtin and a udev rule to use it.
 # Our udev rule gives us the friendly dm names but isn't required (or valid)
 # on earlier releases.
@@ -253,6 +266,8 @@ AC_MSG_RESULT([
 	backtrace support:  ${enable_backtrace}
 	btrfs-convert:      ${enable_convert} ${convertfs:+($convertfs)}
 	btrfs-restore zstd: ${enable_zstd}
+	Python bindings:    ${enable_python}
+	Python interpreter: ${PYTHON}
 
 	Type 'make' to compile.
 ])
diff --git a/libbtrfsutil/README.md b/libbtrfsutil/README.md
index 2bc9a0a7..eed8102d 100644
--- a/libbtrfsutil/README.md
+++ b/libbtrfsutil/README.md
@@ -3,7 +3,8 @@ libbtrfsutil
 
 libbtrfsutil is a library for managing Btrfs filesystems. It is licensed under
 the LGPL. libbtrfsutil provides interfaces for a subset of the operations
-offered by the `btrfs` command line utility.
+offered by the `btrfs` command line utility. It also includes official Python
+bindings (Python 3 only).
 
 Development
 -----------
@@ -27,6 +28,8 @@ A few guidelines:
 * Don't require the Btrfs UAPI headers for any interfaces (e.g., instead of
   directly exposing a type from `linux/btrfs_tree.h`, abstract it away in a
   type specific to `libbtrfsutil`)
+* Include Python bindings for all interfaces
+* Write tests for all interfaces
 * Preserve API and ABI compatability at all times
 * Bump the libbtrfsutil version once for every release where the library
   changes (this is mostly on the maintainers)
diff --git a/libbtrfsutil/python/.gitignore b/libbtrfsutil/python/.gitignore
new file mode 100644
index 00000000..d050ff7c
--- /dev/null
+++ b/libbtrfsutil/python/.gitignore
@@ -0,0 +1,7 @@
+__pycache__
+*.pyc
+/btrfsutil.egg-info
+/btrfsutil*.so
+/build
+/constants.c
+/dist
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
new file mode 100644
index 00000000..6d82f7e1
--- /dev/null
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -0,0 +1,57 @@
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
+#ifndef BTRFSUTILPY_H
+#define BTRFSUTILPY_H
+
+#define PY_SSIZE_T_CLEAN
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <Python.h>
+#include "structmember.h"
+
+#include <btrfsutil.h>
+
+extern PyTypeObject BtrfsUtilError_type;
+
+/*
+ * Helpers for path arguments based on posixmodule.c in CPython.
+ */
+struct path_arg {
+	bool allow_fd;
+	char *path;
+	int fd;
+	Py_ssize_t length;
+	PyObject *object;
+	PyObject *cleanup;
+};
+int path_converter(PyObject *o, void *p);
+void path_cleanup(struct path_arg *path);
+
+void SetFromBtrfsUtilError(enum btrfs_util_error err);
+void SetFromBtrfsUtilErrorWithPath(enum btrfs_util_error err,
+				   struct path_arg *path);
+void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
+				    struct path_arg *path1,
+				    struct path_arg *path2);
+
+void add_module_constants(PyObject *m);
+
+#endif /* BTRFSUTILPY_H */
diff --git a/libbtrfsutil/python/error.c b/libbtrfsutil/python/error.c
new file mode 100644
index 00000000..0876c9b4
--- /dev/null
+++ b/libbtrfsutil/python/error.c
@@ -0,0 +1,202 @@
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
+typedef struct {
+	PyOSErrorObject os_error;
+	PyObject *btrfsutilerror;
+} BtrfsUtilError;
+
+void SetFromBtrfsUtilError(enum btrfs_util_error err)
+{
+	SetFromBtrfsUtilErrorWithPaths(err, NULL, NULL);
+}
+
+void SetFromBtrfsUtilErrorWithPath(enum btrfs_util_error err,
+				   struct path_arg *path1)
+{
+	SetFromBtrfsUtilErrorWithPaths(err, path1, NULL);
+}
+
+void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
+				    struct path_arg *path1,
+				    struct path_arg *path2)
+{
+	PyObject *strobj, *args, *exc;
+	int i = errno;
+	const char *str1 = btrfs_util_strerror(err), *str2 = strerror(i);
+
+	if (str1 && str2 && strcmp(str1, str2) != 0) {
+		strobj = PyUnicode_FromFormat("%s: %s", str1, str2);
+	} else if (str1) {
+		strobj = PyUnicode_FromString(str1);
+	} else if (str2) {
+		strobj = PyUnicode_FromString(str2);
+	} else {
+		Py_INCREF(Py_None);
+		strobj = Py_None;
+	}
+	if (strobj == NULL)
+		return;
+
+	args = Py_BuildValue("iOOOOi", i, strobj,
+			     path1 ? path1->object : Py_None, Py_None,
+			     path2 ? path2->object : Py_None, (int)err);
+	Py_DECREF(strobj);
+	if (args == NULL)
+		return;
+
+	exc = PyObject_CallObject((PyObject *)&BtrfsUtilError_type, args);
+	Py_DECREF(args);
+	if (exc == NULL)
+		return;
+
+	PyErr_SetObject((PyObject *)&BtrfsUtilError_type, exc);
+	Py_DECREF(exc);
+}
+
+static int BtrfsUtilError_clear(BtrfsUtilError *self)
+{
+	Py_CLEAR(self->btrfsutilerror);
+	return Py_TYPE(self)->tp_base->tp_clear((PyObject *)self);
+}
+
+static void BtrfsUtilError_dealloc(BtrfsUtilError *self)
+{
+	PyObject_GC_UnTrack(self);
+	BtrfsUtilError_clear(self);
+	Py_TYPE(self)->tp_free((PyObject *)self);
+}
+
+static int BtrfsUtilError_traverse(BtrfsUtilError *self, visitproc visit,
+				   void *arg)
+{
+	Py_VISIT(self->btrfsutilerror);
+	return Py_TYPE(self)->tp_base->tp_traverse((PyObject *)self, visit, arg);
+}
+
+static PyObject *BtrfsUtilError_new(PyTypeObject *type, PyObject *args,
+				    PyObject *kwds)
+{
+	BtrfsUtilError *self;
+	PyObject *oserror_args = args;
+
+	if (PyTuple_Check(args) && PyTuple_GET_SIZE(args) == 6) {
+		oserror_args = PyTuple_GetSlice(args, 0, 5);
+		if (oserror_args == NULL)
+			return NULL;
+	}
+
+	self = (BtrfsUtilError *)type->tp_base->tp_new(type, oserror_args,
+						       kwds);
+	if (oserror_args != args)
+		Py_DECREF(oserror_args);
+	if (self == NULL)
+		return NULL;
+
+	if (PyTuple_Check(args) && PyTuple_GET_SIZE(args) == 6) {
+		self->btrfsutilerror = PyTuple_GET_ITEM(args, 5);
+		Py_INCREF(self->btrfsutilerror);
+	}
+
+	return (PyObject *)self;
+}
+
+static PyObject *BtrfsUtilError_str(BtrfsUtilError *self)
+{
+#define OR_NONE(x) ((x) ? (x) : Py_None)
+	if (self->btrfsutilerror) {
+		if (self->os_error.filename) {
+			if (self->os_error.filename2) {
+				return PyUnicode_FromFormat("[BtrfsUtilError %S Errno %S] %S: %R -> %R",
+							    OR_NONE(self->btrfsutilerror),
+							    OR_NONE(self->os_error.myerrno),
+							    OR_NONE(self->os_error.strerror),
+							    self->os_error.filename,
+							    self->os_error.filename2);
+			} else {
+				return PyUnicode_FromFormat("[BtrfsUtilError %S Errno %S] %S: %R",
+							    OR_NONE(self->btrfsutilerror),
+							    OR_NONE(self->os_error.myerrno),
+							    OR_NONE(self->os_error.strerror),
+							    self->os_error.filename);
+			}
+		}
+		if (self->os_error.myerrno && self->os_error.strerror) {
+			return PyUnicode_FromFormat("[BtrfsUtilError %S Errno %S] %S",
+						    self->btrfsutilerror,
+						    self->os_error.myerrno,
+						    self->os_error.strerror);
+		}
+	}
+	return Py_TYPE(self)->tp_base->tp_str((PyObject *)self);
+#undef OR_NONE
+}
+
+static PyMemberDef BtrfsUtilError_members[] = {
+	{"btrfsutilerror", T_OBJECT,
+	 offsetof(BtrfsUtilError, btrfsutilerror), 0,
+	 "btrfsutil error code"},
+	{},
+};
+
+#define BtrfsUtilError_DOC	\
+	"Btrfs operation error."
+
+PyTypeObject BtrfsUtilError_type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	"btrfsutil.BtrfsUtilError",			/* tp_name */
+	sizeof(BtrfsUtilError),				/* tp_basicsize */
+	0,						/* tp_itemsize */
+	(destructor)BtrfsUtilError_dealloc,		/* tp_dealloc */
+	NULL,						/* tp_print */
+	NULL,						/* tp_getattr */
+	NULL,						/* tp_setattr */
+	NULL,						/* tp_as_async */
+	NULL,						/* tp_repr */
+	NULL,						/* tp_as_number */
+	NULL,						/* tp_as_sequence */
+	NULL,						/* tp_as_mapping */
+	NULL,						/* tp_hash  */
+	NULL,						/* tp_call */
+	(reprfunc)BtrfsUtilError_str,			/* tp_str */
+	NULL,						/* tp_getattro */
+	NULL,						/* tp_setattro */
+	NULL,						/* tp_as_buffer */
+	Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,	/* tp_flags */
+	BtrfsUtilError_DOC,				/* tp_doc */
+	(traverseproc)BtrfsUtilError_traverse,		/* tp_traverse */
+	(inquiry)BtrfsUtilError_clear,			/* tp_clear */
+	NULL,						/* tp_richcompare */
+	0,						/* tp_weaklistoffset */
+	NULL,						/* tp_iter */
+	NULL,						/* tp_iternext */
+	NULL,						/* tp_methods */
+	BtrfsUtilError_members,				/* tp_members */
+	NULL,						/* tp_getset */
+	NULL,						/* tp_base */
+	NULL,						/* tp_dict */
+	NULL,						/* tp_descr_get */
+	NULL,						/* tp_descr_set */
+	offsetof(BtrfsUtilError, os_error.dict),	/* tp_dictoffset */
+	NULL,						/* tp_init */
+	NULL,						/* tp_alloc */
+	BtrfsUtilError_new,				/* tp_new */
+};
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
new file mode 100644
index 00000000..d7398808
--- /dev/null
+++ b/libbtrfsutil/python/module.c
@@ -0,0 +1,166 @@
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
+static int fd_converter(PyObject *o, void *p)
+{
+	int *fd = p;
+	long tmp;
+	int overflow;
+
+	tmp = PyLong_AsLongAndOverflow(o, &overflow);
+	if (tmp == -1 && PyErr_Occurred())
+		return 0;
+	if (overflow > 0 || tmp > INT_MAX) {
+		PyErr_SetString(PyExc_OverflowError,
+				"fd is greater than maximum");
+		return 0;
+	}
+	if (overflow < 0 || tmp < 0) {
+		PyErr_SetString(PyExc_ValueError, "fd is negative");
+		return 0;
+	}
+	*fd = tmp;
+	return 1;
+}
+
+int path_converter(PyObject *o, void *p)
+{
+	struct path_arg *path = p;
+	int is_index, is_bytes, is_unicode;
+	PyObject *bytes = NULL;
+	Py_ssize_t length = 0;
+	char *tmp;
+
+	if (o == NULL) {
+		path_cleanup(p);
+		return 1;
+	}
+
+	path->object = path->cleanup = NULL;
+	Py_INCREF(o);
+
+	path->fd = -1;
+
+	is_index = path->allow_fd && PyIndex_Check(o);
+	is_bytes = PyBytes_Check(o);
+	is_unicode = PyUnicode_Check(o);
+
+	if (!is_index && !is_bytes && !is_unicode) {
+		_Py_IDENTIFIER(__fspath__);
+		PyObject *func;
+
+		func = _PyObject_LookupSpecial(o, &PyId___fspath__);
+		if (func == NULL)
+			goto err_format;
+		Py_DECREF(o);
+		o = PyObject_CallFunctionObjArgs(func, NULL);
+		Py_DECREF(func);
+		if (o == NULL)
+			return 0;
+		is_bytes = PyBytes_Check(o);
+		is_unicode = PyUnicode_Check(o);
+	}
+
+	if (is_unicode) {
+		if (!PyUnicode_FSConverter(o, &bytes))
+			goto err;
+	} else if (is_bytes) {
+		bytes = o;
+		Py_INCREF(bytes);
+	} else if (is_index) {
+		if (!fd_converter(o, &path->fd))
+			goto err;
+		path->path = NULL;
+		goto out;
+	} else {
+err_format:
+		PyErr_Format(PyExc_TypeError, "expected %s, not %s",
+			     path->allow_fd ? "string, bytes, os.PathLike, or integer" :
+			     "string, bytes, or os.PathLike",
+			     Py_TYPE(o)->tp_name);
+		goto err;
+	}
+
+	length = PyBytes_GET_SIZE(bytes);
+	tmp = PyBytes_AS_STRING(bytes);
+	if ((size_t)length != strlen(tmp)) {
+		PyErr_SetString(PyExc_TypeError,
+				"path has embedded nul character");
+		goto err;
+	}
+
+	path->path = tmp;
+	if (bytes == o)
+		Py_DECREF(bytes);
+	else
+		path->cleanup = bytes;
+	path->fd = -1;
+
+out:
+	path->length = length;
+	path->object = o;
+	return Py_CLEANUP_SUPPORTED;
+
+err:
+	Py_XDECREF(o);
+	Py_XDECREF(bytes);
+	return 0;
+}
+
+void path_cleanup(struct path_arg *path)
+{
+	Py_CLEAR(path->object);
+	Py_CLEAR(path->cleanup);
+}
+
+static PyMethodDef btrfsutil_methods[] = {
+	{},
+};
+
+static struct PyModuleDef btrfsutilmodule = {
+	PyModuleDef_HEAD_INIT,
+	"btrfsutil",
+	"Library for managing Btrfs filesystems",
+	-1,
+	btrfsutil_methods,
+};
+
+PyMODINIT_FUNC
+PyInit_btrfsutil(void)
+{
+	PyObject *m;
+
+	BtrfsUtilError_type.tp_base = (PyTypeObject *)PyExc_OSError;
+	if (PyType_Ready(&BtrfsUtilError_type) < 0)
+		return NULL;
+
+	m = PyModule_Create(&btrfsutilmodule);
+	if (!m)
+		return NULL;
+
+	Py_INCREF(&BtrfsUtilError_type);
+	PyModule_AddObject(m, "BtrfsUtilError",
+			   (PyObject *)&BtrfsUtilError_type);
+
+	add_module_constants(m);
+
+	return m;
+}
diff --git a/libbtrfsutil/python/setup.py b/libbtrfsutil/python/setup.py
new file mode 100755
index 00000000..3dc778ab
--- /dev/null
+++ b/libbtrfsutil/python/setup.py
@@ -0,0 +1,100 @@
+#!/usr/bin/env python3
+
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
+import re
+import os
+import os.path
+from setuptools import setup, Extension
+from setuptools.command.build_ext import build_ext
+import subprocess
+
+
+def out_of_date(dependencies, target):
+    dependency_mtimes = [os.path.getmtime(dependency) for dependency in dependencies]
+    try:
+        target_mtime = os.path.getmtime(target)
+    except OSError:
+        return True
+    return any(dependency_mtime >= target_mtime for dependency_mtime in dependency_mtimes)
+
+
+def gen_constants():
+    with open('../btrfsutil.h', 'r') as f:
+        btrfsutil_h = f.read()
+
+    constants = re.findall(
+        r'^\s*(BTRFS_UTIL_ERROR_[a-zA-Z0-9_]+)',
+        btrfsutil_h, flags=re.MULTILINE)
+
+    with open('constants.c', 'w') as f:
+        f.write("""\
+#include <btrfsutil.h>
+#include "btrfsutilpy.h"
+
+void add_module_constants(PyObject *m)
+{
+""")
+        for constant in constants:
+            assert constant.startswith('BTRFS_UTIL_')
+            name = constant[len('BTRFS_UTIL_'):]
+            f.write('\tPyModule_AddIntConstant(m, "{}", {});\n'.format(name, constant))
+        f.write("""\
+}
+""")
+
+
+class my_build_ext(build_ext):
+    def run(self):
+        if out_of_date(['../btrfsutil.h'], 'constants.c'):
+            try:
+                gen_constants()
+            except Exception as e:
+                try:
+                    os.remove('constants.c')
+                except OSError:
+                    pass
+                raise e
+        super().run()
+
+
+module = Extension(
+    name='btrfsutil',
+    sources=[
+        'constants.c',
+        'error.c',
+        'module.c',
+    ],
+    include_dirs=['..'],
+    library_dirs=['../..'],
+    libraries=['btrfsutil'],
+)
+
+
+version = subprocess.check_output(
+    ['./version.sh', '--configure'], cwd='../..').decode('utf-8')
+version = re.match(r'v(\d+(?:\.\d+)*)', version).group(1)
+
+setup(
+    name='btrfsutil',
+    version=version,
+    description='Library for managing Btrfs filesystems',
+    url='https://github.com/kdave/btrfs-progs',
+    cmdclass={'build_ext': my_build_ext},
+    ext_modules=[module],
+)
diff --git a/libbtrfsutil/python/tests/__init__.py b/libbtrfsutil/python/tests/__init__.py
new file mode 100644
index 00000000..e69de29b
-- 
2.16.1


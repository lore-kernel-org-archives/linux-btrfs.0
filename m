Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40057 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161230AbeBOTFj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:39 -0500
Received: by mail-pl0-f68.google.com with SMTP id g18so349325plo.7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:38 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 11/27] libbtrfsutil: add subvolume iterator helpers
Date: Thu, 15 Feb 2018 11:04:56 -0800
Message-Id: <4cc1bad06e7e064dbf1af7a4e5b9d66ffe9c0913.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is how we can implement stuff like `btrfs subvol list`. Rather than
producing the entire list upfront, the iterator approach uses less
memory in the common case where the whole list is not stored (O(max
subvolume path length)). It supports both pre-order traversal (useful
for, e.g, recursive snapshot) and post-order traversal (useful for
recursive delete).

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  97 +++++++++
 libbtrfsutil/python/btrfsutilpy.h           |   1 +
 libbtrfsutil/python/module.c                |   8 +
 libbtrfsutil/python/subvolume.c             | 211 ++++++++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  56 +++++
 libbtrfsutil/subvolume.c                    | 317 ++++++++++++++++++++++++++++
 6 files changed, 690 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 54777f1d..7d3a87f6 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -345,6 +345,103 @@ enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
 						     uint64_t *async_transid,
 						     struct btrfs_util_qgroup_inherit *qgroup_inherit);
 
+struct btrfs_util_subvolume_iterator;
+
+/**
+ * BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER - Iterate post-order. The default
+ * behavior is pre-order, e.g., foo will be yielded before foo/bar. If this flag
+ * is specified, foo/bar will be yielded before foo.
+ */
+#define BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER (1 << 0)
+#define BTRFS_UTIL_SUBVOLUME_ITERATOR_MASK ((1 << 1) - 1)
+
+/**
+ * btrfs_util_create_subvolume_iterator() - Create an iterator over subvolumes
+ * in a Btrfs filesystem.
+ * @path: Path in a Btrfs filesystem. This may be any path in the filesystem; it
+ * does not have to refer to a subvolume unless @top is zero.
+ * @top: List subvolumes beneath (but not including) the subvolume with this ID.
+ * If zero is given, the subvolume ID of @path is used. To list all subvolumes,
+ * pass %BTRFS_FS_TREE_OBJECTID (i.e., 5). The returned paths are relative to
+ * the subvolume with this ID.
+ * @flags: Bitmask of BTRFS_UTIL_SUBVOLUME_ITERATOR_* flags.
+ * @ret: Returned iterator.
+ *
+ * The returned iterator must be freed with
+ * btrfs_util_destroy_subvolume_iterator().
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_create_subvolume_iterator(const char *path,
+							   uint64_t top,
+							   int flags,
+							   struct btrfs_util_subvolume_iterator **ret);
+
+/**
+ * btrfs_util_create_subvolume_iterator_fd() - See
+ * btrfs_util_create_subvolume_iterator().
+ */
+enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
+							      uint64_t top,
+							      int flags,
+							      struct btrfs_util_subvolume_iterator **ret);
+
+/**
+ * btrfs_util_destroy_subvolume_iterator() - Destroy a subvolume iterator
+ * previously created by btrfs_util_create_subvolume_iterator().
+ * @iter: Iterator to destroy.
+ */
+void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_iterator *iter);
+
+/**
+ * btrfs_util_subvolume_iterator_fd() - Get the file descriptor associated with
+ * a subvolume iterator.
+ * @iter: Iterator to get.
+ *
+ * This can be used to get the file descriptor opened by
+ * btrfs_util_create_subvolume_iterator() in order to use it for other
+ * functions.
+ *
+ * Return: File descriptor.
+ */
+int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_iterator *iter);
+
+/**
+ * btrfs_util_subvolume_iterator_next() - Get the next subvolume from a
+ * subvolume iterator.
+ * @iter: Subvolume iterator.
+ * @path_ret: Returned subvolume path, relative to the subvolume ID used to
+ * create the iterator. May be %NULL.
+ * Must be freed with free().
+ * @id_ret: Returned subvolume ID. May be %NULL.
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: %BTRFS_UTIL_OK on success, %BTRFS_UTIL_ERROR_STOP_ITERATION if there
+ * are no more subvolumes, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
+							 char **path_ret,
+							 uint64_t *id_ret);
+
+/**
+ * btrfs_util_subvolume_iterator_next_info() - Get information about the next
+ * subvolume for a subvolume iterator.
+ * @iter: Subvolume iterator.
+ * @path_ret: See btrfs_util_subvolume_iterator_next().
+ * @subvol: Returned subvolume information.
+ *
+ * This convenience function basically combines
+ * btrfs_util_subvolume_iterator_next() and btrfs_util_subvolume_info().
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: See btrfs_util_subvolume_iterator_next().
+ */
+enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_subvolume_iterator *iter,
+							      char **path_ret,
+							      struct btrfs_util_subvolume_info *subvol);
+
 /**
  * btrfs_util_create_qgroup_inherit() - Create a qgroup inheritance specifier
  * for btrfs_util_create_subvolume() or btrfs_util_create_snapshot().
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index 41314d4a..a9c15219 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -37,6 +37,7 @@ typedef struct {
 extern PyTypeObject BtrfsUtilError_type;
 extern PyStructSequence_Desc SubvolumeInfo_desc;
 extern PyTypeObject SubvolumeInfo_type;
+extern PyTypeObject SubvolumeIterator_type;
 extern PyTypeObject QgroupInherit_type;
 
 /*
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 0ac4d63a..daf0747f 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -218,6 +218,10 @@ PyInit_btrfsutil(void)
 	if (PyStructSequence_InitType2(&SubvolumeInfo_type, &SubvolumeInfo_desc) < 0)
 		return NULL;
 
+	SubvolumeIterator_type.tp_new = PyType_GenericNew;
+	if (PyType_Ready(&SubvolumeIterator_type) < 0)
+		return NULL;
+
 	QgroupInherit_type.tp_new = PyType_GenericNew;
 	if (PyType_Ready(&QgroupInherit_type) < 0)
 		return NULL;
@@ -233,6 +237,10 @@ PyInit_btrfsutil(void)
 	Py_INCREF(&SubvolumeInfo_type);
 	PyModule_AddObject(m, "SubvolumeInfo", (PyObject *)&SubvolumeInfo_type);
 
+	Py_INCREF(&SubvolumeIterator_type);
+	PyModule_AddObject(m, "SubvolumeIterator",
+			   (PyObject *)&SubvolumeIterator_type);
+
 	Py_INCREF(&QgroupInherit_type);
 	PyModule_AddObject(m, "QgroupInherit",
 			   (PyObject *)&QgroupInherit_type);
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index fa3ec4a7..6c384583 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -348,3 +348,214 @@ PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 	else
 		Py_RETURN_NONE;
 }
+
+typedef struct {
+	PyObject_HEAD
+	struct btrfs_util_subvolume_iterator *iter;
+	bool info;
+} SubvolumeIterator;
+
+static void SubvolumeIterator_dealloc(SubvolumeIterator *self)
+{
+	btrfs_util_destroy_subvolume_iterator(self->iter);
+	Py_TYPE(self)->tp_free((PyObject *)self);
+}
+
+static PyObject *SubvolumeIterator_next(SubvolumeIterator *self)
+{
+	enum btrfs_util_error err;
+	PyObject *ret, *tmp;
+	char *path;
+
+	if (!self->iter) {
+		PyErr_SetString(PyExc_ValueError,
+				"operation on closed iterator");
+		return NULL;
+	}
+
+	if (self->info) {
+		struct btrfs_util_subvolume_info subvol;
+
+		err = btrfs_util_subvolume_iterator_next_info(self->iter, &path,
+							      &subvol);
+		if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+			PyErr_SetNone(PyExc_StopIteration);
+			return NULL;
+		} else if (err) {
+			SetFromBtrfsUtilError(err);
+			return NULL;
+		}
+
+		tmp = subvolume_info_to_object(&subvol);
+	} else {
+		uint64_t id;
+
+		err = btrfs_util_subvolume_iterator_next(self->iter, &path, &id);
+		if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+			PyErr_SetNone(PyExc_StopIteration);
+			return NULL;
+		} else if (err) {
+			SetFromBtrfsUtilError(err);
+			return NULL;
+		}
+
+		tmp = PyLong_FromUnsignedLongLong(id);
+
+	}
+	if (tmp) {
+		ret = Py_BuildValue("O&O", PyUnicode_DecodeFSDefault, path,
+				    tmp);
+		Py_DECREF(tmp);
+		free(path);
+	} else {
+		ret = NULL;
+	}
+	return ret;
+}
+
+static int SubvolumeIterator_init(SubvolumeIterator *self, PyObject *args,
+				  PyObject *kwds)
+{
+	static char *keywords[] = {"path", "top", "info", "post_order", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	unsigned long long top = 5;
+	int info = 0;
+	int post_order = 0;
+	int flags = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|Kpp:SubvolumeIterator",
+					 keywords, &path_converter, &path, &top,
+					 &info, &post_order))
+		return -1;
+
+	if (post_order)
+		flags |= BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER;
+
+	if (path.path) {
+		err = btrfs_util_create_subvolume_iterator(path.path, top,
+							   flags, &self->iter);
+	} else {
+		err = btrfs_util_create_subvolume_iterator_fd(path.fd, top,
+							      flags,
+							      &self->iter);
+	}
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return -1;
+	}
+
+	self->info = info;
+
+	return 0;
+}
+
+static PyObject *SubvolumeIterator_close(SubvolumeIterator *self)
+{
+	if (self->iter) {
+		btrfs_util_destroy_subvolume_iterator(self->iter);
+		self->iter = NULL;
+	}
+	Py_RETURN_NONE;
+}
+
+static PyObject *SubvolumeIterator_fileno(SubvolumeIterator *self)
+{
+	if (!self->iter) {
+		PyErr_SetString(PyExc_ValueError,
+				"operation on closed iterator");
+		return NULL;
+	}
+	return PyLong_FromLong(btrfs_util_subvolume_iterator_fd(self->iter));
+}
+
+static PyObject *SubvolumeIterator_enter(SubvolumeIterator *self)
+{
+	Py_INCREF((PyObject *)self);
+	return (PyObject *)self;
+}
+
+static PyObject *SubvolumeIterator_exit(SubvolumeIterator *self, PyObject *args,
+				       PyObject *kwds)
+{
+	static char *keywords[] = {"exc_type", "exc_value", "traceback", NULL};
+	PyObject *exc_type, *exc_value, *traceback;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "OOO:__exit__", keywords,
+					 &exc_type, &exc_value, &traceback))
+		return NULL;
+
+	return SubvolumeIterator_close(self);
+}
+
+#define SubvolumeIterator_DOC	\
+	 "SubvolumeIterator(path, top=0, info=False, post_order=False) -> new subvolume iterator\n\n"	\
+	 "Create a new iterator that produces tuples of (path, ID) representing\n"	\
+	 "subvolumes on a filesystem.\n\n"						\
+	 "Arguments:\n"									\
+	 "path -- string, bytes, path-like object, or open file descriptor in\n"	\
+	 "filesystem to list\n"								\
+	 "top -- if not zero, instead of only listing subvolumes beneath the\n"		\
+	 "given path, list subvolumes beneath the subvolume with this ID; passing\n"	\
+	 "BTRFS_FS_TREE_OBJECTID (5) here lists all subvolumes. The subvolumes\n"	\
+	 "are listed relative to the subvolume with this ID.\n"				\
+	 "info -- bool indicating the iterator should yield SubvolumeInfo instead of\n"	\
+	 "the subvolume ID\n"								\
+	 "post_order -- bool indicating whether to yield parent subvolumes before\n"	\
+	 "child subvolumes (e.g., 'foo/bar' before 'foo')"
+
+static PyMethodDef SubvolumeIterator_methods[] = {
+	{"close", (PyCFunction)SubvolumeIterator_close,
+	 METH_NOARGS,
+	 "close()\n\n"
+	 "Close this iterator."},
+	{"fileno", (PyCFunction)SubvolumeIterator_fileno,
+	 METH_NOARGS,
+	 "fileno() -> int\n\n"
+	 "Get the file descriptor associated with this iterator."},
+	{"__enter__", (PyCFunction)SubvolumeIterator_enter,
+	 METH_NOARGS, ""},
+	{"__exit__", (PyCFunction)SubvolumeIterator_exit,
+	 METH_VARARGS | METH_KEYWORDS, ""},
+	{},
+};
+
+PyTypeObject SubvolumeIterator_type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	"btrfsutil.SubvolumeIterator",		/* tp_name */
+	sizeof(SubvolumeIterator),		/* tp_basicsize */
+	0,					/* tp_itemsize */
+	(destructor)SubvolumeIterator_dealloc,	/* tp_dealloc */
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
+	NULL,					/* tp_getattro */
+	NULL,					/* tp_setattro */
+	NULL,					/* tp_as_buffer */
+	Py_TPFLAGS_DEFAULT,			/* tp_flags */
+	SubvolumeIterator_DOC,			/* tp_doc */
+	NULL,					/* tp_traverse */
+	NULL,					/* tp_clear */
+	NULL,					/* tp_richcompare */
+	0,					/* tp_weaklistoffset */
+	PyObject_SelfIter,			/* tp_iter */
+	(iternextfunc)SubvolumeIterator_next,	/* tp_iternext */
+	SubvolumeIterator_methods,		/* tp_methods */
+	NULL,					/* tp_members */
+	NULL,					/* tp_getset */
+	NULL,					/* tp_base */
+	NULL,					/* tp_dict */
+	NULL,					/* tp_descr_get */
+	NULL,					/* tp_descr_set */
+	0,					/* tp_dictoffset */
+	(initproc)SubvolumeIterator_init,	/* tp_init */
+};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 937a4397..b43beca7 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -214,3 +214,59 @@ class TestSubvolume(BtrfsTestCase):
         wstatus = os.waitpid(pid, 0)[1]
         self.assertTrue(os.WIFEXITED(wstatus))
         self.assertEqual(os.WEXITSTATUS(wstatus), 0)
+
+    def test_subvolume_iterator(self):
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            btrfsutil.create_subvolume('foo')
+
+            path, subvol = next(btrfsutil.SubvolumeIterator('.', info=True))
+            self.assertEqual(path, 'foo')
+            self.assertIsInstance(subvol, btrfsutil.SubvolumeInfo)
+            self.assertEqual(subvol.id, 256)
+            self.assertEqual(subvol.parent_id, 5)
+
+            btrfsutil.create_subvolume('foo/bar')
+            btrfsutil.create_subvolume('foo/bar/baz')
+
+            subvols = [
+                ('foo', 256),
+                ('foo/bar', 257),
+                ('foo/bar/baz', 258),
+            ]
+
+            for arg in self.path_or_fd('.'):
+                with self.subTest(type=type(arg)):
+                    self.assertEqual(list(btrfsutil.SubvolumeIterator(arg)), subvols)
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=0)), subvols)
+
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', post_order=True)),
+                             [('foo/bar/baz', 258),
+                              ('foo/bar', 257),
+                              ('foo', 256)])
+
+            subvols = [
+                ('bar', 257),
+                ('bar/baz', 258),
+            ]
+
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=256)), subvols)
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo', top=0)), subvols)
+
+            os.rename('foo/bar/baz', 'baz')
+            self.assertEqual(sorted(btrfsutil.SubvolumeIterator('.')),
+                             [('baz', 258),
+                              ('foo', 256),
+                              ('foo/bar', 257)])
+
+            with btrfsutil.SubvolumeIterator('.') as it:
+                self.assertGreaterEqual(it.fileno(), 0)
+                it.close()
+                with self.assertRaises(ValueError):
+                    next(iter(it))
+                with self.assertRaises(ValueError):
+                    it.fileno()
+                it.close()
+        finally:
+            os.chdir(pwd)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index b3f768ed..5744f89f 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -691,3 +691,320 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
 
 	return BTRFS_UTIL_OK;
 }
+
+#define BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD (1 << 30)
+
+struct search_stack_entry {
+	struct btrfs_ioctl_search_args search;
+	size_t items_pos, buf_off;
+	size_t path_len;
+};
+
+struct btrfs_util_subvolume_iterator {
+	int fd;
+	int flags;
+
+	struct search_stack_entry *search_stack;
+	size_t search_stack_len;
+	size_t search_stack_capacity;
+
+	char *cur_path;
+	size_t cur_path_capacity;
+};
+
+static enum btrfs_util_error append_to_search_stack(struct btrfs_util_subvolume_iterator *iter,
+						    uint64_t tree_id,
+						    size_t path_len)
+{
+	struct search_stack_entry *entry;
+
+	if (iter->search_stack_len >= iter->search_stack_capacity) {
+		size_t new_capacity = iter->search_stack_capacity * 2;
+		struct search_stack_entry *new_search_stack;
+
+		new_search_stack = reallocarray(iter->search_stack,
+						new_capacity,
+						sizeof(*iter->search_stack));
+		if (!new_search_stack)
+			return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+		iter->search_stack_capacity = new_capacity;
+		iter->search_stack = new_search_stack;
+	}
+
+	entry = &iter->search_stack[iter->search_stack_len++];
+
+	memset(&entry->search, 0, sizeof(entry->search));
+	entry->search.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	entry->search.key.min_objectid = tree_id;
+	entry->search.key.max_objectid = tree_id;
+	entry->search.key.min_type = BTRFS_ROOT_REF_KEY;
+	entry->search.key.max_type = BTRFS_ROOT_REF_KEY;
+	entry->search.key.min_offset = 0;
+	entry->search.key.max_offset = UINT64_MAX;
+	entry->search.key.min_transid = 0;
+	entry->search.key.max_transid = UINT64_MAX;
+	entry->search.key.nr_items = 0;
+
+	entry->items_pos = 0;
+	entry->buf_off = 0;
+
+	entry->path_len = path_len;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator(const char *path,
+								  uint64_t top,
+								  int flags,
+								  struct btrfs_util_subvolume_iterator **ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_create_subvolume_iterator_fd(fd, top, flags, ret);
+	if (err == BTRFS_UTIL_OK)
+		(*ret)->flags |= BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD;
+
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
+								     uint64_t top,
+								     int flags,
+								     struct btrfs_util_subvolume_iterator **ret)
+{
+	struct btrfs_util_subvolume_iterator *iter;
+	enum btrfs_util_error err;
+
+	if (flags & ~BTRFS_UTIL_SUBVOLUME_ITERATOR_MASK) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+
+	if (top == 0) {
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err)
+			return err;
+
+		err = btrfs_util_subvolume_id_fd(fd, &top);
+		if (err)
+			return err;
+	}
+
+	iter = malloc(sizeof(*iter));
+	if (!iter)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+	iter->fd = fd;
+	iter->flags = flags;
+
+	iter->search_stack_len = 0;
+	iter->search_stack_capacity = 4;
+	iter->search_stack = malloc(sizeof(*iter->search_stack) *
+				    iter->search_stack_capacity);
+	if (!iter->search_stack) {
+		err = BTRFS_UTIL_ERROR_NO_MEMORY;
+		goto out_iter;
+	}
+
+	iter->cur_path_capacity = 256;
+	iter->cur_path = malloc(iter->cur_path_capacity);
+	if (!iter->cur_path) {
+		err = BTRFS_UTIL_ERROR_NO_MEMORY;
+		goto out_search_stack;
+	}
+
+	err = append_to_search_stack(iter, top, 0);
+	if (err)
+		goto out_cur_path;
+
+	*ret = iter;
+
+	return BTRFS_UTIL_OK;
+
+out_cur_path:
+	free(iter->cur_path);
+out_search_stack:
+	free(iter->search_stack);
+out_iter:
+	free(iter);
+	return err;
+}
+
+PUBLIC void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_iterator *iter)
+{
+	if (iter) {
+		free(iter->cur_path);
+		free(iter->search_stack);
+		if (iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD)
+			SAVE_ERRNO_AND_CLOSE(iter->fd);
+		free(iter);
+	}
+}
+
+PUBLIC int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_iterator *iter)
+{
+	return iter->fd;
+}
+
+static struct search_stack_entry *top_search_stack_entry(struct btrfs_util_subvolume_iterator *iter)
+{
+	return &iter->search_stack[iter->search_stack_len - 1];
+}
+
+static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_iterator *iter,
+					       const struct btrfs_ioctl_search_header *header,
+					       const struct btrfs_root_ref *ref,
+					       const char *name,
+					       size_t *path_len_ret)
+{
+	struct btrfs_ioctl_ino_lookup_args lookup = {
+		.treeid = header->objectid,
+		.objectid = le64_to_cpu(ref->dirid),
+	};
+	struct search_stack_entry *top = top_search_stack_entry(iter);
+	size_t dir_len, name_len, path_len;
+	char *p;
+	int ret;
+
+	ret = ioctl(iter->fd, BTRFS_IOC_INO_LOOKUP, &lookup);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED;
+
+	dir_len = strlen(lookup.name);
+	name_len = le16_to_cpu(ref->name_len);
+
+	path_len = top->path_len;
+	/*
+	 * We need a joining slash if we have a current path and a subdirectory.
+	 */
+	if (top->path_len && dir_len)
+		path_len++;
+	path_len += dir_len;
+	/*
+	 * We need another joining slash if we have a current path and a name,
+	 * but not if we have a subdirectory, because the lookup ioctl includes
+	 * a trailing slash.
+	 */
+	if (top->path_len && !dir_len && name_len)
+		path_len++;
+	path_len += name_len;
+
+	if (path_len > iter->cur_path_capacity) {
+		char *tmp = realloc(iter->cur_path, path_len);
+
+		if (!tmp)
+			return BTRFS_UTIL_ERROR_NO_MEMORY;
+		iter->cur_path = tmp;
+		iter->cur_path_capacity = path_len;
+	}
+
+	p = iter->cur_path + top->path_len;
+	if (top->path_len && dir_len)
+		*p++ = '/';
+	memcpy(p, lookup.name, dir_len);
+	p += dir_len;
+	if (top->path_len && !dir_len && name_len)
+		*p++ = '/';
+	memcpy(p, name, name_len);
+	p += name_len;
+
+	*path_len_ret = path_len;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
+								char **path_ret,
+								uint64_t *id_ret)
+{
+	struct search_stack_entry *top;
+	const struct btrfs_ioctl_search_header *header;
+	const struct btrfs_root_ref *ref;
+	const char *name;
+	enum btrfs_util_error err;
+	size_t path_len;
+	int ret;
+
+	for (;;) {
+		for (;;) {
+			if (iter->search_stack_len == 0)
+				return BTRFS_UTIL_ERROR_STOP_ITERATION;
+
+			top = top_search_stack_entry(iter);
+			if (top->items_pos < top->search.key.nr_items) {
+				break;
+			} else {
+				top->search.key.nr_items = 4096;
+				ret = ioctl(iter->fd, BTRFS_IOC_TREE_SEARCH, &top->search);
+				if (ret == -1)
+					return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+				top->items_pos = 0;
+				top->buf_off = 0;
+
+				if (top->search.key.nr_items == 0) {
+					iter->search_stack_len--;
+					if ((iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) &&
+					    iter->search_stack_len)
+						goto out;
+				}
+			}
+		}
+
+		header = (struct btrfs_ioctl_search_header *)(top->search.buf + top->buf_off);
+
+		top->items_pos++;
+		top->buf_off += sizeof(*header) + header->len;
+		top->search.key.min_offset = header->offset + 1;
+
+		/* This shouldn't happen, but handle it just in case. */
+		if (header->type != BTRFS_ROOT_REF_KEY)
+			continue;
+
+		ref = (struct btrfs_root_ref *)(header + 1);
+		name = (const char *)(ref + 1);
+		err = build_subvol_path(iter, header, ref, name, &path_len);
+		if (err)
+			return err;
+
+		err = append_to_search_stack(iter, header->offset, path_len);
+		if (err)
+			return err;
+
+		if (!(iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER)) {
+			top = top_search_stack_entry(iter);
+			goto out;
+		}
+	}
+
+out:
+	if (path_ret) {
+		*path_ret = malloc(top->path_len + 1);
+		if (!*path_ret)
+			return BTRFS_UTIL_ERROR_NO_MEMORY;
+		memcpy(*path_ret, iter->cur_path, top->path_len);
+		(*path_ret)[top->path_len] = '\0';
+	}
+	if (id_ret)
+		*id_ret = top->search.key.min_objectid;
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_subvolume_iterator *iter,
+								     char **path_ret,
+								     struct btrfs_util_subvolume_info *subvol)
+{
+	enum btrfs_util_error err;
+	uint64_t id;
+
+	err = btrfs_util_subvolume_iterator_next(iter, path_ret, &id);
+	if (err)
+		return err;
+
+	return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+}
-- 
2.16.1


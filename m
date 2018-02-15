Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38240 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167163AbeBOTFm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:42 -0500
Received: by mail-pl0-f65.google.com with SMTP id h10so351106plt.5
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:42 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 14/27] libbtrfsutil: add btrfs_util_deleted_subvolumes()
Date: Thu, 15 Feb 2018 11:04:59 -0800
Message-Id: <ac64e7314e3f716898dd8a7ec7c7657f66ee4c4a.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    | 21 +++++++
 libbtrfsutil/python/btrfsutilpy.h           |  3 +
 libbtrfsutil/python/module.c                | 30 ++++++++++
 libbtrfsutil/python/qgroup.c                | 17 +-----
 libbtrfsutil/python/subvolume.c             | 30 ++++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  8 +++
 libbtrfsutil/subvolume.c                    | 89 +++++++++++++++++++++++++++++
 7 files changed, 183 insertions(+), 15 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 00c86174..677ab3c1 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -534,6 +534,27 @@ enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_
 							      char **path_ret,
 							      struct btrfs_util_subvolume_info *subvol);
 
+/**
+ * btrfs_util_deleted_subvolumes() - Get a list of subvolume which have been
+ * deleted but not yet cleaned up.
+ * @path: Path on a Btrfs filesystem.
+ * @ids: Returned array of subvolume IDs.
+ * @n: Returned number of IDs in the @ids array.
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_deleted_subvolumes(const char *path,
+						    uint64_t **ids,
+						    size_t *n);
+
+/**
+ * btrfs_util_deleted_subvolumes_fd() - See btrfs_util_deleted_subvolumes().
+ */
+enum btrfs_util_error btrfs_util_deleted_subvolumes_fd(int fd, uint64_t **ids,
+						       size_t *n);
+
 /**
  * btrfs_util_create_qgroup_inherit() - Create a qgroup inheritance specifier
  * for btrfs_util_create_subvolume() or btrfs_util_create_snapshot().
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index b3ec047f..be5122e2 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -54,6 +54,8 @@ struct path_arg {
 int path_converter(PyObject *o, void *p);
 void path_cleanup(struct path_arg *path);
 
+PyObject *list_from_uint64_array(const uint64_t *arr, size_t n);
+
 void SetFromBtrfsUtilError(enum btrfs_util_error err);
 void SetFromBtrfsUtilErrorWithPath(enum btrfs_util_error err,
 				   struct path_arg *path);
@@ -72,6 +74,7 @@ PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *delete_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *deleted_subvolumes(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index e995a1be..eaa062ac 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -125,6 +125,29 @@ err:
 	return 0;
 }
 
+PyObject *list_from_uint64_array(const uint64_t *arr, size_t n)
+{
+    PyObject *ret;
+    size_t i;
+
+    ret = PyList_New(n);
+    if (!ret)
+	    return NULL;
+
+    for (i = 0; i < n; i++) {
+	    PyObject *tmp;
+
+	    tmp = PyLong_FromUnsignedLongLong(arr[i]);
+	    if (!tmp) {
+		    Py_DECREF(ret);
+		    return NULL;
+	    }
+	    PyList_SET_ITEM(ret, i, tmp);
+    }
+
+    return ret;
+}
+
 void path_cleanup(struct path_arg *path)
 {
 	Py_CLEAR(path->object);
@@ -214,6 +237,13 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "path -- string, bytes, or path-like object\n"
 	 "recursive -- if the given subvolume has child subvolumes, delete\n"
 	 "them instead of failing"},
+	{"deleted_subvolumes", (PyCFunction)deleted_subvolumes,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "deleted_subvolumes(path)\n\n"
+	 "Get the list of subvolume IDs which have been deleted but not yet\n"
+	 "cleaned up\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
 	{},
 };
 
diff --git a/libbtrfsutil/python/qgroup.c b/libbtrfsutil/python/qgroup.c
index 69716d92..44ac5ebc 100644
--- a/libbtrfsutil/python/qgroup.c
+++ b/libbtrfsutil/python/qgroup.c
@@ -55,25 +55,12 @@ static PyObject *QgroupInherit_getattro(QgroupInherit *self, PyObject *nameobj)
     }
 
     if (strcmp(name, "groups") == 0) {
-	    PyObject *ret, *tmp;
 	    const uint64_t *arr;
-	    size_t n, i;
+	    size_t n;
 
 	    btrfs_util_qgroup_inherit_get_groups(self->inherit, &arr, &n);
-	    ret = PyList_New(n);
-	    if (!ret)
-		    return NULL;
-
-	    for (i = 0; i < n; i++) {
-		    tmp = PyLong_FromUnsignedLongLong(arr[i]);
-		    if (!tmp) {
-			    Py_DECREF(ret);
-			    return NULL;
-		    }
-		    PyList_SET_ITEM(ret, i, tmp);
-	    }
 
-	    return ret;
+	    return list_from_uint64_array(arr, n);
     } else {
 	    return PyObject_GenericGetAttr((PyObject *)self, nameobj);
     }
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index eb3f6e27..069e606b 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -425,6 +425,36 @@ PyObject *delete_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 	Py_RETURN_NONE;
 }
 
+PyObject *deleted_subvolumes(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	PyObject *ret;
+	uint64_t *ids;
+	size_t n;
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:deleted_subvolumes",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_deleted_subvolumes(path.path, &ids, &n);
+	else
+		err = btrfs_util_deleted_subvolumes_fd(path.fd, &ids, &n);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+
+	ret = list_from_uint64_array(ids, n);
+	free(ids);
+	return ret;
+}
+
 typedef struct {
 	PyObject_HEAD
 	struct btrfs_util_subvolume_iterator *iter;
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 08083abe..a46d4a34 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -318,6 +318,14 @@ class TestSubvolume(BtrfsTestCase):
         btrfsutil.delete_subvolume(subvol + '5', recursive=True)
         self.assertFalse(os.path.exists(subvol + '5'))
 
+    def test_deleted_subvolumes(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol + '1')
+        btrfsutil.delete_subvolume(subvol + '1')
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.deleted_subvolumes(arg), [256])
+
     def test_subvolume_iterator(self):
         pwd = os.getcwd()
         try:
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 908e71db..4ae581b2 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1277,3 +1277,92 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrf
 
 	return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
 }
+
+PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes(const char *path,
+							   uint64_t **ids,
+							   size_t *n)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_deleted_subvolumes_fd(fd, ids, n);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes_fd(int fd,
+							      uint64_t **ids,
+							      size_t *n)
+{
+	size_t capacity = 0;
+	struct btrfs_ioctl_search_args search = {
+		.key = {
+			.tree_id = BTRFS_ROOT_TREE_OBJECTID,
+			.min_objectid = BTRFS_ORPHAN_OBJECTID,
+			.max_objectid = BTRFS_ORPHAN_OBJECTID,
+			.min_type = BTRFS_ORPHAN_ITEM_KEY,
+			.max_type = BTRFS_ORPHAN_ITEM_KEY,
+			.min_offset = 0,
+			.max_offset = UINT64_MAX,
+			.min_transid = 0,
+			.max_transid = UINT64_MAX,
+			.nr_items = 0,
+		},
+	};
+	enum btrfs_util_error err;
+	size_t items_pos = 0, buf_off = 0;
+	int ret;
+
+	*ids = NULL;
+	*n = 0;
+	for (;;) {
+		const struct btrfs_ioctl_search_header *header;
+
+		if (items_pos >= search.key.nr_items) {
+			search.key.nr_items = 4096;
+			ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search);
+			if (ret == -1) {
+				err = BTRFS_UTIL_ERROR_SEARCH_FAILED;
+				goto out;
+			}
+			items_pos = 0;
+			buf_off = 0;
+
+			if (search.key.nr_items == 0)
+				break;
+		}
+
+		header = (struct btrfs_ioctl_search_header *)(search.buf + buf_off);
+		if (*n >= capacity) {
+			size_t new_capacity = capacity ? capacity * 2 : 1;
+			uint64_t *new_ids;
+
+			new_ids = reallocarray(*ids, new_capacity,
+					       sizeof(**ids));
+			if (!new_ids)
+				return BTRFS_UTIL_ERROR_NO_MEMORY;
+
+			*ids = new_ids;
+			capacity = new_capacity;
+		}
+
+		(*ids)[(*n)++] = header->offset;
+
+		items_pos++;
+		buf_off += sizeof(*header) + header->len;
+		search.key.min_offset = header->offset + 1;
+	}
+
+	err = BTRFS_UTIL_OK;
+out:
+	if (err) {
+		free(ids);
+		*ids = NULL;
+		*n = 0;
+	}
+	return err;
+}
-- 
2.16.1


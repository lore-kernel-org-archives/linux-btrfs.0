Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38787 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167118AbeBOTFh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:37 -0500
Received: by mail-pg0-f67.google.com with SMTP id l24so505049pgc.5
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:37 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 10/27] libbtrfsutil: add btrfs_util_[gs]et_default_subvolume()
Date: Thu, 15 Feb 2018 11:04:55 -0800
Message-Id: <12357e01654532c78dccd2eb52edbdc7589d6ee6.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

set_default_subvolume() is a trivial ioctl(), but there's no ioctl() for
get_default_subvolume(), so we need to search the root tree.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  41 ++++++++++
 libbtrfsutil/python/btrfsutilpy.h           |   2 +
 libbtrfsutil/python/module.c                |  14 ++++
 libbtrfsutil/python/subvolume.c             |  50 ++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  14 ++++
 libbtrfsutil/subvolume.c                    | 113 ++++++++++++++++++++++++++++
 6 files changed, 234 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 8bd2b847..54777f1d 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -256,6 +256,8 @@ enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd, bool *ret);
  * @path: Subvolume path.
  * @read_only: New value of read-only flag.
  *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
  * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
  */
 enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
@@ -268,6 +270,45 @@ enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
 enum btrfs_util_error btrfs_util_set_subvolume_read_only_fd(int fd,
 							    bool read_only);
 
+/**
+ * btrfs_util_get_default_subvolume() - Get the default subvolume for a
+ * filesystem.
+ * @path: Path on a Btrfs filesystem.
+ * @id_ret: Returned subvolume ID.
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_get_default_subvolume(const char *path,
+						       uint64_t *id_ret);
+
+/**
+ * btrfs_util_get_default_subvolume_fd() - See
+ * btrfs_util_get_default_subvolume().
+ */
+enum btrfs_util_error btrfs_util_get_default_subvolume_fd(int fd,
+							  uint64_t *id_ret);
+
+/**
+ * btrfs_util_set_default_subvolume() - Set the default subvolume for a
+ * filesystem.
+ * @path: Path in a Btrfs filesystem. This may be any path in the filesystem; it
+ * does not have to refer to a subvolume unless @id is zero.
+ * @id: ID of subvolume to set as the default. If zero is given, the subvolume
+ * ID of @path is used.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_set_default_subvolume(const char *path,
+						       uint64_t id);
+
+/**
+ * btrfs_util_set_default_subvolume_fd() - See
+ * btrfs_util_set_default_subvolume().
+ */
+enum btrfs_util_error btrfs_util_set_default_subvolume_fd(int fd, uint64_t id);
+
 struct btrfs_util_qgroup_inherit;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index 21253e51..41314d4a 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -66,6 +66,8 @@ PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_info(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *get_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *get_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 3395fb14..0ac4d63a 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -173,6 +173,20 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "Arguments:\n"
 	 "path -- string, bytes, path-like object, or open file descriptor\n"
 	 "read_only -- bool flag value"},
+	{"get_default_subvolume", (PyCFunction)get_default_subvolume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "get_default_subvolume(path) -> int\n\n"
+	 "Get the ID of the default subvolume of a filesystem.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"set_default_subvolume", (PyCFunction)set_default_subvolume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "set_default_subvolume(path, id=0)\n\n"
+	 "Set the default subvolume of a filesystem.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "id -- if not zero, set the default subvolume to the subvolume with\n"
+	 "this ID instead of the given path"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "create_subvolume(path, async=False)\n\n"
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 76487865..fa3ec4a7 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -270,6 +270,56 @@ PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds
 	Py_RETURN_NONE;
 }
 
+PyObject *get_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	uint64_t id;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:get_default_subvolume",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_get_default_subvolume(path.path, &id);
+	else
+		err = btrfs_util_get_default_subvolume_fd(path.fd, &id);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	return PyLong_FromUnsignedLongLong(id);
+}
+
+PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "id", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	uint64_t id = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|K:set_default_subvolume",
+					 keywords, &path_converter, &path, &id))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_set_default_subvolume(path.path, id);
+	else
+		err = btrfs_util_set_default_subvolume_fd(path.fd, id);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	Py_RETURN_NONE;
+}
+
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 {
 	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 23871de9..937a4397 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -154,6 +154,20 @@ class TestSubvolume(BtrfsTestCase):
 
                 btrfsutil.set_subvolume_read_only(arg, False)
 
+    def test_default_subvolume(self):
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.get_default_subvolume(arg), 5)
+
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol)
+        for arg in self.path_or_fd(subvol):
+            with self.subTest(type=type(arg)):
+                btrfsutil.set_default_subvolume(arg)
+                self.assertEqual(btrfsutil.get_default_subvolume(arg), 256)
+                btrfsutil.set_default_subvolume(arg, 5)
+                self.assertEqual(btrfsutil.get_default_subvolume(arg), 5)
+
     def test_create_subvolume(self):
         subvol = os.path.join(self.mountpoint, 'subvol')
 
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index bc5b309e..b3f768ed 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -467,6 +467,119 @@ PUBLIC enum btrfs_util_error btrfs_util_set_subvolume_read_only_fd(int fd,
 	return BTRFS_UTIL_OK;
 }
 
+PUBLIC enum btrfs_util_error btrfs_util_get_default_subvolume(const char *path,
+							      uint64_t *id_ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_get_default_subvolume_fd(fd, id_ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_get_default_subvolume_fd(int fd,
+								 uint64_t *id_ret)
+{
+	struct btrfs_ioctl_search_args search = {
+		.key = {
+			.tree_id = BTRFS_ROOT_TREE_OBJECTID,
+			.min_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID,
+			.max_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID,
+			.min_type = BTRFS_DIR_ITEM_KEY,
+			.max_type = BTRFS_DIR_ITEM_KEY,
+			.min_offset = 0,
+			.max_offset = UINT64_MAX,
+			.min_transid = 0,
+			.max_transid = UINT64_MAX,
+			.nr_items = 0,
+		},
+	};
+	size_t items_pos = 0, buf_off = 0;
+	int ret;
+
+	for (;;) {
+		const struct btrfs_ioctl_search_header *header;
+
+		if (items_pos >= search.key.nr_items) {
+			search.key.nr_items = 4096;
+			ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search);
+			if (ret == -1)
+				return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+			items_pos = 0;
+			buf_off = 0;
+
+			if (search.key.nr_items == 0) {
+				errno = ENOENT;
+				return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+			}
+		}
+
+		header = (struct btrfs_ioctl_search_header *)(search.buf + buf_off);
+		if (header->type == BTRFS_DIR_ITEM_KEY) {
+			const struct btrfs_dir_item *dir;
+			const char *name;
+			uint16_t name_len;
+
+			dir = (struct btrfs_dir_item *)(header + 1);
+			name = (const char *)(dir + 1);
+			name_len = le16_to_cpu(dir->name_len);
+			if (strncmp(name, "default", name_len) == 0) {
+				*id_ret = le64_to_cpu(dir->location.objectid);
+				break;
+			}
+		}
+
+		items_pos++;
+		buf_off += sizeof(*header) + header->len;
+		search.key.min_offset = header->offset + 1;
+	}
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_set_default_subvolume(const char *path,
+							      uint64_t id)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_set_default_subvolume_fd(fd, id);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_set_default_subvolume_fd(int fd,
+								 uint64_t id)
+{
+	enum btrfs_util_error err;
+	int ret;
+
+	if (id == 0) {
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err)
+			return err;
+
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err)
+			return err;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &id);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_DEFAULT_SUBVOL_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
 						    char *name, size_t name_len,
 						    int *fd)
-- 
2.16.1


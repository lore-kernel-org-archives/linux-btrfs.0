Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36200 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161252AbeBOTFg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:36 -0500
Received: by mail-pg0-f67.google.com with SMTP id j9so509145pgv.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:36 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 09/27] libbtrfsutil: add btrfs_util_[gs]et_read_only()
Date: Thu, 15 Feb 2018 11:04:54 -0800
Message-Id: <06c14f992fb6bc7d27de9313e32ea0ee13fe8fe9.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In the future, btrfs_util_[gs]et_subvolume_flags() might be useful, but
since these are the only subvolume flags we've defined in all this time,
this will do for now.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    | 33 +++++++++++++++
 libbtrfsutil/python/btrfsutilpy.h           |  2 +
 libbtrfsutil/python/module.c                | 13 ++++++
 libbtrfsutil/python/subvolume.c             | 55 ++++++++++++++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py | 17 ++++++++
 libbtrfsutil/subvolume.c                    | 66 +++++++++++++++++++++++++++++
 6 files changed, 186 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 0d83dea9..8bd2b847 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -235,6 +235,39 @@ enum btrfs_util_error btrfs_util_subvolume_info(const char *path, uint64_t id,
 enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 						   struct btrfs_util_subvolume_info *subvol);
 
+/**
+ * btrfs_util_get_subvolume_read_only() - Get whether a subvolume is read-only.
+ * @path: Subvolume path.
+ * @ret: Returned read-only flag.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_get_subvolume_read_only(const char *path,
+							 bool *ret);
+
+/**
+ * btrfs_util_get_subvolume_read_only_fd() - See
+ * btrfs_util_get_subvolume_read_only().
+ */
+enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd, bool *ret);
+
+/**
+ * btrfs_util_set_subvolume_read_only() - Set whether a subvolume is read-only.
+ * @path: Subvolume path.
+ * @read_only: New value of read-only flag.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
+							 bool read_only);
+
+/**
+ * btrfs_util_set_subvolume_read_only_fd() - See
+ * btrfs_util_set_subvolume_read_only().
+ */
+enum btrfs_util_error btrfs_util_set_subvolume_read_only_fd(int fd,
+							    bool read_only);
+
 struct btrfs_util_qgroup_inherit;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index e601cb8b..21253e51 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -64,6 +64,8 @@ PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_info(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *get_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index b1469fc9..3395fb14 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -160,6 +160,19 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "path -- string, bytes, path-like object, or open file descriptor\n"
 	 "id -- if not zero, instead of returning information about the\n"
 	 "given path, return information about the subvolume with this ID"},
+	{"get_subvolume_read_only", (PyCFunction)get_subvolume_read_only,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "get_subvolume_read_only(path) -> bool\n\n"
+	 "Get whether a subvolume is read-only.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"set_subvolume_read_only", (PyCFunction)set_subvolume_read_only,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "set_subvolume_read_only(path, read_only=True)\n\n"
+	 "Set whether a subvolume is read-only.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "read_only -- bool flag value"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "create_subvolume(path, async=False)\n\n"
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 31b6ca2e..76487865 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -215,6 +215,61 @@ PyStructSequence_Desc SubvolumeInfo_desc = {
 
 PyTypeObject SubvolumeInfo_type;
 
+PyObject *get_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	bool read_only;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds,
+					 "O&:get_subvolume_read_only",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path) {
+		err = btrfs_util_get_subvolume_read_only(path.path, &read_only);
+	} else {
+		err = btrfs_util_get_subvolume_read_only_fd(path.fd,
+							    &read_only);
+	}
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	return PyBool_FromLong(read_only);
+}
+
+PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "read_only", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	int read_only = 1;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds,
+					 "O&|p:set_subvolume_read_only",
+					 keywords, &path_converter, &path,
+					 &read_only))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_set_subvolume_read_only(path.path, read_only);
+	else
+		err = btrfs_util_set_subvolume_read_only_fd(path.fd, read_only);
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
index ecb0d7ae..23871de9 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -137,6 +137,23 @@ class TestSubvolume(BtrfsTestCase):
                     # BTRFS_EXTENT_TREE_OBJECTID
                     btrfsutil.subvolume_info(arg, 2)
 
+    def test_read_only(self):
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                btrfsutil.set_subvolume_read_only(arg)
+                self.assertTrue(btrfsutil.get_subvolume_read_only(arg))
+                self.assertTrue(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, False)
+                self.assertFalse(btrfsutil.get_subvolume_read_only(arg))
+                self.assertFalse(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, True)
+                self.assertTrue(btrfsutil.get_subvolume_read_only(arg))
+                self.assertTrue(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, False)
+
     def test_create_subvolume(self):
         subvol = os.path.join(self.mountpoint, 'subvol')
 
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 69bc790a..bc5b309e 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -401,6 +401,72 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+PUBLIC enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd,
+								   bool *read_only_ret)
+{
+	uint64_t flags;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_GETFLAGS_FAILED;
+
+	*read_only_ret = flags & BTRFS_SUBVOL_RDONLY;
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_get_subvolume_read_only(const char *path,
+								bool *ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_get_subvolume_read_only_fd(fd, ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
+								bool read_only)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_set_subvolume_read_only_fd(fd, read_only);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_set_subvolume_read_only_fd(int fd,
+								   bool read_only)
+{
+	uint64_t flags;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_GETFLAGS_FAILED;
+
+	if (read_only)
+		flags |= BTRFS_SUBVOL_RDONLY;
+	else
+		flags &= ~BTRFS_SUBVOL_RDONLY;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_SETFLAGS_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
 						    char *name, size_t name_len,
 						    int *fd)
-- 
2.16.1


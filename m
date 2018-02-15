Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:39511 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161140AbeBOTFe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:34 -0500
Received: by mail-pg0-f65.google.com with SMTP id w17so502202pgv.6
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:34 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 07/27] libbtrfsutil: add btrfs_util_subvolume_path()
Date: Thu, 15 Feb 2018 11:04:52 -0800
Message-Id: <af89178dc6f35fe6a807aec6fecc0611ae99b3fb.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We can just walk up root backrefs with BTRFS_IOC_TREE_SEARCH and inode
paths with BTRFS_IOC_INO_LOOKUP.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  21 +++++
 libbtrfsutil/python/btrfsutilpy.h           |   2 +-
 libbtrfsutil/python/module.c                |   8 ++
 libbtrfsutil/python/subvolume.c             |  30 +++++++
 libbtrfsutil/python/tests/test_subvolume.py |  31 +++++++
 libbtrfsutil/subvolume.c                    | 125 ++++++++++++++++++++++++++++
 6 files changed, 216 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 5d67f111..f96c9c4e 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -103,6 +103,27 @@ enum btrfs_util_error btrfs_util_subvolume_id(const char *path,
  */
 enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd, uint64_t *id_ret);
 
+/**
+ * btrfs_util_subvolume_path() - Get the path of the subvolume with a given ID
+ * relative to the filesystem root.
+ * @path: Path on a Btrfs filesystem.
+ * @id: ID of subvolume to set as the default. If zero is given, the subvolume
+ * ID of @path is used.
+ * @path_ret: Returned path.
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_subvolume_path(const char *path, uint64_t id,
+						char **path_ret);
+
+/**
+ * btrfs_util_subvolume_path_fd() - See btrfs_util_subvolume_path().
+ */
+enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
+						   char **path_ret);
+
 struct btrfs_util_qgroup_inherit;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index 87d47ae0..ffd62ba7 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -60,7 +60,7 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 
 PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
-PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 69bba704..444516b1 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -144,6 +144,14 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "Get the ID of the subvolume containing a file.\n\n"
 	 "Arguments:\n"
 	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"subvolume_path", (PyCFunction)subvolume_path,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "subvolume_path(path, id=0) -> int\n\n"
+	 "Get the path of a subvolume relative to the filesystem root.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "id -- if not zero, instead of returning the subvolume path of the\n"
+	 "given path, return the path of the subvolume with this ID"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "create_subvolume(path, async=False)\n\n"
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 6f2080ee..6382d290 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -72,6 +72,36 @@ PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds)
 	return PyLong_FromUnsignedLongLong(id);
 }
 
+PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "id", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	uint64_t id = 0;
+	char *subvol_path;
+	PyObject *ret;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|K:subvolume_path",
+					 keywords, &path_converter, &path, &id))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_subvolume_path(path.path, id, &subvol_path);
+	else
+		err = btrfs_util_subvolume_path_fd(path.fd, id, &subvol_path);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+
+	ret = PyUnicode_DecodeFSDefault(subvol_path);
+	free(subvol_path);
+	return ret;
+}
+
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 {
 	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index f6c5958d..57ba27bf 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -56,6 +56,37 @@ class TestSubvolume(BtrfsTestCase):
             with self.subTest(type=type(arg)):
                 self.assertEqual(btrfsutil.subvolume_id(arg), 5)
 
+    def test_subvolume_path(self):
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'subvol1'))
+        os.mkdir(os.path.join(self.mountpoint, 'dir1'))
+        os.mkdir(os.path.join(self.mountpoint, 'dir1/dir2'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'dir1/dir2/subvol2'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'dir1/dir2/subvol2/subvol3'))
+        os.mkdir(os.path.join(self.mountpoint, 'subvol1/dir3'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'subvol1/dir3/subvol4'))
+
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.subvolume_path(arg), '')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 5), '')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 256), 'subvol1')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 257), 'dir1/dir2/subvol2')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 258), 'dir1/dir2/subvol2/subvol3')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 259), 'subvol1/dir3/subvol4')
+
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            path = ''
+            for i in range(26):
+                name = chr(ord('a') + i) * 255
+                path = os.path.join(path, name)
+                btrfsutil.create_subvolume(name)
+                os.chdir(name)
+            self.assertEqual(btrfsutil.subvolume_path('.'), path)
+        finally:
+            os.chdir(pwd)
+
     def test_create_subvolume(self):
         subvol = os.path.join(self.mountpoint, 'subvol')
 
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 8efbdd43..54a63b52 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -128,6 +128,131 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd,
 	return BTRFS_UTIL_OK;
 }
 
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_path(const char *path,
+						       uint64_t id,
+						       char **path_ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_subvolume_path_fd(fd, id, path_ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
+							  char **path_ret)
+{
+	char *path, *p;
+	size_t capacity = 4096;
+
+	path = malloc(capacity);
+	if (!path)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+	p = path + capacity - 1;
+	p[0] = '\0';
+
+	if (id == 0) {
+		enum btrfs_util_error err;
+
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err)
+			return err;
+
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err)
+			return err;
+	}
+
+	while (id != BTRFS_FS_TREE_OBJECTID) {
+		struct btrfs_ioctl_search_args search = {
+			.key = {
+				.tree_id = BTRFS_ROOT_TREE_OBJECTID,
+				.min_objectid = id,
+				.max_objectid = id,
+				.min_type = BTRFS_ROOT_BACKREF_KEY,
+				.max_type = BTRFS_ROOT_BACKREF_KEY,
+				.min_offset = 0,
+				.max_offset = UINT64_MAX,
+				.min_transid = 0,
+				.max_transid = UINT64_MAX,
+				.nr_items = 1,
+			},
+		};
+		struct btrfs_ioctl_ino_lookup_args lookup;
+		const struct btrfs_ioctl_search_header *header;
+		const struct btrfs_root_ref *ref;
+		const char *name;
+		uint16_t name_len;
+		size_t lookup_len;
+		size_t total_len;
+		int ret;
+
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search);
+		if (ret == -1) {
+			free(path);
+			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+		}
+
+		if (search.key.nr_items == 0) {
+			free(path);
+			errno = ENOENT;
+			return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+		}
+
+		header = (struct btrfs_ioctl_search_header *)search.buf;
+		ref = (struct btrfs_root_ref *)(header + 1);
+		name = (char *)(ref + 1);
+		name_len = le16_to_cpu(ref->name_len);
+
+		id = header->offset;
+
+		lookup.treeid = id;
+		lookup.objectid = le64_to_cpu(ref->dirid);
+		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &lookup);
+		if (ret == -1) {
+			free(path);
+			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+		}
+		lookup_len = strlen(lookup.name);
+
+		total_len = name_len + lookup_len + (id != BTRFS_FS_TREE_OBJECTID);
+		if (p - total_len < path) {
+			char *new_path, *new_p;
+			size_t new_capacity = capacity * 2;
+
+			new_path = malloc(new_capacity);
+			if (!new_path) {
+				free(path);
+				return BTRFS_UTIL_ERROR_NO_MEMORY;
+			}
+			new_p = new_path + new_capacity - (path + capacity - p);
+			memcpy(new_p, p, path + capacity - p);
+			free(path);
+			path = new_path;
+			p = new_p;
+			capacity = new_capacity;
+		}
+		p -= name_len;
+		memcpy(p, name, name_len);
+		p -= lookup_len;
+		memcpy(p, lookup.name, lookup_len);
+		if (id != BTRFS_FS_TREE_OBJECTID)
+			*--p = '/';
+	}
+
+	if (p != path)
+		memmove(path, p, path + capacity - p);
+
+	*path_ret = path;
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
 						    char *name, size_t name_len,
 						    int *fd)
-- 
2.16.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37871 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbeAZSlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:35 -0500
Received: by mail-pg0-f66.google.com with SMTP id z17so788641pgc.4
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:35 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 12/26] libbtrfsutil: add btrfs_util_delete_subvolume()
Date: Fri, 26 Jan 2018 10:41:00 -0800
Message-Id: <d30da418b2d807b73dffe891cfe2b7e1f29f19aa.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We also support recursive deletion using a subvolume iterator.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  30 ++++++++
 libbtrfsutil/python/btrfsutilpy.h           |   1 +
 libbtrfsutil/python/module.c                |   8 +++
 libbtrfsutil/python/subvolume.c             |  27 ++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  48 +++++++++++++
 libbtrfsutil/subvolume.c                    | 103 ++++++++++++++++++++++++++++
 6 files changed, 217 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 829f72b2..080268ce 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -387,6 +387,36 @@ enum btrfs_util_error btrfs_util_f2_create_snapshot(int fd, int parent_fd,
 						    uint64_t *async_transid,
 						    struct btrfs_util_qgroup_inherit *qgroup_inherit);
 
+/**
+ * BTRFS_UTIL_DELETE_SUBVOLUME_RECURSIVE - Delete subvolumes beneath the given
+ * subvolume before attempting to delete the given subvolume. By default,
+ * deleting a subvolume with child subvolumes is an error.
+ */
+#define BTRFS_UTIL_DELETE_SUBVOLUME_RECURSIVE (1 << 0)
+#define BTRFS_UTIL_DELETE_SUBVOLUME_MASK ((1 << 1) - 1)
+
+/**
+ * btrfs_util_delete_subvolume() - Delete a subvolume or snapshot.
+ * @path: Path of the subvolume to delete.
+ * @flags: Bitmask of BTRFS_UTIL_DELETE_SUBVOLUME_* flags.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_delete_subvolume(const char *path, int flags);
+
+/**
+ * btrfs_util_f_delete_subvolume() - Delete a subvolume or snapshot given its
+ * parent and name.
+ * @parent_fd: File descriptor of the subvolume's parent directory.
+ * @name: Name of the subvolume.
+ * @flags: See btrfs_util_delete_subvolume().
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_f_delete_subvolume(int parent_fd,
+						    const char *name,
+						    int flags);
+
 struct btrfs_util_subvolume_iterator;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index d552e416..b3ec047f 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -71,6 +71,7 @@ PyObject *get_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *delete_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index d8f797cb..e995a1be 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -206,6 +206,14 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "read_only -- create a read-only snapshot\n"
 	 "async -- create the subvolume without waiting for it to commit to\n"
 	 "disk and return the transaction ID"},
+	{"delete_subvolume", (PyCFunction)delete_subvolume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "delete_subvolume(path, recursive=False)\n\n"
+	 "Delete a subvolume or snapshot.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, or path-like object\n"
+	 "recursive -- if the given subvolume has child subvolumes, delete\n"
+	 "them instead of failing"},
 	{},
 };
 
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 763a06d9..f740ebdc 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -396,6 +396,33 @@ PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds)
 		Py_RETURN_NONE;
 }
 
+PyObject *delete_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "recursive", NULL};
+	struct path_arg path = {.allow_fd = false};
+	enum btrfs_util_error err;
+	int recursive = 0;
+	int flags = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|p:delete_subvolume",
+					 keywords, &path_converter, &path,
+					 &recursive))
+		return NULL;
+
+	if (recursive)
+		flags |= BTRFS_UTIL_DELETE_SUBVOLUME_RECURSIVE;
+
+	err = btrfs_util_delete_subvolume(path.path, flags);
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
 typedef struct {
 	PyObject_HEAD
 	struct btrfs_util_subvolume_iterator *iter;
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 2951154e..08083abe 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -270,6 +270,54 @@ class TestSubvolume(BtrfsTestCase):
         btrfsutil.create_snapshot(subvol, snapshot + '4', read_only=True)
         self.assertTrue(btrfsutil.get_subvolume_read_only(snapshot + '4'))
 
+    def test_delete_subvolume(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol + '1')
+        self.assertTrue(os.path.exists(subvol + '1'))
+        btrfsutil.create_subvolume(subvol + '2')
+        self.assertTrue(os.path.exists(subvol + '2'))
+        btrfsutil.create_subvolume(subvol + '3')
+        self.assertTrue(os.path.exists(subvol + '3'))
+
+        btrfsutil.delete_subvolume(subvol + '1')
+        self.assertFalse(os.path.exists(subvol + '1'))
+        btrfsutil.delete_subvolume((subvol + '2').encode())
+        self.assertFalse(os.path.exists(subvol + '2'))
+        if HAVE_PATH_LIKE:
+            btrfsutil.delete_subvolume(PurePath(subvol + '3'))
+            self.assertFalse(os.path.exists(subvol + '3'))
+
+        # Test deleting subvolumes under '/' in a chroot.
+        pid = os.fork()
+        if pid == 0:
+            try:
+                os.chroot(self.mountpoint)
+                os.chdir('/')
+                btrfsutil.create_subvolume('/subvol4')
+                self.assertTrue(os.path.exists('/subvol4'))
+                btrfsutil.delete_subvolume('/subvol4')
+                self.assertFalse(os.path.exists('/subvol4'))
+                with self.assertRaises(btrfsutil.BtrfsUtilError):
+                    btrfsutil.delete_subvolume('/')
+                os._exit(0)
+            except Exception:
+                traceback.print_exc()
+                os._exit(1)
+        wstatus = os.waitpid(pid, 0)[1]
+        self.assertTrue(os.WIFEXITED(wstatus))
+        self.assertEqual(os.WEXITSTATUS(wstatus), 0)
+
+        btrfsutil.create_subvolume(subvol + '5')
+        btrfsutil.create_subvolume(subvol + '5/foo')
+        btrfsutil.create_subvolume(subvol + '5/bar')
+        btrfsutil.create_subvolume(subvol + '5/bar/baz')
+        btrfsutil.create_subvolume(subvol + '5/bar/qux')
+        btrfsutil.create_subvolume(subvol + '5/quux')
+        with self.assertRaises(btrfsutil.BtrfsUtilError):
+            btrfsutil.delete_subvolume(subvol + '5')
+        btrfsutil.delete_subvolume(subvol + '5', recursive=True)
+        self.assertFalse(os.path.exists(subvol + '5'))
+
     def test_subvolume_iterator(self):
         pwd = os.getcwd()
         try:
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 27f64657..19ab2fcb 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1022,6 +1022,109 @@ enum btrfs_util_error btrfs_util_f2_create_snapshot(int fd, int parent_fd,
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error delete_subvolume_children(int parent_fd,
+						       const char *name)
+{
+	struct btrfs_util_subvolume_iterator *iter;
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = openat(parent_fd, name, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_f_create_subvolume_iterator(fd, 0,
+						     BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER,
+						     &iter);
+	if (err)
+		goto out;
+
+	for (;;) {
+		char child_name[BTRFS_PATH_NAME_MAX + 1];
+		char *child_path;
+		int child_parent_fd;
+
+		err = btrfs_util_subvolume_iterator_next(iter, &child_path,
+							 NULL);
+		if (err) {
+			if (err == BTRFS_UTIL_ERROR_STOP_ITERATION)
+				err = BTRFS_UTIL_OK;
+			break;
+		}
+
+		err = openat_parent_and_name(fd, child_path, child_name,
+					     sizeof(child_name),
+					     &child_parent_fd);
+		free(child_path);
+		if (err)
+			break;
+
+		err = btrfs_util_f_delete_subvolume(child_parent_fd, child_name,
+						    0);
+		SAVE_ERRNO_AND_CLOSE(child_parent_fd);
+		if (err)
+			break;
+	}
+
+	btrfs_util_destroy_subvolume_iterator(iter);
+out:
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_delete_subvolume(const char *path, int flags)
+{
+	char name[BTRFS_PATH_NAME_MAX + 1];
+	enum btrfs_util_error err;
+	int parent_fd;
+
+	err = openat_parent_and_name(AT_FDCWD, path, name, sizeof(name),
+				     &parent_fd);
+	if (err)
+		return err;
+
+	err = btrfs_util_f_delete_subvolume(parent_fd, name, flags);
+	SAVE_ERRNO_AND_CLOSE(parent_fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_delete_subvolume(int parent_fd,
+						    const char *name,
+						    int flags)
+{
+	struct btrfs_ioctl_vol_args args = {};
+	enum btrfs_util_error err;
+	size_t len;
+	int ret;
+
+	if (flags & ~BTRFS_UTIL_DELETE_SUBVOLUME_MASK) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+
+	if (flags & BTRFS_UTIL_DELETE_SUBVOLUME_RECURSIVE) {
+		err = delete_subvolume_children(parent_fd, name);
+		if (err)
+			return err;
+	}
+
+	len = strlen(name);
+	if (len >= sizeof(args.name)) {
+		errno = ENAMETOOLONG;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+	memcpy(args.name, name, len);
+	args.name[len] = '\0';
+
+	ret = ioctl(parent_fd, BTRFS_IOC_SNAP_DESTROY, &args);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SNAP_DESTROY_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
 __attribute__((visibility("default")))
 void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_iterator *iter)
 {
-- 
2.16.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35624 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167002AbeBOTFf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:35 -0500
Received: by mail-pg0-f65.google.com with SMTP id l131so509193pga.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:35 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 08/27] libbtrfsutil: add btrfs_util_subvolume_info()
Date: Thu, 15 Feb 2018 11:04:53 -0800
Message-Id: <34786c6d96328d6792ddf3f8bd3641942ee8c7bc.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This gets the the information in `btrfs subvolume show` from the root
item.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    | 111 +++++++++++++++++++++
 libbtrfsutil/python/btrfsutilpy.h           |   4 +
 libbtrfsutil/python/module.c                |  14 +++
 libbtrfsutil/python/subvolume.c             | 113 +++++++++++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  50 ++++++++++
 libbtrfsutil/subvolume.c                    | 148 ++++++++++++++++++++++++++++
 6 files changed, 440 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index f96c9c4e..0d83dea9 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -20,8 +20,10 @@
 #ifndef BTRFS_UTIL_H
 #define BTRFS_UTIL_H
 
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdint.h>
+#include <sys/time.h>
 
 #define BTRFS_UTIL_VERSION_MAJOR 1
 #define BTRFS_UTIL_VERSION_MINOR 0
@@ -124,6 +126,115 @@ enum btrfs_util_error btrfs_util_subvolume_path(const char *path, uint64_t id,
 enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
 						   char **path_ret);
 
+/**
+ * struct btrfs_util_subvolume_info - Information about a Btrfs subvolume.
+ */
+struct btrfs_util_subvolume_info {
+	/** @id: ID of this subvolume, unique across the filesystem. */
+	uint64_t id;
+
+	/**
+	 * @parent_id: ID of the subvolume which contains this subvolume, or
+	 * zero for the root subvolume (BTRFS_FS_TREE_OBJECTID) or orphaned
+	 * subvolumes (i.e., subvolumes which have been deleted but not yet
+	 * cleaned up).
+	 */
+	uint64_t parent_id;
+
+	/**
+	 * @dir_id: Inode number of the directory containing this subvolume in
+	 * the parent subvolume, or zero for the root subvolume
+	 * (BTRFS_FS_TREE_OBJECTID) or orphaned subvolumes.
+	 */
+	uint64_t dir_id;
+
+	/** @flags: On-disk root item flags. */
+	uint64_t flags;
+
+	/** @uuid: UUID of this subvolume. */
+	uint8_t uuid[16];
+
+	/**
+	 * @parent_uuid: UUID of the subvolume this subvolume is a snapshot of,
+	 * or all zeroes if this subvolume is not a snapshot.
+	 */
+	uint8_t parent_uuid[16];
+
+	/**
+	 * @received_uuid: UUID of the subvolume this subvolume was received
+	 * from, or all zeroes if this subvolume was not received. Note that
+	 * this field, @stransid, @rtransid, @stime, and @rtime are set manually
+	 * by userspace after a subvolume is received.
+	 */
+	uint8_t received_uuid[16];
+
+	/** @generation: Transaction ID of the subvolume root. */
+	uint64_t generation;
+
+	/**
+	 * @ctransid: Transaction ID when an inode in this subvolume was last
+	 * changed.
+	 */
+	uint64_t ctransid;
+
+	/** @otransid: Transaction ID when this subvolume was created. */
+	uint64_t otransid;
+
+	/**
+	 * @stransid: Transaction ID of the sent subvolume this subvolume was
+	 * received from, or zero if this subvolume was not received. See the
+	 * note on @received_uuid.
+	 */
+	uint64_t stransid;
+
+	/**
+	 * @rtransid: Transaction ID when this subvolume was received, or zero
+	 * if this subvolume was not received. See the note on @received_uuid.
+	 */
+	uint64_t rtransid;
+
+	/** @ctime: Time when an inode in this subvolume was last changed. */
+	struct timespec ctime;
+
+	/** @otime: Time when this subvolume was created. */
+	struct timespec otime;
+
+	/**
+	 * @stime: Not well-defined, usually zero unless it was set otherwise.
+	 * See the note on @received_uuid.
+	 */
+	struct timespec stime;
+
+	/**
+	 * @rtime: Time when this subvolume was received, or zero if this
+	 * subvolume was not received. See the note on @received_uuid.
+	 */
+	struct timespec rtime;
+};
+
+/**
+ * btrfs_util_subvolume_info() - Get information about a subvolume.
+ * @path: Path in a Btrfs filesystem. This may be any path in the filesystem; it
+ * does not have to refer to a subvolume unless @id is zero.
+ * @id: ID of subvolume to get information about. If zero is given, the
+ * subvolume ID of @path is used.
+ * @subvol: Returned subvolume information. This can be %NULL if you just want
+ * to check whether the subvolume exists; %BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND
+ * will be returned if it does not.
+ *
+ * This requires appropriate privilege (CAP_SYS_ADMIN).
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_subvolume_info(const char *path, uint64_t id,
+						struct btrfs_util_subvolume_info *subvol);
+
+/**
+ * btrfs_util_subvolume_info_fd() - See btrfs_util_subvolume_info().
+ */
+enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
+						   struct btrfs_util_subvolume_info *subvol);
+
 struct btrfs_util_qgroup_inherit;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index ffd62ba7..e601cb8b 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -35,6 +35,8 @@ typedef struct {
 } QgroupInherit;
 
 extern PyTypeObject BtrfsUtilError_type;
+extern PyStructSequence_Desc SubvolumeInfo_desc;
+extern PyTypeObject SubvolumeInfo_type;
 extern PyTypeObject QgroupInherit_type;
 
 /*
@@ -61,6 +63,8 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *subvolume_info(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 444516b1..b1469fc9 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -152,6 +152,14 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "path -- string, bytes, path-like object, or open file descriptor\n"
 	 "id -- if not zero, instead of returning the subvolume path of the\n"
 	 "given path, return the path of the subvolume with this ID"},
+	{"subvolume_info", (PyCFunction)subvolume_info,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "subvolume_info(path, id=0) -> SubvolumeInfo\n\n"
+	 "Get information about a subvolume.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "id -- if not zero, instead of returning information about the\n"
+	 "given path, return information about the subvolume with this ID"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "create_subvolume(path, async=False)\n\n"
@@ -180,6 +188,9 @@ PyInit_btrfsutil(void)
 	if (PyType_Ready(&BtrfsUtilError_type) < 0)
 		return NULL;
 
+	if (PyStructSequence_InitType2(&SubvolumeInfo_type, &SubvolumeInfo_desc) < 0)
+		return NULL;
+
 	QgroupInherit_type.tp_new = PyType_GenericNew;
 	if (PyType_Ready(&QgroupInherit_type) < 0)
 		return NULL;
@@ -192,6 +203,9 @@ PyInit_btrfsutil(void)
 	PyModule_AddObject(m, "BtrfsUtilError",
 			   (PyObject *)&BtrfsUtilError_type);
 
+	Py_INCREF(&SubvolumeInfo_type);
+	PyModule_AddObject(m, "SubvolumeInfo", (PyObject *)&SubvolumeInfo_type);
+
 	Py_INCREF(&QgroupInherit_type);
 	PyModule_AddObject(m, "QgroupInherit",
 			   (PyObject *)&QgroupInherit_type);
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 6382d290..31b6ca2e 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -102,6 +102,119 @@ PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds)
 	return ret;
 }
 
+static PyObject *subvolume_info_to_object(const struct btrfs_util_subvolume_info *subvol)
+{
+	PyObject *ret, *tmp;
+
+	ret = PyStructSequence_New(&SubvolumeInfo_type);
+	if (ret == NULL)
+		return NULL;
+
+#define SET_UINT64(i, field)					\
+	tmp = PyLong_FromUnsignedLongLong(subvol->field);	\
+	if (tmp == NULL) {					\
+		Py_DECREF(ret);					\
+		return ret;					\
+	}							\
+	PyStructSequence_SET_ITEM(ret, i, tmp);
+
+#define SET_UUID(i, field)						\
+	tmp = PyBytes_FromStringAndSize((char *)subvol->field, 16);	\
+	if (tmp == NULL) {						\
+		Py_DECREF(ret);						\
+		return ret;						\
+	}								\
+	PyStructSequence_SET_ITEM(ret, i, tmp);
+
+#define SET_TIME(i, field)						\
+	tmp = PyFloat_FromDouble(subvol->field.tv_sec +			\
+				 subvol->field.tv_nsec / 1000000000);	\
+	if (tmp == NULL) {						\
+		Py_DECREF(ret);						\
+		return ret;						\
+	}								\
+	PyStructSequence_SET_ITEM(ret, i, tmp);
+
+	SET_UINT64(0, id);
+	SET_UINT64(1, parent_id);
+	SET_UINT64(2, dir_id);
+	SET_UINT64(3, flags);
+	SET_UUID(4, uuid);
+	SET_UUID(5, parent_uuid);
+	SET_UUID(6, received_uuid);
+	SET_UINT64(7, generation);
+	SET_UINT64(8, ctransid);
+	SET_UINT64(9, otransid);
+	SET_UINT64(10, stransid);
+	SET_UINT64(11, rtransid);
+	SET_TIME(12, ctime);
+	SET_TIME(13, otime);
+	SET_TIME(14, stime);
+	SET_TIME(15, rtime);
+
+#undef SET_TIME
+#undef SET_UUID
+#undef SET_UINT64
+
+	return ret;
+}
+
+PyObject *subvolume_info(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "id", NULL};
+	struct path_arg path = {.allow_fd = true};
+	struct btrfs_util_subvolume_info subvol;
+	enum btrfs_util_error err;
+	uint64_t id = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|K:subvolume_info",
+					 keywords, &path_converter, &path, &id))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_subvolume_info(path.path, id, &subvol);
+	else
+		err = btrfs_util_subvolume_info_fd(path.fd, id, &subvol);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+
+	return subvolume_info_to_object(&subvol);
+}
+
+static PyStructSequence_Field SubvolumeInfo_fields[] = {
+	{"id", "int ID of this subvolume"},
+	{"parent_id", "int ID of the subvolume containing this subvolume"},
+	{"dir_id", "int inode number of the directory containing this subvolume"},
+	{"flags", "int root item flags"},
+	{"uuid", "bytes UUID of this subvolume"},
+	{"parent_uuid", "bytes UUID of the subvolume this is a snapshot of"},
+	{"received_uuid", "bytes UUID of the subvolume this was received from"},
+	{"generation", "int transaction ID of the subvolume root"},
+	{"ctransid", "int transaction ID when an inode was last changed"},
+	{"otransid", "int transaction ID when this subvolume was created"},
+	{"stransid", "int transaction ID of the sent subvolume this subvolume was received from"},
+	{"rtransid", "int transaction ID when this subvolume was received"},
+	{"ctime", "float time when an inode was last changed"},
+	{"otime", "float time when this subvolume was created"},
+	{"stime", "float time, usually zero"},
+	{"rtime", "float time when this subvolume was received"},
+	{},
+};
+
+PyStructSequence_Desc SubvolumeInfo_desc = {
+	"btrfsutil.SubvolumeInfo",
+	"Information about a Btrfs subvolume.",
+	SubvolumeInfo_fields,
+	14,
+};
+
+PyTypeObject SubvolumeInfo_type;
+
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 {
 	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 57ba27bf..ecb0d7ae 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -87,6 +87,56 @@ class TestSubvolume(BtrfsTestCase):
         finally:
             os.chdir(pwd)
 
+    def test_subvolume_info(self):
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                info = btrfsutil.subvolume_info(arg)
+                self.assertEqual(info.id, 5)
+                self.assertEqual(info.parent_id, 0)
+                self.assertEqual(info.dir_id, 0)
+                self.assertEqual(info.flags, 0)
+                self.assertEqual(info.uuid, bytes(16))
+                self.assertEqual(info.parent_uuid, bytes(16))
+                self.assertEqual(info.received_uuid, bytes(16))
+                self.assertNotEqual(info.generation, 0)
+                self.assertEqual(info.ctransid, 0)
+                self.assertEqual(info.otransid, 0)
+                self.assertEqual(info.stransid, 0)
+                self.assertEqual(info.rtransid, 0)
+                self.assertEqual(info.ctime, 0)
+                self.assertEqual(info.otime, 0)
+                self.assertEqual(info.stime, 0)
+                self.assertEqual(info.rtime, 0)
+
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol)
+
+        info = btrfsutil.subvolume_info(subvol)
+        self.assertEqual(info.id, 256)
+        self.assertEqual(info.parent_id, 5)
+        self.assertEqual(info.dir_id, 256)
+        self.assertEqual(info.flags, 0)
+        self.assertIsInstance(info.uuid, bytes)
+        self.assertEqual(info.parent_uuid, bytes(16))
+        self.assertEqual(info.received_uuid, bytes(16))
+        self.assertNotEqual(info.generation, 0)
+        self.assertNotEqual(info.ctransid, 0)
+        self.assertNotEqual(info.otransid, 0)
+        self.assertEqual(info.stransid, 0)
+        self.assertEqual(info.rtransid, 0)
+        self.assertNotEqual(info.ctime, 0)
+        self.assertNotEqual(info.otime, 0)
+        self.assertEqual(info.stime, 0)
+        self.assertEqual(info.rtime, 0)
+
+        # TODO: test received_uuid, stransid, rtransid, stime, and rtime
+
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                with self.assertRaises(btrfsutil.BtrfsUtilError) as e:
+                    # BTRFS_EXTENT_TREE_OBJECTID
+                    btrfsutil.subvolume_info(arg, 2)
+
     def test_create_subvolume(self):
         subvol = os.path.join(self.mountpoint, 'subvol')
 
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 54a63b52..69bc790a 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -253,6 +253,154 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+static void copy_timespec(struct timespec *timespec,
+			  const struct btrfs_timespec *btrfs_timespec)
+{
+	timespec->tv_sec = le64_to_cpu(btrfs_timespec->sec);
+	timespec->tv_nsec = le32_to_cpu(btrfs_timespec->nsec);
+}
+
+static void copy_root_item(struct btrfs_util_subvolume_info *subvol,
+			   const struct btrfs_root_item *root)
+{
+	subvol->flags = le64_to_cpu(root->flags);
+	memcpy(subvol->uuid, root->uuid, sizeof(subvol->uuid));
+	memcpy(subvol->parent_uuid, root->parent_uuid,
+	       sizeof(subvol->parent_uuid));
+	memcpy(subvol->received_uuid, root->received_uuid,
+	       sizeof(subvol->received_uuid));
+	subvol->generation = le64_to_cpu(root->generation);
+	subvol->ctransid = le64_to_cpu(root->ctransid);
+	subvol->otransid = le64_to_cpu(root->otransid);
+	subvol->stransid = le64_to_cpu(root->stransid);
+	subvol->rtransid = le64_to_cpu(root->rtransid);
+	copy_timespec(&subvol->ctime, &root->ctime);
+	copy_timespec(&subvol->otime, &root->otime);
+	copy_timespec(&subvol->stime, &root->stime);
+	copy_timespec(&subvol->rtime, &root->rtime);
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_info(const char *path,
+						       uint64_t id,
+						       struct btrfs_util_subvolume_info *subvol)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_subvolume_info_fd(fd, id, subvol);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
+							  struct btrfs_util_subvolume_info *subvol)
+{
+	struct btrfs_ioctl_search_args search = {
+		.key = {
+			.tree_id = BTRFS_ROOT_TREE_OBJECTID,
+			.min_type = BTRFS_ROOT_ITEM_KEY,
+			.max_type = BTRFS_ROOT_BACKREF_KEY,
+			.min_offset = 0,
+			.max_offset = UINT64_MAX,
+			.min_transid = 0,
+			.max_transid = UINT64_MAX,
+			.nr_items = 0,
+		},
+	};
+	enum btrfs_util_error err;
+	size_t items_pos = 0, buf_off = 0;
+	bool need_root_item = true, need_root_backref = true;
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
+	if ((id < BTRFS_FIRST_FREE_OBJECTID && id != BTRFS_FS_TREE_OBJECTID) ||
+	    id > BTRFS_LAST_FREE_OBJECTID) {
+		errno = ENOENT;
+		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+	}
+
+	search.key.min_objectid = search.key.max_objectid = id;
+
+	if (subvol) {
+		subvol->id = id;
+		subvol->parent_id = 0;
+		subvol->dir_id = 0;
+		if (id == BTRFS_FS_TREE_OBJECTID)
+			need_root_backref = false;
+	} else {
+		/*
+		 * We only need the backref for filling in the subvolume info.
+		 */
+		need_root_backref = false;
+	}
+
+	/* Don't bother searching for the backref if we don't need it. */
+	if (!need_root_backref)
+		search.key.max_type = BTRFS_ROOT_ITEM_KEY;
+
+	while (need_root_item || need_root_backref) {
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
+				if (need_root_item) {
+					errno = ENOENT;
+					return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+				} else {
+					break;
+				}
+			}
+		}
+
+		header = (struct btrfs_ioctl_search_header *)(search.buf + buf_off);
+		if (header->type == BTRFS_ROOT_ITEM_KEY) {
+			if (subvol) {
+				const struct btrfs_root_item *root;
+
+				root = (const struct btrfs_root_item *)(header + 1);
+				copy_root_item(subvol, root);
+			}
+			need_root_item = false;
+			search.key.min_type = BTRFS_ROOT_BACKREF_KEY;
+		} else if (header->type == BTRFS_ROOT_BACKREF_KEY) {
+			if (subvol) {
+				const struct btrfs_root_ref *ref;
+
+				ref = (const struct btrfs_root_ref *)(header + 1);
+				subvol->parent_id = header->offset;
+				subvol->dir_id = le64_to_cpu(ref->dirid);
+			}
+			need_root_backref = false;
+			search.key.min_type = UINT32_MAX;
+		}
+
+		items_pos++;
+		buf_off += sizeof(*header) + header->len;
+	}
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
 						    char *name, size_t name_len,
 						    int *fd)
-- 
2.16.1


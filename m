Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:29755 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbeEKH1j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:39 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A6A77AC051A
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:32 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id D94E0BD67EB
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:31 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/11] btrfs-progs: libbtrfsutil: Update the behavior of subvolume iterator and relax the privileges
Date: Fri, 11 May 2018 16:29:43 +0900
Message-ID: <20180511072949.15269-6-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By using new ioctls (BTRFS_IOC_GET_ROOTREF_INFO/BTRFS_IOC_INO_LOOKUP_USER),
this commit update the subvolume iterator when it is created by
btrfs_util_create_subvolume_iterator() with @top zero
(i.e. if the iterator is created from givin path/fd).

In that case,
 - an iterator can be created from non-subvolume directory
   and will skip a subvolume if
   - it does not exist nor has different id from the found subvolume
     by INO_LOOKUP_USER (may happen if a dir in the path is being mounted)
   - it cannot be opened due to permission error

Since above ioctls do not require root privileges, non-privileged user can
also use the iterator. If @top is specified, the behavior is the same
as before (and thus non-privileged user cannot use).

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/btrfsutil.h |  19 ++-
 libbtrfsutil/errors.c    |   4 +
 libbtrfsutil/subvolume.c | 319 +++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 315 insertions(+), 27 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 5fe798c5..b90dc93e 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -65,6 +65,8 @@ enum btrfs_util_error {
 	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER,
 	BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED,
+	BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED,
+	BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED,
 };
 
 /**
@@ -510,6 +512,11 @@ struct btrfs_util_subvolume_iterator;
  * @flags: Bitmask of BTRFS_UTIL_SUBVOLUME_ITERATOR_* flags.
  * @ret: Returned iterator.
  *
+ * For newer kenrels which supports BTRFS_IOC_GET_SUBVOL_ROOTREF and
+ * BTRFS_IOC_INO_LOOKUP_USER, @path does not have to refer to a subvolume when
+ * @top is zero. In that case, subvolumes only below the specified path will
+ * be returned.
+ *
  * The returned iterator must be freed with
  * btrfs_util_destroy_subvolume_iterator().
  *
@@ -558,7 +565,11 @@ int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_iterator
  * Must be freed with free().
  * @id_ret: Returned subvolume ID. May be %NULL.
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for older kernel.
+ * For newer kenrels which supports BTRFS_IOC_GET_SUBVOL_ROOTREF and
+ * BTRFS_IOC_INO_LOOKUP_USER, non-privileged user also can use this.
+ * In that case, subvolumes which cannot be accessed by the user will be
+ * skipped.
  *
  * Return: %BTRFS_UTIL_OK on success, %BTRFS_UTIL_ERROR_STOP_ITERATION if there
  * are no more subvolumes, non-zero error code on failure.
@@ -577,7 +588,11 @@ enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvo
  * This convenience function basically combines
  * btrfs_util_subvolume_iterator_next() and btrfs_util_subvolume_info().
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for older kernel.
+ * For newer kenrels which supports BTRFS_IOC_GET_SUGBVOL_INFO,
+ * BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER,
+ * non-privileged user also can use this. In that case, subvolumes which
+ * cannot be accessed by the user will be skipped.
  *
  * Return: See btrfs_util_subvolume_iterator_next().
  */
diff --git a/libbtrfsutil/errors.c b/libbtrfsutil/errors.c
index f196fa71..21bbc7b2 100644
--- a/libbtrfsutil/errors.c
+++ b/libbtrfsutil/errors.c
@@ -49,6 +49,10 @@ static const char * const error_messages[] = {
 		"Non-root user cannot specify subvolume id",
 	[BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED] =
 	"Could not get subvolume information by BTRFS_IOC_GET_SUBVOL_INFO",
+	[BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED] =
+	"Could not get rootref information by BTRRFS_IOC_GET_ROOTREF_INFO",
+	[BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED] =
+	"Could not resolve subvolume path by BTRFS_IOC_INO_LOOKUP_USER",
 };
 
 PUBLIC const char *btrfs_util_strerror(enum btrfs_util_error err)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 08bbeca2..036af546 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -39,6 +39,24 @@ static bool is_root(void)
 	return (uid == 0);
 }
 
+/*
+ * We need both BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER
+ * but only checks BTRFS_IOC_GET_SUBVOL_ROOTREF for brevity.
+ */
+static bool check_support_rootref_ioctl(int fd)
+{
+	struct btrfs_ioctl_get_subvol_rootref_args args;
+	int ret;
+
+	memset(&args, 0, sizeof(args));
+	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_ROOTREF, &args);
+
+	if (ret < 0 && errno == ENOTTY)
+		return false;
+
+	return true;
+}
+
 /*
  * This intentionally duplicates btrfs_util_is_subvolume_fd() instead of opening
  * a file descriptor and calling it, because fstat() and fstatfs() don't accept
@@ -760,12 +778,18 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
 #define BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD (1 << 30)
 
 struct search_stack_entry {
+	/* used for subvolume_iterator_next_user */
+	uint64_t id;
+	struct btrfs_ioctl_get_subvol_rootref_args rootref_args;
+	/* used for subvolume_iterator_next_root */
 	struct btrfs_ioctl_search_args search;
+	/* used for both */
 	size_t items_pos, buf_off;
 	size_t path_len;
 };
 
 struct btrfs_util_subvolume_iterator {
+	bool use_tree_search;
 	int fd;
 	int flags;
 
@@ -799,22 +823,28 @@ static enum btrfs_util_error append_to_search_stack(struct btrfs_util_subvolume_
 
 	entry = &iter->search_stack[iter->search_stack_len++];
 
-	memset(&entry->search, 0, sizeof(entry->search));
-	entry->search.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	entry->search.key.min_objectid = tree_id;
-	entry->search.key.max_objectid = tree_id;
-	entry->search.key.min_type = BTRFS_ROOT_REF_KEY;
-	entry->search.key.max_type = BTRFS_ROOT_REF_KEY;
-	entry->search.key.min_offset = 0;
-	entry->search.key.max_offset = UINT64_MAX;
-	entry->search.key.min_transid = 0;
-	entry->search.key.max_transid = UINT64_MAX;
-	entry->search.key.nr_items = 0;
-
-	entry->items_pos = 0;
-	entry->buf_off = 0;
-
-	entry->path_len = path_len;
+	if (iter->use_tree_search) {
+		memset(&entry->search, 0, sizeof(entry->search));
+		entry->search.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
+		entry->search.key.min_objectid = tree_id;
+		entry->search.key.max_objectid = tree_id;
+		entry->search.key.min_type = BTRFS_ROOT_REF_KEY;
+		entry->search.key.max_type = BTRFS_ROOT_REF_KEY;
+		entry->search.key.min_offset = 0;
+		entry->search.key.max_offset = UINT64_MAX;
+		entry->search.key.min_transid = 0;
+		entry->search.key.max_transid = UINT64_MAX;
+		entry->search.key.nr_items = 0;
+
+		entry->items_pos = 0;
+		entry->buf_off = 0;
+
+		entry->path_len = path_len;
+	} else {
+		memset(entry, 0, sizeof(*entry));
+		entry->path_len = path_len;
+		entry->id = tree_id;
+	}
 
 	return BTRFS_UTIL_OK;
 }
@@ -847,6 +877,7 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
+	bool use_tree_search = true;
 
 	if (flags & ~BTRFS_UTIL_SUBVOLUME_ITERATOR_MASK) {
 		errno = EINVAL;
@@ -854,13 +885,25 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 	}
 
 	if (top == 0) {
-		err = btrfs_util_is_subvolume_fd(fd);
-		if (err)
-			return err;
-
-		err = btrfs_util_subvolume_id_fd(fd, &top);
-		if (err)
-			return err;
+		if (check_support_rootref_ioctl(fd)) {
+			/*
+			 * if new ioctls (GET_SUBVOL_ROOTREF etc) is available,
+			 * always use these as this allows to create subvolume
+			 * iterator which starts from non-subvolume directory.
+			 */
+			use_tree_search = false;
+		} else {
+			if (!is_root())
+				return BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER;
+
+			err = btrfs_util_is_subvolume_fd(fd);
+			if (err)
+				return err;
+
+			err = btrfs_util_subvolume_id_fd(fd, &top);
+			if (err)
+				return err;
+		}
 	}
 
 	iter = malloc(sizeof(*iter));
@@ -869,6 +912,7 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 
 	iter->fd = fd;
 	iter->flags = flags;
+	iter->use_tree_search = use_tree_search;
 
 	iter->search_stack_len = 0;
 	iter->search_stack_capacity = 4;
@@ -1255,6 +1299,70 @@ static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_itera
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error build_subvol_path_user(struct btrfs_util_subvolume_iterator *iter,
+						    int fd,
+						    size_t *path_len_ret)
+{
+	struct search_stack_entry *top = top_search_stack_entry(iter);
+	struct btrfs_ioctl_ino_lookup_user_args args;
+	uint64_t dirid, subvolid;
+	size_t dir_len, name_len, path_len;
+	char *p;
+	int ret;
+
+	dirid = top->rootref_args.rootref[top->items_pos].dirid;
+	subvolid = top->rootref_args.rootref[top->items_pos].subvolid;
+
+	memset(&args, 0, sizeof(args));
+	args.dirid = dirid;
+	args.subvolid = subvolid;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP_USER, &args);
+	if (ret < 0)
+		return BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED;
+
+	dir_len = strlen(args.path);
+	name_len = strlen(args.name);
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
+	memcpy(p, args.path, dir_len);
+	p += dir_len;
+	if (top->path_len && !dir_len && name_len)
+		*p++ = '/';
+	memcpy(p, args.name, name_len);
+	p += name_len;
+
+	*path_len_ret = path_len;
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error subvolume_iterator_next_root(struct btrfs_util_subvolume_iterator *iter,
 								char **path_ret,
 								uint64_t *id_ret)
@@ -1331,11 +1439,161 @@ out:
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error subvolume_iterator_next_user(struct btrfs_util_subvolume_iterator *iter,
+							  char **path_ret,
+							  uint64_t *id_ret)
+{
+	int ret, fd, fd2;
+	size_t path_len;
+	struct search_stack_entry *top;
+	enum btrfs_util_error err;
+	char *path;
+
+	for (;;) {
+		fd = -1;
+
+		for (;;) {
+			if (iter->search_stack_len == 0)
+				return BTRFS_UTIL_ERROR_STOP_ITERATION;
+
+			top = top_search_stack_entry(iter);
+
+			if (fd == -1) {
+				if (!top->path_len) {
+					fd = dup(iter->fd);
+				} else {
+					path = iter->cur_path;
+					path[top->path_len] = '\0';
+					fd = openat(iter->fd, path, O_RDONLY);
+				}
+
+				if (fd < 0) {
+					/* skip permission error */
+					if (errno == EACCES) {
+						iter->search_stack_len--;
+						if ((iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) &&
+								iter->search_stack_len)
+							goto out;
+						continue;
+					} else {
+						return BTRFS_UTIL_ERROR_OPEN_FAILED;
+					}
+				}
+			}
+
+			if (top->items_pos < top->rootref_args.num_items) {
+				break;
+			} else {
+				top->items_pos = 0;
+				ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_ROOTREF,
+						&top->rootref_args);
+				if (ret < 0) {
+					if (errno != EOVERFLOW) {
+						SAVE_ERRNO_AND_CLOSE(fd);
+						return BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED;
+					}
+				} else {
+					if (top->rootref_args.num_items == 0) {
+						iter->search_stack_len--;
+						SAVE_ERRNO_AND_CLOSE(fd);
+						fd = -1;
+
+						if ((iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) &&
+								iter->search_stack_len)
+							goto out;
+					}
+				}
+			}
+		}
+
+		err = build_subvol_path_user(iter, fd,
+				&path_len);
+		top->id = top->rootref_args.rootref[top->items_pos].subvolid;
+		top->items_pos++;
+		SAVE_ERRNO_AND_CLOSE(fd);
+
+		/* Skip if permission error happens during path construction */
+		if (err) {
+			if (errno == EACCES) {
+				fd = -1;
+				continue;
+			}
+			return err;
+		}
+
+		/* Extra check to the constructed path */
+		iter->cur_path[path_len] = '\0';
+		fd2 = openat(iter->fd, iter->cur_path, O_RDONLY);
+		if (fd2 < 0) {
+			/*
+			 * Skip if
+			 *  1. the path does not exist
+			 *     (may happen if a dir in the path is mounted)
+			 *  2. cannot open the path due to permission error
+			 */
+			if (errno == ENOENT || errno == EACCES) {
+				fd = -1;
+				continue;
+			}
+			return BTRFS_UTIL_ERROR_OPEN_FAILED;
+		} else {
+			uint64_t temp_id;
+
+			/*
+			 * Check the subvolume status and skip if other volume
+			 * is mounted
+			 */
+			err = btrfs_util_is_subvolume_fd(fd2);
+			if (err) {
+				SAVE_ERRNO_AND_CLOSE(fd2);
+				if (err == BTRFS_UTIL_ERROR_NOT_BTRFS ||
+				    err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+					fd = -1;
+					continue;
+				}
+				return err;
+			}
+			err = btrfs_util_subvolume_id_fd(fd2, &temp_id);
+			SAVE_ERRNO_AND_CLOSE(fd2);
+			if (err)
+				return err;
+			if (top->id != temp_id) {
+				fd = -1;
+				continue;
+			}
+		}
+
+		err = append_to_search_stack(iter, top->id, path_len);
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
+		*id_ret = top->id;
+	return BTRFS_UTIL_OK;
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
 								char **path_ret,
 								uint64_t *id_ret)
 {
-	return subvolume_iterator_next_root(iter, path_ret, id_ret);
+	if (iter->use_tree_search)
+		return subvolume_iterator_next_root(iter, path_ret, id_ret);
+	else
+		return subvolume_iterator_next_user(iter, path_ret, id_ret);
 }
 
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_subvolume_iterator *iter,
@@ -1344,12 +1602,23 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrf
 {
 	enum btrfs_util_error err;
 	uint64_t id;
+	int fd;
 
 	err = btrfs_util_subvolume_iterator_next(iter, path_ret, &id);
 	if (err)
 		return err;
 
-	return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	if (iter->use_tree_search) {
+		return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	} else {
+		fd = openat(iter->fd, *path_ret, O_RDONLY);
+		if (fd < 0)
+			return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+		err = btrfs_util_subvolume_info_fd(fd, 0, subvol);
+		SAVE_ERRNO_AND_CLOSE(fd);
+		return err;
+	}
 }
 
 PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes(const char *path,
-- 
2.14.3



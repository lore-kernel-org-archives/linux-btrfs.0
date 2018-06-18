Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28216 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968216AbeFRIiT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:19 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 916B6AC0139
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id B07DBBD65F4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 06/20] btrfs-progs: libbtrfsutil: Relax the privileges of subvolume iterator
Date: Mon, 18 Jun 2018 17:40:54 +0900
Message-ID: <abb3e6cdf8368571516b75482ba1f8cc1fb7387f.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit relax the privileges of subvolume iterator when the kernel
supports new ioctls (BTRFS_IOC_GET_SUBVOL_ROOTREF and
BTRFS_IOC_INO_LOOKUP_USER).

For older kernel (< 4.18), the behavior is the same.

Non-privileged user can use subvolume iterator only if new ioctls are
supported and btrfs_util_create_subvolume_iterator() is called with @top
zero (i.e. if the iterator is created from given path/fd). In this case:
 - an iterator can be created from non-subvolume directory
 - subvolume will be skipped if
   - it does not exist nor has different id from the found subvolume
     by INO_LOOKUP_USER (may happen if a dir in the path is being mounted)
   - it cannot be opened due to permission error

Note that this commit also allows root user to specify non-subvolume
direcotry when @top is zero. Only in that case, root's code path is
the same as user.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/btrfsutil.h |  18 ++-
 libbtrfsutil/errors.c    |   6 +
 libbtrfsutil/subvolume.c | 380 +++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 377 insertions(+), 27 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 3f21d163..49454a63 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -65,6 +65,10 @@ enum btrfs_util_error {
 	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER,
 	BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED,
+	BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED,
+	BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED,
+	BTRFS_UTIL_ERROR_DUP_FAILED,
+	BTRFS_UTIL_ERROR_CHDIR_FAILED,
 };
 
 /**
@@ -510,6 +514,14 @@ struct btrfs_util_subvolume_iterator;
  * @flags: Bitmask of BTRFS_UTIL_SUBVOLUME_ITERATOR_* flags.
  * @ret: Returned iterator.
  *
+ * Using subvolume iterator requires appropriate privilege (CAP_SYS_ADMIN) for
+ * kernel < 4.18. From kenrel >= 4.18 which supports
+ * BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER, non-previleged
+ * user can use it too (in that case @top must be zero). Also from kernel
+ * >=4.18, if @top is zero, the specified path can be non-subvolume directory
+ * and subvolumes which cannot be accessed will be skipped (either due to
+ * permission error or path is hidden by other mount).
+ *
  * The returned iterator must be freed with
  * btrfs_util_destroy_subvolume_iterator().
  *
@@ -558,7 +570,8 @@ int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_iterator
  * Must be freed with free().
  * @id_ret: Returned subvolume ID. May be %NULL.
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for kernel < 4.18.
+ * See the comment of btrfs_util_create_subvolume_iterator()
  *
  * Return: %BTRFS_UTIL_OK on success, %BTRFS_UTIL_ERROR_STOP_ITERATION if there
  * are no more subvolumes, non-zero error code on failure.
@@ -577,7 +590,8 @@ enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvo
  * This convenience function basically combines
  * btrfs_util_subvolume_iterator_next() and btrfs_util_subvolume_info().
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for kernel < 4.18.
+ * See the comment of btrfs_util_create_subvolume_iterator()
  *
  * Return: See btrfs_util_subvolume_iterator_next().
  */
diff --git a/libbtrfsutil/errors.c b/libbtrfsutil/errors.c
index f196fa71..c77407bf 100644
--- a/libbtrfsutil/errors.c
+++ b/libbtrfsutil/errors.c
@@ -49,6 +49,12 @@ static const char * const error_messages[] = {
 		"Non-root user cannot specify subvolume id",
 	[BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED] =
 	"Could not get subvolume information by BTRFS_IOC_GET_SUBVOL_INFO",
+	[BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED] =
+	"Could not get rootref information by BTRRFS_IOC_GET_SUBVOL_ROOTREF",
+	[BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED] =
+	"Could not resolve subvolume path by BTRFS_IOC_INO_LOOKUP_USER",
+	[BTRFS_UTIL_ERROR_DUP_FAILED] = "Could not dup",
+	[BTRFS_UTIL_ERROR_CHDIR_FAILED] = "Could not chdir",
 };
 
 PUBLIC const char *btrfs_util_strerror(enum btrfs_util_error err)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 73471d4f..ae39d5c8 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -760,13 +760,21 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
 #define BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD (1 << 30)
 
 struct search_stack_entry {
+	/* below are used for subvolume_iterator_next_user */
+	uint64_t id;
+	struct btrfs_ioctl_get_subvol_rootref_args rootref_args;
+	/* below is used for subvolume_iterator_next_root */
 	struct btrfs_ioctl_search_args search;
+	/* below are used for both */
 	size_t items_pos, buf_off;
 	size_t path_len;
 };
 
 struct btrfs_util_subvolume_iterator {
+	bool use_tree_search;
 	int fd;
+	/* cur_fd is only used for subvolume_iterator_next_user */
+	int cur_fd;
 	int flags;
 
 	struct search_stack_entry *search_stack;
@@ -799,22 +807,28 @@ static enum btrfs_util_error append_to_search_stack(struct btrfs_util_subvolume_
 
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
@@ -847,20 +861,32 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
+	bool use_tree_search = true;
 
 	if (flags & ~BTRFS_UTIL_SUBVOLUME_ITERATOR_MASK) {
 		errno = EINVAL;
 		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
 	}
 
-	if (top == 0) {
-		err = btrfs_util_is_subvolume_fd(fd);
-		if (err)
-			return err;
+	if (is_root()) {
+		if (top == 0) {
+			err = btrfs_util_is_subvolume_fd(fd);
+			if (err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+				use_tree_search = false;
+			} else {
+				if (err)
+					return err;
 
-		err = btrfs_util_subvolume_id_fd(fd, &top);
-		if (err)
-			return err;
+				err = btrfs_util_subvolume_id_fd(fd, &top);
+				if (err)
+					return err;
+			}
+		}
+	} else {
+		if (top != 0)
+			return BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER;
+
+		use_tree_search = false;
 	}
 
 	iter = malloc(sizeof(*iter));
@@ -868,7 +894,15 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 		return BTRFS_UTIL_ERROR_NO_MEMORY;
 
 	iter->fd = fd;
+	if (!use_tree_search) {
+		iter->cur_fd = dup(fd);
+		if (iter->cur_fd < 0) {
+			err = BTRFS_UTIL_ERROR_DUP_FAILED;
+			goto out_iter;
+		}
+	}
 	iter->flags = flags;
+	iter->use_tree_search = use_tree_search;
 
 	iter->search_stack_len = 0;
 	iter->search_stack_capacity = 4;
@@ -1179,6 +1213,8 @@ PUBLIC void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_it
 		free(iter->search_stack);
 		if (iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD)
 			SAVE_ERRNO_AND_CLOSE(iter->fd);
+		if (iter->cur_fd)
+			SAVE_ERRNO_AND_CLOSE(iter->cur_fd);
 		free(iter);
 	}
 }
@@ -1255,6 +1291,74 @@ static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_itera
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error build_subvol_path_user(struct btrfs_util_subvolume_iterator *iter,
+						    int fd,
+						    size_t *path_len_ret)
+{
+	struct search_stack_entry *top = top_search_stack_entry(iter);
+	struct btrfs_ioctl_ino_lookup_user_args args;
+	uint64_t dirid, treeid;
+	size_t dir_len, name_len, path_len;
+	char *p;
+	int ret;
+
+	dirid = top->rootref_args.rootref[top->items_pos].dirid;
+	treeid = top->rootref_args.rootref[top->items_pos].treeid;
+
+	memset(&args, 0, sizeof(args));
+	args.dirid = dirid;
+	args.treeid = treeid;
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
+		/*
+		 * Allocate one more byte for NULL as we call open() in
+		 * subvolume_iterator_next_user()
+		 */
+		char *tmp = realloc(iter->cur_path, path_len + 1);
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
@@ -1331,11 +1435,234 @@ out:
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error chdir_to_parent_subvolume(struct btrfs_util_subvolume_iterator *iter,
+						       struct search_stack_entry *top)
+{
+	size_t start, end;
+	int ret;
+
+	/* end indicates name length of current subvolume */
+	end = top->path_len;
+
+	/* start indicates name length of current's parent subvolume */
+	top = top_search_stack_entry(iter);
+	start = top->path_len;
+	if (start)
+		start++;
+
+	/* move up directory as many times '/' appear */
+	while (start < end) {
+		if (iter->cur_path[start] == '/') {
+			ret = chdir("..");
+			if (ret)
+				return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+		}
+		start++;
+	}
+	ret = chdir("..");
+	if (ret)
+		return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+
+	iter->cur_fd = open(".", O_RDONLY);
+	if (iter->cur_fd < 0)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
+static enum btrfs_util_error subvolume_iterator_next_user(struct btrfs_util_subvolume_iterator *iter,
+							  char **path_ret,
+							  uint64_t *id_ret)
+{
+	struct search_stack_entry *top;
+	size_t path_len;
+	enum btrfs_util_error err;
+	char *temp;
+	int child_fd, orig_fd;
+	int ret;
+
+	/* Remember current working directry to reset at return */
+	orig_fd = open(".", O_RDONLY);
+	if (orig_fd < 0)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	/*
+	 * Change working directory as traversing iterator,
+	 * in order to prevent ENAMETOOLONG error at open()
+	 */
+	ret = fchdir(iter->cur_fd);
+	if (ret) {
+		SAVE_ERRNO_AND_CLOSE(orig_fd);
+		return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+	}
+	if (iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER &&
+	    iter->search_stack_len > 1) {
+		SAVE_ERRNO_AND_CLOSE(iter->cur_fd);
+		top = top_search_stack_entry(iter);
+		iter->search_stack_len--;
+
+		err = chdir_to_parent_subvolume(iter, top);
+		if (err) {
+			SAVE_ERRNO_AND_CLOSE(orig_fd);
+			return err;
+		}
+	}
+
+	for (;;) {
+		for (;;) {
+			if (iter->search_stack_len == 0) {
+				ret = fchdir(orig_fd);
+				SAVE_ERRNO_AND_CLOSE(orig_fd);
+				if (ret)
+					return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+				return BTRFS_UTIL_ERROR_STOP_ITERATION;
+			}
+
+			top = top_search_stack_entry(iter);
+
+			if (top->items_pos < top->rootref_args.num_items) {
+				break;
+			} else {
+				top->items_pos = 0;
+				ret = ioctl(iter->cur_fd, BTRFS_IOC_GET_SUBVOL_ROOTREF,
+						&top->rootref_args);
+				if (ret < 0) {
+					if (errno != EOVERFLOW) {
+						SAVE_ERRNO_AND_CLOSE(orig_fd);
+						return BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED;
+					}
+				} else {
+					if (top->rootref_args.num_items == 0) {
+						if (iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) {
+							if (iter->search_stack_len == 1) {
+								ret = fchdir(orig_fd);
+								SAVE_ERRNO_AND_CLOSE(orig_fd);
+								if (ret)
+									return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+								return BTRFS_UTIL_ERROR_STOP_ITERATION;
+							}
+							goto out;
+						}
+
+						iter->search_stack_len--;
+						SAVE_ERRNO_AND_CLOSE(iter->cur_fd);
+
+						err = chdir_to_parent_subvolume(iter, top);
+						if (err) {
+							SAVE_ERRNO_AND_CLOSE(orig_fd);
+							return err;
+						}
+					}
+				}
+			}
+		}
+
+		err = build_subvol_path_user(iter, iter->cur_fd,
+				&path_len);
+		top->id = top->rootref_args.rootref[top->items_pos].treeid;
+		top->items_pos++;
+
+		/* Skip if permission error happens during path construction */
+		if (err) {
+			if (errno == EACCES)
+				continue;
+			SAVE_ERRNO_AND_CLOSE(orig_fd);
+			return err;
+		}
+
+		/* Extra check to the constructed path */
+		iter->cur_path[path_len] = '\0';
+		temp = &iter->cur_path[top->path_len];
+		if (*temp == '/')
+			temp++;
+		child_fd = open(temp, O_RDONLY);
+		if (child_fd < 0) {
+			/*
+			 * Skip if
+			 *  1. the path does not exist
+			 *     (may happen if a dir in the path is mounted)
+			 *  2. cannot open the path due to permission error
+			 */
+			if (errno == ENOENT || errno == EACCES)
+				continue;
+			SAVE_ERRNO_AND_CLOSE(orig_fd);
+			return BTRFS_UTIL_ERROR_OPEN_FAILED;
+		} else {
+			uint64_t temp_id;
+
+			/*
+			 * Check the subvolume status and skip if other volume
+			 * is mounted
+			 */
+			err = btrfs_util_is_subvolume_fd(child_fd);
+			if (err) {
+				SAVE_ERRNO_AND_CLOSE(child_fd);
+				if (err == BTRFS_UTIL_ERROR_NOT_BTRFS ||
+				    err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME)
+					continue;
+				SAVE_ERRNO_AND_CLOSE(orig_fd);
+				return err;
+			}
+			err = btrfs_util_subvolume_id_fd(child_fd, &temp_id);
+			if (err) {
+				SAVE_ERRNO_AND_CLOSE(orig_fd);
+				SAVE_ERRNO_AND_CLOSE(child_fd);
+				return err;
+			}
+			if (top->id != temp_id) {
+				SAVE_ERRNO_AND_CLOSE(child_fd);
+				continue;
+			}
+		}
+
+		err = append_to_search_stack(iter, top->id, path_len);
+		if (err) {
+			SAVE_ERRNO_AND_CLOSE(orig_fd);
+			SAVE_ERRNO_AND_CLOSE(child_fd);
+			return err;
+		}
+
+		SAVE_ERRNO_AND_CLOSE(iter->cur_fd);
+		iter->cur_fd = child_fd;
+
+		if (!(iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER)) {
+			top = top_search_stack_entry(iter);
+			goto out;
+		} else {
+			ret = fchdir(iter->cur_fd);
+			if (ret) {
+				SAVE_ERRNO_AND_CLOSE(orig_fd);
+				return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+			}
+		}
+	}
+
+out:
+	ret = fchdir(orig_fd);
+	SAVE_ERRNO_AND_CLOSE(orig_fd);
+	if (ret)
+		return BTRFS_UTIL_ERROR_CHDIR_FAILED;
+
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
@@ -1349,7 +1676,10 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrf
 	if (err)
 		return err;
 
-	return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	if (iter->use_tree_search)
+		return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	else
+		return btrfs_util_subvolume_info_fd(iter->cur_fd, 0, subvol);
 }
 
 PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes(const char *path,
-- 
2.14.4



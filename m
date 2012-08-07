Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32158 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HGI6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 04:58:30 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q778wSqs009122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:28 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q778wRpP009344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:27 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q778wRbi001041
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 03:58:27 -0500
Message-ID: <5020D886.40305@oracle.com>
Date: Tue, 07 Aug 2012 16:57:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 3/5] btrfs-progs: souce file of snapshot diff
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5020D84E.4010900@oracle.com>

Now the source file is coming.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 diff-snapshot.c | 1026 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1026 insertions(+), 0 deletions(-)
 create mode 100644 diff-snapshot.c

diff --git a/diff-snapshot.c b/diff-snapshot.c
new file mode 100644
index 0000000..7b7f4c7
--- /dev/null
+++ b/diff-snapshot.c
@@ -0,0 +1,1026 @@
+/*
+ * Copyright (C) 2012 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <uuid/uuid.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <assert.h>
+#include "ctree.h"
+#include "ioctl.h"
+#include "utils.h"
+#include "btrfs-list.h"
+#include "diff-snapshot.h"
+
+/*
+ * scan and cache the number of items from both snapshots at a time.
+ * FIXME: maybe it's better to let user to specify this value according
+ * to their memory status, cache more items every time can improve the
+ * overall performance as it could reduce the efforts to retrieve items
+ * through ioctl(2). or we can implement a routine to calculate this value
+ * based on the available memory, maybe sounds more reasonable.
+ */
+static unsigned int nr_item_scan = 4096;
+
+struct snapshot_diff_info {
+	/* source snapshot scan info */
+	struct snapshot_scan_info *src_scan_info;
+
+	/* destination snapshot scan info */
+	struct snapshot_scan_info *dest_scan_info;
+};
+
+struct snapshot_scan_info {
+	/* name */
+	char *snapshot;
+
+	/* snapshot dir id */
+	int fd;
+
+	/* snapshot tree id */
+	u64 tree_id;
+
+	/* the latest object id in last round of scan */
+	u64 last_objectid;
+
+	/* cache the scanned items on */
+	struct rb_root scanned_items;
+
+	/*
+	 * rb-tree to cache those items which have already been
+	 * processed by lookup snapshot, so it will not be cached
+	 * again. the memory allocated for it would be reclaimed
+	 * back once we determined that the business for it was
+	 * done.
+	 */
+	struct rb_root processed_items;
+
+	/* no more items can be fetched from a snapshot */
+	int scan_done;
+};
+
+/* item info at cache */
+struct snapshot_scan_item {
+	struct rb_node si_node;
+	u64 transid;
+	u64 objectid;
+	char *path;
+	u8 type;
+};
+
+/*
+ * processed items are those who are not returned in the current
+ * round of scan, but they are resides on snapshot.
+ */
+struct processed_item {
+	struct rb_node pi_node;
+	char *path;
+};
+
+static const char *decode_item_type(u8 type)
+{
+	char *typestr = "UNKNOWN";
+
+	switch (type) {
+	case BTRFS_FT_DIR:
+		typestr = "DIR";
+		break;
+	case BTRFS_FT_REG_FILE:
+		typestr = "REGFILE";
+		break;
+	case BTRFS_FT_CHRDEV:
+		typestr = "CHRDEV";
+		break;
+	case BTRFS_FT_BLKDEV:
+		typestr = "BLKDEV";
+		break;
+	case BTRFS_FT_FIFO:
+		typestr = "FIFO";
+		break;
+	case BTRFS_FT_SOCK:
+		typestr = "SOCKET";
+		break;
+	case BTRFS_FT_SYMLINK:
+		typestr = "SYMLINK";
+		break;
+	case BTRFS_FT_XATTR:
+		typestr = "XATTR";
+		break;
+	default:
+		break;
+	}
+
+	return typestr;
+}
+
+/*
+ * we found an item on both snapshots, check if it was updated or not
+ * by comparing ctime && mtime.
+ */
+static inline int item_is_updated(const char *src_snapshot,
+				  const char *dest_snapshot,
+				  const char *path, u8 item_type,
+				  int *updated)
+{
+	char src_full_path[BTRFS_PATH_NAME_MAX + 1];
+	char dest_full_path[BTRFS_PATH_NAME_MAX + 1];
+	struct stat st1;
+	struct stat st2;
+	int ret = 0;
+
+	ret = snprintf(src_full_path, sizeof(src_full_path), "%s/%s",
+		       src_snapshot, path);
+	if (ret < 0) {
+		fprintf(stderr, "failed to build full path [%s/%s]\n",
+			src_snapshot, path);
+		goto out;
+	}
+
+	ret = snprintf(dest_full_path, sizeof(dest_full_path), "%s/%s",
+		       dest_snapshot, path);
+	if (ret < 0) {
+		fprintf(stderr, "failed to build full path [%s/%s]\n",
+			dest_snapshot, path);
+		goto out;
+	}
+
+	if (item_type == BTRFS_FT_SYMLINK) {
+		if (lstat(src_full_path, &st1) < 0) {
+			fprintf(stderr, "lstat %s failed %s\n",
+				src_full_path, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+
+		if (lstat(dest_full_path, &st2) < 0) {
+			fprintf(stderr, "lstat %s failed %s\n",
+				dest_full_path, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+	} else {
+		if (stat(src_full_path, &st1) < 0) {
+			fprintf(stderr, "stat src path %s failed %s\n",
+				src_full_path, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+
+		if (stat(dest_full_path, &st2) < 0) {
+			fprintf(stderr, "stat dest path %s failed %s\n",
+				dest_full_path, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+	}
+
+	*updated = (st1.st_mtime != st2.st_mtime ||
+		    st1.st_ctime != st2.st_ctime) ? 1 : 0;
+
+out:
+	return ret;
+}
+
+static const char *decode_item_state(unsigned int state)
+{
+	char *s = NULL;
+
+	switch (state) {
+	case SNAPSHOT_DIFF_NEW_ITEM:
+		s = "NEW";
+		break;
+	case SNAPSHOT_DIFF_REMOVED_ITEM:
+		s = "REMOVED";
+		break;
+	case SNAPSHOT_DIFF_UPDATED_ITEM:
+		s = "UPDATED";
+		break;
+	default:
+		break;
+	}
+
+	return s;
+}
+
+static inline void print_item_diff_info(struct snapshot_scan_item *item,
+					const char *snapshot,
+					unsigned int state)
+{
+	const char *s = decode_item_state(state);
+	const char *type = decode_item_type(item->type);
+
+	printf("[%s %s] %s/%s objectid %llu transid %llu\n",
+		s, type, snapshot, item->path, item->objectid,
+		item->transid);
+}
+
+static inline int snapshot_diff_init(struct snapshot_diff_info *diff_info)
+
+{
+	diff_info->src_scan_info = malloc(sizeof(struct snapshot_scan_info));
+	if (!diff_info->src_scan_info)
+		return -ENOMEM;
+
+	diff_info->dest_scan_info = malloc(sizeof(struct snapshot_scan_info));
+	if (!diff_info->dest_scan_info)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline int snapshot_item_scan_init(struct snapshot_scan_info *scan_info,
+					  const char *snapshot, int fd,
+					  u64 tree_id)
+{
+	scan_info->snapshot = strdup(snapshot);
+	if (!scan_info->snapshot)
+		return -ENOMEM;
+
+	scan_info->fd = fd;
+	scan_info->tree_id = tree_id;
+	scan_info->last_objectid = 256;
+	scan_info->scan_done = 0;
+	scan_info->scanned_items = RB_ROOT;
+	scan_info->processed_items = RB_ROOT;
+}
+
+static u64 get_snapshot_tree_id(int fd)
+{
+	struct btrfs_ioctl_ino_lookup_args ino_args;
+	int ret;
+
+	memset(&ino_args, 0, sizeof(ino_args));
+	ino_args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_args);
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: Failed to lookup path for dirid %llu - %s\n",
+			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID,
+			strerror(errno));
+		return 0;
+	}
+
+	return ino_args.treeid;
+}
+
+static int cache_processed_item(struct rb_root *root, const char *path)
+{
+	struct rb_node **p = &(root->rb_node);
+	struct rb_node *parent = NULL;
+	struct processed_item *item;
+
+	while (*p) {
+		int ret;
+		struct processed_item *this;
+		this = rb_entry(*p, struct processed_item, pi_node);
+		parent = *p;
+		ret = strcmp(this->path, path);
+		if (ret > 0)
+			p = &(*p)->rb_left;
+		else if (ret < 0)
+			p = &(*p)->rb_right;
+		else
+			/*
+			 * FIXME: to handle this situation in a
+			 * more reasonable way.
+			 */
+			return 0;
+	}
+
+	item = calloc(1, sizeof(*item));
+	item->path = strdup(path);
+	if (!item->path) {
+		fprintf(stderr, "out of memory to cache processed item\n");
+		return -ENOMEM;
+	}
+
+	rb_link_node(&item->pi_node, parent, p);
+	rb_insert_color(&item->pi_node, root);
+
+	return 0;
+}
+
+static struct processed_item *find_processed_item(struct rb_root *root,
+						  const char *path)
+{
+	struct rb_node *node = rb_first(root);
+	struct processed_item *this;
+
+	while (node) {
+		int ret;
+		this = rb_entry(node, struct processed_item, pi_node);
+		ret = strcmp(this->path, path);
+		if (ret > 0)
+			node = node->rb_left;
+		else if (ret < 0)
+			node = node->rb_right;
+		else
+			return this;
+	}
+
+	return NULL;
+}
+
+static void remove_processed_item(struct rb_root *root, const char *path)
+{
+	struct processed_item *item;
+
+	item = find_processed_item(root, path);
+	if (item) {
+		rb_erase(&item->pi_node, root);
+		free(item->path);
+		free(item);
+	}
+}
+
+static int item_is_processed(struct rb_root *root, const char *path)
+{
+	return find_processed_item(root, path) ? 1 : 0;
+}
+
+static void free_processed_items(struct rb_root *root)
+{
+	struct processed_item *item;
+	struct rb_node *node;
+
+	while ((node = rb_first(root))) {
+		item = rb_entry(node, struct processed_item, pi_node);
+		rb_erase(&item->pi_node, root);
+		free(item->path);
+		free(item);
+	}
+}
+
+static void snapshot_item_scan_free(struct snapshot_scan_info *scan_info)
+{
+	struct rb_root *root = &scan_info->scanned_items;
+	struct snapshot_scan_item *item;
+	struct rb_node *node;
+
+	while ((node = rb_first(root))) {
+		item = rb_entry(node, struct snapshot_scan_item, si_node);
+		rb_erase(&item->si_node, root);
+		free(item->path);
+		free(item);
+	}
+}
+
+static inline void
+snapshot_diff_destroy(struct snapshot_diff_info *diff_info)
+{
+	struct snapshot_scan_info *src_scan_info = diff_info->src_scan_info;
+	struct snapshot_scan_info *dest_scan_info = diff_info->dest_scan_info;
+
+	free(src_scan_info->snapshot);
+	free(dest_scan_info->snapshot);
+
+	free_processed_items(&src_scan_info->processed_items);
+	free_processed_items(&dest_scan_info->processed_items);
+
+	snapshot_item_scan_free(diff_info->src_scan_info);
+	snapshot_item_scan_free(diff_info->dest_scan_info);
+
+	free(src_scan_info);
+	free(dest_scan_info);
+}
+
+static int add_item_to_cache(struct rb_root *root, const char *path, u8 type,
+			     u64 objectid, u64 transid)
+{
+	struct rb_node **p = &(root->rb_node);
+	struct rb_node *parent = NULL;
+	struct snapshot_scan_item *item;
+
+	while (*p) {
+		struct snapshot_scan_item *this;
+		int ret;
+
+		this = rb_entry(*p, struct snapshot_scan_item, si_node);
+		parent = *p;
+		ret = strcmp(this->path, path);
+		if (ret > 0)
+			p = &(*p)->rb_left;
+		else if (ret < 0)
+			p = &(*p)->rb_right;
+		else
+			assert(0);
+	}
+
+	item = malloc(sizeof(struct snapshot_scan_item));
+	if (!item) {
+		fprintf(stderr, "out of memory while inserting new item\n");
+		return -ENOMEM;
+	}
+
+	item->path = strdup(path);
+	if (!item->path) {
+		fprintf(stderr, "out of memory while inserting new item\n");
+		return -ENOMEM;
+	}
+
+	item->type = type;
+	item->objectid = objectid;
+	item->transid = transid;
+
+	rb_link_node(&item->si_node, parent, p);
+	rb_insert_color(&item->si_node, root);
+	return 0;
+}
+
+static int process_snapshot_item(struct snapshot_scan_info *scan_info,
+				 struct btrfs_dir_item *item)
+{
+	struct rb_root *processed_items = &scan_info->processed_items;
+	struct rb_root *scanned_items = &scan_info->scanned_items;
+	char *cache_dir_name = NULL;
+	int fd = scan_info->fd;
+	char *path;
+	u64 cache_dirid;
+	int ret = 0;
+
+	path = ino_resolve(fd, item->location.objectid,
+			   &cache_dirid, &cache_dir_name);
+	if (!path) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * this item can be freely skipped as we have already processed
+	 * it in previous business.
+	 */
+	if (item_is_processed(processed_items, path)) {
+		remove_processed_item(processed_items, path);
+		goto out;
+	}
+
+	ret = add_item_to_cache(scanned_items, path, item->type,
+			        item->location.objectid,
+			        item->transid);
+
+out:
+	return ret;
+}
+
+static int do_snapshot_scan(struct snapshot_scan_info *scan_info)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_dir_item *item;
+	struct btrfs_dir_item backup;
+	int fd = scan_info->fd;
+	int count = 0;
+	int ret;
+
+	memset(&backup, 0, sizeof(backup));
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = scan_info->tree_id;
+	sk->min_objectid = scan_info->last_objectid;
+	sk->min_type = BTRFS_DIR_INDEX_KEY;
+	sk->max_type = BTRFS_DIR_INDEX_KEY;
+
+	/*
+	 * set all the other params to the max, we'll take any objectid
+	 * and any trans
+	 */
+	sk->max_objectid = (u64)-1;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	/* just a big number, doesn't matter much */
+	sk->nr_items = 4096;
+
+	do {
+		unsigned long off = 0;
+		int i;
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: can't perform the search %s\n",
+				strerror(errno));
+			return ret;
+		}
+
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0) {
+			scan_info->scan_done = true;
+			break;
+		}
+
+		/*
+		 * for each item, pull the key out of the header and then
+		 * read the root_ref item it contains
+		 */
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+
+			/*
+			 * just in case the item was too big, pass something
+			 * other than garbage
+			 */
+			if (sh->len == 0)
+				item = &backup;
+			else
+				item = (struct btrfs_dir_item *)(args.buf +
+								 off);
+
+			if (sh->type == BTRFS_DIR_INDEX_KEY) {
+				ret = process_snapshot_item(scan_info, item);
+				if (ret < 0)
+					return ret;
+				++count;
+			}
+
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_objectid = sh->objectid;
+			sk->min_offset = sh->offset;
+			sk->min_type = sh->type;
+		}
+
+		if (sk->min_offset < (u64)-1) {
+			sk->min_offset++;
+		} else if (sk->min_objectid < (u64)-1) {
+			sk->min_objectid++;
+			sk->min_offset = 0;
+			sk->min_type = 0;
+		} else {
+			scan_info->scan_done = 1;
+			break;
+		}
+	} while (count < nr_item_scan);
+
+	if (!scan_info->scan_done)
+		scan_info->last_objectid = sk->min_objectid;
+
+	return ret;
+}
+
+static int snapshot_item_scan_read(struct snapshot_scan_info *scan_info)
+{
+	return do_snapshot_scan(scan_info);
+}
+
+static struct snapshot_scan_item *find_item_on_cache(struct rb_root *root,
+						     const char *path)
+{
+	struct rb_node *node = rb_first(root);
+	struct snapshot_scan_item *this;
+
+	while (node) {
+		int ret;
+		this = rb_entry(node, struct snapshot_scan_item, si_node);
+		ret = strcmp(this->path, path);
+		if (ret > 0)
+			node = node->rb_left;
+		else if (ret < 0)
+			node = node->rb_right;
+		else
+			return this;
+	}
+
+	return NULL;
+}
+
+static void remove_item_from_cache(struct rb_root *root, const char *path)
+{
+	struct snapshot_scan_item *item;
+
+	item = find_item_on_cache(root, path);
+	if (item) {
+		rb_erase(&item->si_node, root);
+		free(item->path);
+		free(item);
+	}
+}
+
+/* check if an item path does exist on dest snapshot or not */
+static inline int find_item_on_snapshot(const char *path, u8 type, int *found)
+{
+	int ret;
+
+	if (type != BTRFS_FT_SYMLINK) {
+		ret = access(path, F_OK);
+		if (ret == 0) {
+			*found = 1;
+			goto out;
+		}
+
+		if (errno == ENOENT) {
+			*found = 0;
+			ret = 0;
+			goto out;
+		}
+		fprintf(stderr, "failed to access %s as %s\n",
+			path, strerror(errno));
+	} else {
+		struct stat st;
+		ret = lstat(path, &st);
+		if (ret == 0) {
+			*found = 1;
+			goto out;
+		}
+
+		if (errno == ENOENT) {
+			*found = 0;
+			ret = 0;
+			goto out;
+		}
+		fprintf(stderr, "failed to lstat %s failed as %s\n",
+			path, strerror(errno));
+	}
+
+out:
+	return ret;
+}
+
+static int do_item_diff(struct snapshot_scan_item *item, u8 item_type,
+			unsigned int item_state, const char *src_snapshot,
+			const char *dest_snapshot, unsigned int flags)
+{
+	int updated;
+	int ret = 0;
+
+	switch (item_state) {
+	case SNAPSHOT_DIFF_NEW_ITEM:
+		if (SNAPSHOT_DIFF_SHOW_NEW_ITEM(flags))
+			print_item_diff_info(item, dest_snapshot, item_state);
+		break;
+	case SNAPSHOT_DIFF_REMOVED_ITEM:
+		if (SNAPSHOT_DIFF_SHOW_REMOVED_ITEM(flags))
+			print_item_diff_info(item, src_snapshot, item_state);
+		break;
+	case SNAPSHOT_DIFF_UPDATED_ITEM:
+		if (SNAPSHOT_DIFF_SHOW_UPDATED_ITEM(flags)) {
+			ret = item_is_updated(src_snapshot, dest_snapshot,
+					      item->path, item_type, &updated);
+			if (ret < 0)
+				return ret;
+
+			if (updated) {
+				print_item_diff_info(item, dest_snapshot,
+						     item_state);
+			}
+		}
+		break;
+	default:
+		assert(0);
+	}
+
+	return ret;
+}
+
+static int inline build_full_path(char full_path[BTRFS_PATH_NAME_MAX + 1],
+				  const char *src_snapshot,
+				  const char *path)
+{
+	size_t len = strlen(src_snapshot) + strlen(path) + 1;
+
+	if (snprintf(full_path, BTRFS_PATH_NAME_MAX + 1, "%s/%s",
+		     src_snapshot, path) != len) {
+		fprintf(stderr, "failed to build full path %s/%s\n",
+			src_snapshot, path);
+		return -1;
+	}
+
+	return 0;
+}
+
+
+/*
+ * step through each scanned item from source cache, and check it up on dest
+ * cache firstly. if an item can be found at dest cache and if it does not
+ * changed by examining its ctime and mtime upon the source one, proceed to
+ * check the next source item, or print the updated info if needed.
+ * if we can not find it at the dest cache, probably it resides on the dest
+ * snapshot, hence, we need to check it up on there. if it does not exist,
+ * print the removed info if needed, otherwise, check if it was updated or not.
+ */
+static int process_source_item_cache(struct snapshot_scan_info *src_scan_info,
+				     struct snapshot_scan_info *dest_scan_info,
+				     unsigned int flags)
+{
+	struct rb_root *src_scanned_items = &src_scan_info->scanned_items;
+	struct rb_root *dest_scanned_items = &dest_scan_info->scanned_items;
+	struct rb_root *processed_items = &dest_scan_info->processed_items;
+	const char *src_snapshot = src_scan_info->snapshot;
+	const char *dest_snapshot = dest_scan_info->snapshot;
+	struct rb_node *node;
+	u8 item_type;
+	int ret = 0;
+
+	for (node = rb_first(src_scanned_items); node; node = rb_next(node)) {
+		char full_path[BTRFS_PATH_NAME_MAX + 1];
+		struct snapshot_scan_item *src_item;
+		struct snapshot_scan_item *dest_item;
+		unsigned int item_state;
+		const char *path;
+		int found = 0;
+
+		src_item = rb_entry(node, struct snapshot_scan_item, si_node);
+		item_type = src_item->type;
+		path = src_item->path;
+
+		/* can it be found on dest cache? */
+		dest_item = find_item_on_cache(dest_scanned_items, path);
+		if (dest_item) {
+			item_state = SNAPSHOT_DIFF_UPDATED_ITEM,
+			ret = do_item_diff(src_item, item_type, item_state,
+					   src_snapshot, dest_snapshot, flags);
+			if (ret < 0)
+				break;
+
+			continue;
+		}
+
+		ret = build_full_path(full_path, dest_snapshot, path);
+		if (ret < 0)
+			break;
+
+		/*
+		 * the source item was not found from dest cache. probably
+		 * it resides at dest snapshot, try to lookup it there so.
+		 */
+		ret = find_item_on_snapshot(full_path, item_type, &found);
+		if (ret < 0)
+			break;
+
+		item_state = found ? SNAPSHOT_DIFF_UPDATED_ITEM :
+				     SNAPSHOT_DIFF_REMOVED_ITEM;
+		ret = do_item_diff(src_item, item_type, item_state,
+				   src_snapshot, dest_snapshot, flags);
+		if (ret < 0)
+			break;
+
+		/*
+		 * so we found the source item from the dest snapshot,
+		 * however, it will be retrieved again when scanning
+		 * the dest snapshot at a later time. to avoid this,
+		 * we should put it to the dest processed tree, so it
+		 * will be skipped to cache again at that time.
+		 */
+		if (found) {
+			ret = cache_processed_item(processed_items, path);
+			if (ret < 0)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * revert to iterate the left items in dest cache and find out whether it
+ * resides on source snapshot or not. note that, those left items must not
+ * exists on source cache as we have already done that check up. so we only
+ * need to examine if it does exist on source subvolume or not. if not, a
+ * a new created item was found. otherwise, check it was updated or not.
+ */
+static int process_dest_item_cache(struct snapshot_scan_info *src_scan_info,
+				   struct snapshot_scan_info *dest_scan_info,
+				   int flags)
+{
+	struct rb_root *scanned_items = &dest_scan_info->scanned_items;
+	struct rb_root *processed_items = &src_scan_info->processed_items;
+	const char *src_snapshot = src_scan_info->snapshot;
+	const char *dest_snapshot = dest_scan_info->snapshot;
+	struct rb_node *node;
+	int ret = 0;
+
+	for (node = rb_first(scanned_items); node; node = rb_next(node)) {
+		char full_path[BTRFS_PATH_NAME_MAX + 1];
+		struct snapshot_scan_item *item;
+		unsigned int item_state;
+		const char *path;
+		u8 item_type;
+		int found = 0;
+
+		item = rb_entry(node, struct snapshot_scan_item, si_node);
+		path = item->path;
+
+		ret = build_full_path(full_path, src_snapshot, path);
+		if (ret < 0)
+			break;
+
+		item_type = item->type;
+		/* check if this item located at source snapshot or not */
+		ret = find_item_on_snapshot(full_path, item_type, &found);
+		if (ret < 0)
+			break;
+
+		item_state = found ? SNAPSHOT_DIFF_UPDATED_ITEM :
+				     SNAPSHOT_DIFF_NEW_ITEM;
+		ret = do_item_diff(item, item_type, item_state, src_snapshot,
+				   dest_snapshot, flags);
+		if (ret < 0)
+			break;
+
+		/*
+		 * so we found this time on the source snapshot. put it to
+		 * processed tree so we'll not cache and handle it again.
+		 */
+		if (found) {
+			ret = cache_processed_item(processed_items, path);
+			if (ret < 0)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * so we have two caches holding the scanned items from both source and
+ * dest snapshot, perform real diff business now.
+ */
+static int do_diff_items(struct snapshot_scan_info *src_scan_info,
+			 struct snapshot_scan_info *dest_scan_info,
+			 unsigned int flags)
+{
+	int ret = 0;
+
+	ret = process_source_item_cache(src_scan_info, dest_scan_info, flags);
+	if (ret < 0)
+		return ret;
+
+	ret = process_dest_item_cache(src_scan_info, dest_scan_info, flags);
+	return ret;
+}
+
+int snapshot_diff(int src_fd, int dest_fd, const char *src_snapshot,
+		  const char *dest_snapshot, unsigned int flags)
+{
+	struct snapshot_diff_info diff_info;
+	struct snapshot_scan_info *src_scan_info;
+	struct snapshot_scan_info *dest_scan_info;
+	u64 src_tree_id;
+	u64 dest_tree_id;
+	int diff_done = 0;
+	int ret;
+
+	/*
+	 * commit buffer cache to disk to make the new transactions
+	 * of both snapshots take affected immediately.
+	 */
+	sync();
+
+	src_tree_id = get_snapshot_tree_id(src_fd);
+	if (!src_tree_id)
+		return 1;
+
+	dest_tree_id = get_snapshot_tree_id(dest_fd);
+	if (!dest_tree_id)
+		return 1;
+
+	/*
+	 * list all changes on the dest snapshot if no option
+	 * was specified.
+	 */
+	if (!flags) {
+		flags |= (SNAPSHOT_DIFF_LIST_NEW_ITEM |
+			  SNAPSHOT_DIFF_LIST_REMOVED_ITEM |
+			  SNAPSHOT_DIFF_LIST_UPDATED_ITEM);
+	}
+
+	ret = snapshot_diff_init(&diff_info);
+	if (ret < 0) {
+		fprintf(stderr, "snapshot diff init failed\n");
+		return ret;
+	}
+
+	src_scan_info = diff_info.src_scan_info;
+	dest_scan_info = diff_info.dest_scan_info;
+	ret = snapshot_item_scan_init(src_scan_info, src_snapshot, src_fd,
+				      src_tree_id);
+	if (ret < 0) {
+		fprintf(stderr, "source snapshot scan init failed\n");
+		return ret;
+	}
+
+	ret = snapshot_item_scan_init(dest_scan_info, dest_snapshot, dest_fd,
+				      dest_tree_id);
+	if (ret < 0) {
+		fprintf(stderr, "dest snapshot scan init failed\n");
+		return ret;
+	}
+
+	while (1) {
+		/*
+		 * scan the specified number of items(4096) and cache
+		 * them on rb-tree from both source and dest snapshot.
+		 */
+		ret = snapshot_item_scan_read(src_scan_info);
+		if (ret)
+			goto out;
+
+		ret = snapshot_item_scan_read(dest_scan_info);
+		if (ret)
+			goto out;
+
+		/* fire up */
+		ret = do_diff_items(src_scan_info, dest_scan_info, flags);
+		if (ret)
+			goto out;
+
+		/*
+		 * this round diff process done, free up those cached
+		 * items so.
+		 */
+		snapshot_item_scan_free(src_scan_info);
+		snapshot_item_scan_free(dest_scan_info);
+
+		/*
+		 * no more item can be probed from the source snapshot,
+		 * if the same thing happen to dest, which means that we
+		 * have gone through all items in both of them, diff done.
+		 * Otherwise, we'll drop through to experience some extra
+		 * check up.  If there still have items at source snapshot,
+		 * proceed to next round of scan && diff.
+		 */
+		if (src_scan_info->scan_done) {
+			if (dest_scan_info->scan_done)
+				diff_done = 1;
+			break;
+		}
+	}
+
+	/*
+	 * come to this point, probably the diff process is totally complete
+	 * because of no more items can be fetched on both snapshots. or the
+	 * source scan was done, and the user don't want to list those new
+	 * created items on dest snapshot, or the destination scan was done
+	 * and the user don't want to list the those items which are resides
+	 * on source snapshot but may be removed on destination.
+	 */
+	if (diff_done ||
+	    ((src_scan_info->scan_done &&
+	     !SNAPSHOT_DIFF_SHOW_NEW_ITEM(flags)) ||
+	     (dest_scan_info->scan_done &&
+	     !(SNAPSHOT_DIFF_SHOW_REMOVED_ITEM(flags)))))
+		goto out;
+
+	/*
+	 * there may be have some items resides at either source snapshot
+	 * or destination, we have to deal with them if needed.
+	 */
+	if (!src_scan_info->scan_done &&
+	    SNAPSHOT_DIFF_SHOW_REMOVED_ITEM(flags)) {
+		do {
+			ret = snapshot_item_scan_read(src_scan_info);
+			if (ret)
+				goto out;
+
+			ret = do_diff_items(src_scan_info, dest_scan_info,
+					    flags);
+			if (ret)
+				goto out;
+		} while (!src_scan_info->scan_done);
+	}
+
+	if (!dest_scan_info->scan_done &&
+	    SNAPSHOT_DIFF_SHOW_NEW_ITEM(flags)) {
+		do {
+			ret = snapshot_item_scan_read(dest_scan_info);
+			if (ret)
+				break;
+
+			ret = do_diff_items(src_scan_info, dest_scan_info,
+					    flags);
+			if (ret)
+				break;
+		} while (!dest_scan_info->scan_done);
+	}
+
+out:
+	snapshot_diff_destroy(&diff_info);
+	return ret;
+}
-- 
1.7.4.1

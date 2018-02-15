Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42849 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167178AbeBOTFx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:53 -0500
Received: by mail-pl0-f68.google.com with SMTP id 31so346599ple.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:53 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 23/27] btrfs-progs: use libbtrfsutil for subvol sync
Date: Thu, 15 Feb 2018 11:05:08 -0800
Message-Id: <f39e48b3ed0f860ec47b31fbfe08f6455d6fbaa8.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_util_f_deleted_subvolumes() replaces enumerate_dead_subvols() and
btrfs_util_f_subvolume_info() replaces is_subvolume_cleaned().

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 217 ++++++-------------------------------------------------
 1 file changed, 21 insertions(+), 196 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 49c9c8cf..9bab9312 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -42,38 +42,11 @@
 #include "utils.h"
 #include "help.h"
 
-static int is_subvolume_cleaned(int fd, u64 subvolid)
+static int wait_for_subvolume_cleaning(int fd, size_t count, uint64_t *ids,
+				       int sleep_interval)
 {
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	sk->min_objectid = subvolid;
-	sk->max_objectid = subvolid;
-	sk->min_type = BTRFS_ROOT_ITEM_KEY;
-	sk->max_type = BTRFS_ROOT_ITEM_KEY;
-	sk->min_offset = 0;
-	sk->max_offset = (u64)-1;
-	sk->min_transid = 0;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 1;
-
-	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-	if (ret < 0)
-		return -errno;
-
-	if (sk->nr_items == 0)
-		return 1;
-
-	return 0;
-}
-
-static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
-		int sleep_interval)
-{
-	int ret;
-	int i;
+	size_t i;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int clean = 1;
@@ -81,16 +54,14 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 		for (i = 0; i < count; i++) {
 			if (!ids[i])
 				continue;
-			ret = is_subvolume_cleaned(fd, ids[i]);
-			if (ret < 0) {
-				error(
-			    "cannot read status of dead subvolume %llu: %s",
-					(unsigned long long)ids[i], strerror(-ret));
-				return ret;
-			}
-			if (ret) {
-				printf("Subvolume id %llu is gone\n", ids[i]);
+			err = btrfs_util_subvolume_info_fd(fd, ids[i], NULL);
+			if (err == BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND) {
+				printf("Subvolume id %" PRIu64 " is gone\n",
+				       ids[i]);
 				ids[i] = 0;
+			} else if (err) {
+				error_btrfs_util(err);
+				return -errno;
 			} else {
 				clean = 0;
 			}
@@ -1028,160 +999,15 @@ static const char * const cmd_subvol_sync_usage[] = {
 	NULL
 };
 
-#if 0
-/*
- * If we're looking for any dead subvolume, take a shortcut and look
- * for any ORPHAN_ITEMs in the tree root
- */
-static int fs_has_dead_subvolumes(int fd)
-{
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header sh;
-	u64 min_subvolid = 0;
-
-again:
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	sk->min_objectid = BTRFS_ORPHAN_OBJECTID;
-	sk->max_objectid = BTRFS_ORPHAN_OBJECTID;
-	sk->min_type = BTRFS_ORPHAN_ITEM_KEY;
-	sk->max_type = BTRFS_ORPHAN_ITEM_KEY;
-	sk->min_offset = min_subvolid;
-	sk->max_offset = (u64)-1;
-	sk->min_transid = 0;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 1;
-
-	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-	if (ret < 0)
-		return -errno;
-
-	if (!sk->nr_items)
-		return 0;
-
-	memcpy(&sh, args.buf, sizeof(sh));
-	min_subvolid = sh.offset;
-
-	/*
-	 * Verify that the root item is really there and we haven't hit
-	 * a stale orphan
-	 */
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	sk->min_objectid = min_subvolid;
-	sk->max_objectid = min_subvolid;
-	sk->min_type = BTRFS_ROOT_ITEM_KEY;
-	sk->max_type = BTRFS_ROOT_ITEM_KEY;
-	sk->min_offset = 0;
-	sk->max_offset = (u64)-1;
-	sk->min_transid = 0;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 1;
-
-	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-	if (ret < 0)
-		return -errno;
-
-	/*
-	 * Stale orphan, try the next one
-	 */
-	if (!sk->nr_items) {
-		min_subvolid++;
-		goto again;
-	}
-
-	return 1;
-}
-#endif
-
-#define SUBVOL_ID_BATCH		1024
-
-/*
- * Enumerate all dead subvolumes that exist in the filesystem.
- * Fill @ids and reallocate to bigger size if needed.
- */
-static int enumerate_dead_subvols(int fd, u64 **ids)
-{
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	int idx = 0;
-	int count = 0;
-
-	memset(&args, 0, sizeof(args));
-
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	sk->min_objectid = BTRFS_ORPHAN_OBJECTID;
-	sk->max_objectid = BTRFS_ORPHAN_OBJECTID;
-	sk->min_type = BTRFS_ORPHAN_ITEM_KEY;
-	sk->max_type = BTRFS_ORPHAN_ITEM_KEY;
-	sk->min_offset = 0;
-	sk->max_offset = (u64)-1;
-	sk->min_transid = 0;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 4096;
-
-	*ids = NULL;
-	while (1) {
-		struct btrfs_ioctl_search_header *sh;
-		unsigned long off;
-		int i;
-
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		if (ret < 0)
-			return -errno;
-
-		if (!sk->nr_items)
-			return idx;
-
-		off = 0;
-		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header*)(args.buf + off);
-			off += sizeof(*sh);
-
-			if (btrfs_search_header_type(sh)
-			    == BTRFS_ORPHAN_ITEM_KEY) {
-				if (idx >= count) {
-					u64 *newids;
-
-					count += SUBVOL_ID_BATCH;
-					newids = (u64*)realloc(*ids,
-							count * sizeof(u64));
-					if (!newids)
-						return -ENOMEM;
-					*ids = newids;
-				}
-				(*ids)[idx] = btrfs_search_header_offset(sh);
-				idx++;
-			}
-			off += btrfs_search_header_len(sh);
-
-			sk->min_objectid = btrfs_search_header_objectid(sh);
-			sk->min_type = btrfs_search_header_type(sh);
-			sk->min_offset = btrfs_search_header_offset(sh);
-		}
-		if (sk->min_offset < (u64)-1)
-			sk->min_offset++;
-		else
-			break;
-		if (sk->min_type != BTRFS_ORPHAN_ITEM_KEY)
-			break;
-		if (sk->min_objectid != BTRFS_ORPHAN_OBJECTID)
-			break;
-	}
-
-	return idx;
-}
-
 static int cmd_subvol_sync(int argc, char **argv)
 {
 	int fd = -1;
-	int i;
 	int ret = 1;
 	DIR *dirstream = NULL;
-	u64 *ids = NULL;
-	int id_count;
+	uint64_t *ids;
+	size_t id_count, i;
 	int sleep_interval = 1;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c = getopt(argc, argv, "s:");
@@ -1215,10 +1041,9 @@ static int cmd_subvol_sync(int argc, char **argv)
 
 	id_count = argc - optind;
 	if (!id_count) {
-		id_count = enumerate_dead_subvols(fd, &ids);
-		if (id_count < 0) {
-			error("can't enumerate dead subvolumes: %s",
-					strerror(-id_count));
+		err = btrfs_util_deleted_subvolumes_fd(fd, &ids, &id_count);
+		if (err) {
+			error_btrfs_util(err);
 			ret = 1;
 			goto out;
 		}
@@ -1227,7 +1052,7 @@ static int cmd_subvol_sync(int argc, char **argv)
 			goto out;
 		}
 	} else {
-		ids = (u64*)malloc(id_count * sizeof(u64));
+		ids = malloc(id_count * sizeof(uint64_t));
 		if (!ids) {
 			error("not enough memory");
 			ret = 1;
@@ -1241,13 +1066,13 @@ static int cmd_subvol_sync(int argc, char **argv)
 			arg = argv[optind + i];
 			errno = 0;
 			id = strtoull(arg, NULL, 10);
-			if (errno < 0) {
+			if (errno) {
 				error("unrecognized subvolume id %s", arg);
 				ret = 1;
 				goto out;
 			}
-			if (id < BTRFS_FIRST_FREE_OBJECTID
-					|| id > BTRFS_LAST_FREE_OBJECTID) {
+			if (id < BTRFS_FIRST_FREE_OBJECTID ||
+			    id > BTRFS_LAST_FREE_OBJECTID) {
 				error("subvolume id %s out of range", arg);
 				ret = 1;
 				goto out;
-- 
2.16.1


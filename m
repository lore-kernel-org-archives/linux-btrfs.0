Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19775 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbbDQSCS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 14:02:18 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3HI0gv6026102
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 11:02:18 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1tu6ang2vc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 11:02:18 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] Btrfs-progs: check for matchin free space in cache
Date: Fri, 17 Apr 2015 14:02:15 -0400
Message-ID: <1429293735-31351-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have this check in the kernel but not in userspace, which makes fsck fail
when we wouldn't have a problem in the kernel.  This was meant to catch this
case because it really isn't good, unfortunately it will require a design change
to fix in the kernel so in the meantime add this check so we can be sure our
tests only catch real problems.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2:
- only check matched if __load_free_space_cache is successful

 ctree.h            |  1 +
 extent-tree.c      | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 free-space-cache.c | 11 +++++++++++
 3 files changed, 63 insertions(+)

diff --git a/ctree.h b/ctree.h
index 2042771..10dc838 100644
--- a/ctree.h
+++ b/ctree.h
@@ -936,6 +936,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_block_group_item item;
 	struct btrfs_space_info *space_info;
 	struct btrfs_free_space_ctl *free_space_ctl;
+	u64 bytes_super;
 	u64 pinned;
 	u64 flags;
 	int cached;
diff --git a/extent-tree.c b/extent-tree.c
index e8545ef..c24af6a 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3140,6 +3140,54 @@ error:
 	return ret;
 }
 
+static void account_super_bytes(struct btrfs_fs_info *fs_info,
+				struct btrfs_block_group_cache *cache)
+{
+	u64 bytenr;
+	u64 *logical;
+	int stripe_len;
+	int i, nr, ret;
+
+	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
+		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
+		cache->bytes_super += stripe_len;
+	}
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_rmap_block(&fs_info->mapping_tree,
+				       cache->key.objectid, bytenr,
+				       0, &logical, &nr, &stripe_len);
+		if (ret)
+			return;
+
+		while (nr--) {
+			u64 start, len;
+
+			if (logical[nr] > cache->key.objectid +
+			    cache->key.offset)
+				continue;
+
+			if (logical[nr] + stripe_len <= cache->key.objectid)
+				continue;
+
+			start = logical[nr];
+			if (start < cache->key.objectid) {
+				start = cache->key.objectid;
+				len = (logical[nr] + stripe_len) - start;
+			} else {
+				len = min_t(u64, stripe_len,
+					    cache->key.objectid +
+					    cache->key.offset - start);
+			}
+
+			cache->bytes_super += len;
+		}
+
+		kfree(logical);
+	}
+}
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -3201,6 +3249,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
 			cache->ro = 1;
 
+		account_super_bytes(info, cache);
+
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
@@ -3242,6 +3292,7 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
+	account_super_bytes(fs_info, cache);
 	ret = update_space_info(fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
diff --git a/free-space-cache.c b/free-space-cache.c
index 99ad420..84a50e3 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -428,7 +428,9 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_path *path;
+	u64 used = btrfs_block_group_used(&block_group->item);
 	int ret = 0;
+	int matched;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -438,6 +440,15 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				      block_group->key.objectid);
 	btrfs_free_path(path);
 
+	matched = (ctl->free_space == (block_group->key.offset - used -
+				       block_group->bytes_super));
+	if (ret == 1 && !matched) {
+		__btrfs_remove_free_space_cache(ctl);
+		printf("block group %llu has wrong abount of free space",
+		       block_group->key.objectid);
+		ret = -1;
+	}
+
 	if (ret < 0) {
 		ret = 0;
 
-- 
1.8.3.1


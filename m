Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48244 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753100AbeEORhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:37:55 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add parent_transid parameter to veirfy_level_key
Date: Wed, 16 May 2018 01:37:37 +0800
Message-Id: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@parent_transid could tell whether the eb's generation has been verified
by the caller.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/disk-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..b5d55b0ec19b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -416,7 +416,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 
 static int verify_level_key(struct btrfs_fs_info *fs_info,
 			    struct extent_buffer *eb, int level,
-			    struct btrfs_key *first_key)
+			    struct btrfs_key *first_key, u64 parent_transid)
 {
 	int found_level;
 	struct btrfs_key found_key;
@@ -454,10 +454,10 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 	if (ret) {
 		WARN_ON(1);
 		btrfs_err(fs_info,
-"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
+"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu) parent_transid %llu",
 			  eb->start, first_key->objectid, first_key->type,
 			  first_key->offset, found_key.objectid,
-			  found_key.type, found_key.offset);
+			  found_key.type, found_key.offset, parent_transid);
 	}
 #endif
 	return ret;
@@ -493,7 +493,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 						   parent_transid, 0))
 				ret = -EIO;
 			else if (verify_level_key(fs_info, eb, level,
-						  first_key))
+						  first_key, parent_transid))
 				ret = -EUCLEAN;
 			else
 				break;
-- 
1.8.3.1


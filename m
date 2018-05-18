Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48724 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751734AbeERDAN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:13 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: add parent_transid parameter to veirfy_level_key
Date: Fri, 18 May 2018 10:59:35 +0800
Message-Id: <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As verify_level_key() is checked after verify_parent_transid(), i.e.

if (verify_parent_transid())
   ret = -EIO;
else if (verify_level_key())
   ret = -EUCLEAN;

if parent_transid is 0, verify_parent_transid() skips verifying
parent_transid and considers eb as valid, and if verify_level_key()
reports something wrong, we're not going to know if it's caused by
corrupted metadata or non-checkecd eb (e.g. stale eb).

@parent_transid is able to tell whether the eb's generation has been
verified by the caller.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: - more explicit commit log.
    - adjust the position shown in error msg.

 fs/btrfs/disk-io.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..ad865176a3ca 100644
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
@@ -454,10 +454,11 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 	if (ret) {
 		WARN_ON(1);
 		btrfs_err(fs_info,
-"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
-			  eb->start, first_key->objectid, first_key->type,
-			  first_key->offset, found_key.objectid,
-			  found_key.type, found_key.offset);
+"tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
+			  eb->start, parent_transid, first_key->objectid,
+			  first_key->type, first_key->offset,
+			  found_key.objectid, found_key.type,
+			  found_key.offset);
 	}
 #endif
 	return ret;
@@ -493,7 +494,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
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


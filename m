Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39928 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3JaUuq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 16:50:46 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D5ECC7C0444
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 14:50:45 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id frhPvhRKocvNPVfT (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 14:50:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check file extent type before anything else
Date: Thu, 31 Oct 2013 16:50:43 -0400
Message-ID: <1383252643-6429-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit this problem with my no holes patch and it made me realize what the
problem was for bz 60834.  If the first item in the leaf is an inline extent and
we try to read anything starting from disk_bytenr onward we will read off the
end of the leaf.  So we need to check to see what it's type is, and if it's not
REG we can just break out.  This should fix this problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |  1 +
 fs/btrfs/send.c    | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3775947..b763f10 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1051,6 +1051,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
+		ulist_free(*leafs);
 		return ret;
 	}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 8af536f..629cb9e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3943,16 +3943,16 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 	while (key.offset < ekey->offset + left_len) {
 		ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 		right_type = btrfs_file_extent_type(eb, ei);
-		right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
-		right_len = btrfs_file_extent_num_bytes(eb, ei);
-		right_offset = btrfs_file_extent_offset(eb, ei);
-		right_gen = btrfs_file_extent_generation(eb, ei);
-
 		if (right_type != BTRFS_FILE_EXTENT_REG) {
 			ret = 0;
 			goto out;
 		}
 
+		right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
+		right_len = btrfs_file_extent_num_bytes(eb, ei);
+		right_offset = btrfs_file_extent_offset(eb, ei);
+		right_gen = btrfs_file_extent_generation(eb, ei);
+
 		/*
 		 * Are we at extent 8? If yes, we know the extent is changed.
 		 * This may only happen on the first iteration.
-- 
1.8.3.1


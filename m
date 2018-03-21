Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbeCUHDp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 03:03:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E2A86AEB2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 07:03:43 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.com
Cc: wqu@suse.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove obsolete function declaration
Date: Wed, 21 Mar 2018 09:03:41 +0200
Message-Id: <1521615821-17703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function was removed in 24bc2843edd5 ("btrfs:
Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
remains is a defunct declaration. Remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
David, 

This is a fixlet to the aforementioned patch which is only in your misc-next, 
I'd suggest just squash this fixlet into the original one. 

 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fbe51edb9cac..03be51d77357 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2801,7 +2801,6 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range);
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
-int __get_raid_index(u64 flags);
 int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
 void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
 void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
-- 
2.7.4


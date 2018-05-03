Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbeECHVR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 03:21:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2B41AF14
        for <linux-btrfs@vger.kernel.org>; Thu,  3 May 2018 07:21:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid missing extent
Date: Thu,  3 May 2018 15:20:52 +0800
Message-Id: <20180503072052.22002-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing qgroup rescan using the following script (modified from
btrfs/017 test case), we can sometimes hit qgroup corruption.

------
umount $dev &> /dev/null
umount $mnt &> /dev/null

mkfs.btrfs -f -n 64k $dev
mount $dev $mnt

extent_size=8192

xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
btrfs subvolume snapshot $mnt $mnt/snap

xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
btrfs quota enable $mnt

 # -W is the new option to only wait rescan while not starting new one
btrfs quota rescan -W $mnt
btrfs qgroup show -prce $mnt

 # Need to patch btrfs-progs to report qgroup mismatch as error
btrfs check $dev || _fail
------

For fast machine, we can hit some corruption which missed accounting
tree blocks:
------
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5           8.00KiB        0.00B         none         none ---     ---
0/257         8.00KiB        0.00B         none         none ---     ---
------

This is due to the fact that we're always searching commit root for
btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is
from current transaction, not commit root.

And if our tree blocks get modified in current transaction, we won't
find any owner in commit root, thus causing the corruption.

Fix it by searching commit root for extent tree for
qgroup_rescan_leaf().

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---

Please keep in mind that it is possible to hit another type of race
which double accounting tree blocks:
------
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          136.00KiB     128.00KiB         none         none ---     ---
0/257        136.00KiB     128.00KiB         none         none ---     ---
------
For this type of corruption, this patch could reduce the possibility,
but the root cause is race between transaction commit and qgroup rescan,
which needs to be addressed in another patch.
---
 fs/btrfs/qgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4baa4ba2d630..829e8fe5c97e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2681,6 +2681,11 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	path = btrfs_alloc_path();
 	if (!path)
 		goto out;
+	/*
+	 * Rescan should only search for commit root, and any later difference
+	 * should be recorded by qgroup
+	 */
+	path->search_commit_root = 1;
 
 	err = 0;
 	while (!err && !btrfs_fs_closing(fs_info)) {
-- 
2.17.0


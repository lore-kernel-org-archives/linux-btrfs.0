Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728408AbeHIJch (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 05:32:37 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6ED4AE88
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 07:09:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: qgroup: Dirty all qgroups before rescan
Date: Thu,  9 Aug 2018 15:08:57 +0800
Message-Id: <20180809070857.7456-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
In the following case, rescan won't zero out the number of qgroup 1/0:
------
$ mkfs.btrfs -fq $DEV
$ mount $DEV /mnt

$ btrfs quota enable /mnt
$ btrfs qgroup create 1/0 /mnt
$ btrfs sub create /mnt/sub
$ btrfs qgroup assign 0/257 1/0 /mnt

$ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
$ btrfs sub snap /mnt/sub /mnt/snap
$ btrfs quota rescan -w /mnt
$ btrfs qgroup show -pcre /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/257      1016.00KiB     16.00KiB         none         none 1/0     ---
0/258      1016.00KiB     16.00KiB         none         none ---     ---
1/0        1016.00KiB     16.00KiB         none         none ---     0/257

so far so good, but:

$ btrfs qgroup remove 0/257 1/0 /mnt
WARNING: quotas may be inconsistent, rescan needed
$ btrfs quota rescan -w /mnt
$ btrfs qgroup show -pcre  /mnt
qgoupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/257      1016.00KiB     16.00KiB         none         none ---     ---
0/258      1016.00KiB     16.00KiB         none         none ---     ---
1/0        1016.00KiB     16.00KiB         none         none ---     ---
           ^^^^^^^^^^     ^^^^^^^^ not cleared
------

[CAUSE]
Before rescan we call qgroup_rescan_zero_tracking() to zero out all
qgroups' accounting numbers.

However we don't mark all qgroups dirty, but rely on rescan to mark
qgroups dirty.

If we have any high level qgroup but without any child (orphan group), it
won't be marked dirty during rescan, since we can not reach that qgroup.

This will cause QGROUP_INFO items of orphan qgroups never get updated in
quota tree, thus their numbers will stay the same in "btrfs qgroup show"
output.

[FIX]
Just mark all qgroups dirty in qgroup_rescan_zero_tracking(), so even we
have orphan qgroups their QGROUP_INFO items will still get updated during
rescan.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Fix some grammar errors in commit message.
---
 fs/btrfs/qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48c1c3e7baf3..5a5372b33d96 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2864,6 +2864,7 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
 		qgroup->rfer_cmpr = 0;
 		qgroup->excl = 0;
 		qgroup->excl_cmpr = 0;
+		qgroup_dirty(fs_info, qgroup);
 	}
 	spin_unlock(&fs_info->qgroup_lock);
 }
-- 
2.18.0


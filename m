Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbeHCHpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:45:16 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4440AF76
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 05:50:36 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs-progs: rescue-super: Don't double free fs_devices
Date: Fri,  3 Aug 2018 13:50:22 +0800
Message-Id: <20180803055022.9816-7-wqu@suse.com>
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>
References: <20180803055022.9816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
During fuzz/007 we hit the following error:
------
====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs rescue super-recover -y -v /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-200409.raw.restored.scratch
ERROR: tree_root block unaligned: 33554431
ERROR: superblock checksum matches but it has invalid members
ERROR: tree_root block unaligned: 33554431
ERROR: superblock checksum matches but it has invalid members
ERROR: tree_root block unaligned: 33554431
ERROR: superblock checksum matches but it has invalid members
ERROR: failed to add chunk map start=12582912 len=8454144: -17 (File exists)
Couldn't read chunk tree
failed (ignored, ret=139): /home/adam/btrfs/btrfs-progs/btrfs rescue super-recover -y -v /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-200409.raw.restored.scratch
mayfail: returned code 139 (SEGFAULT), not ignored
test failed for case 007-simple-super-recover
------

[CAUSE]
In __open_ctree_fd(), if we have valid @open_ctree_flags and
btrfs_scan_fs_devices() successes without problem, no matter what
happens we will call btrfs_close_devices(), thus free all related
devices.

In super-recover, before we call open_ctree(), we have called
btrfs_scan_fs_devices() already, so btrfs_scan_fs_devices() should not
fail in open_ctree(), fs_devices will always be freed in open_ctree() or
close_ctree().

[FIX]
So in super-recover.c, we should not call btrfs_close_devices(), or we
will find fs_devices->list get poisoned, and trigger segfault when
exiting.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 super-recover.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/super-recover.c b/super-recover.c
index 880fd7712546..86b3df9867dc 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -292,9 +292,6 @@ int btrfs_recover_superblocks(const char *dname,
 no_recover:
 	recover_err_str(ret);
 	free_recover_superblock(&recover);
-	/* check if we have freed fs_devices in close_ctree() */
-	if (!root)
-		btrfs_close_devices(recover.fs_devices);
 	return ret;
 }
 
-- 
2.18.0


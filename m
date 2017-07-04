Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752051AbdGDLtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Jul 2017 07:49:16 -0400
From: Aleksa Sarai <asarai@suse.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <asarai@suse.de>, stable@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: resume qgroup rescan on rw remount
Date: Tue,  4 Jul 2017 21:49:06 +1000
Message-Id: <20170704114906.8419-1-asarai@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several distributions mount the "proper root" as ro during initrd and
then remount it as rw before pivot_root(2). Thus, if a rescan had been
aborted by a previous shutdown, the rescan would never be resumed.

This issue would manifest itself as several btrfs ioctl(2)s causing the
entire machine to hang when btrfs_qgroup_wait_for_completion was hit
(due to the fs_info->qgroup_rescan_running flag being set but the rescan
itself not being resumed). Notably, Docker's btrfs storage driver makes
regular use of BTRFS_QUOTA_CTL_DISABLE and BTRFS_IOC_QUOTA_RESCAN_WAIT
(causing this problem to be manifested on boot for some machines).

Cc: <stable@vger.kernel.org> # v3.11+
Cc: Jeff Mahoney <jeffm@suse.com>
Fixes: b382a324b60f ("Btrfs: fix qgroup rescan resume on mount")
Signed-off-by: Aleksa Sarai <asarai@suse.de>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6346876c97ea..ff6690389343 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1821,6 +1821,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
+		btrfs_qgroup_rescan_resume(fs_info);
+
 		if (!fs_info->uuid_root) {
 			btrfs_info(fs_info, "creating UUID tree");
 			ret = btrfs_create_uuid_tree(fs_info);
-- 
2.13.2


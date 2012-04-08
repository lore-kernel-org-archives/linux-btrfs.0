From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Revert "Btrfs: increase the global block reserve estimates"
Date: Mon,  9 Apr 2012 01:40:51 +0200
Message-ID: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf.

We had numerous reports of premature ENOSPC that were bisected to this
patch. Reverting will not break things but a warning in 'use_block_rsv'
may show up in the syslog.

There's no alternative fix in sight and the ENOSPC problem affects all
3.3 btrfs users during normal filesystem use.

CC: stable@vger.kernel.org
CC: Liu Bo <liubo2009@cn.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..ace5e8c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4205,7 +4205,7 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	num_bytes += div64_u64(data_used + meta_used, 50);
 
 	if (num_bytes * 3 > meta_used)
-		num_bytes = div64_u64(meta_used, 3) * 2;
+		num_bytes = div64_u64(meta_used, 3);
 
 	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
 }
-- 
1.7.9


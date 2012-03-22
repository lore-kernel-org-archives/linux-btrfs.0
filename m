From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 35/35] btrfs: disallow unequal data/metadata blocksize for mixed block groups
Date: Wed, 21 Mar 2012 21:11:39 -0400
Message-ID: <20120322011137.923792033@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With support for bigger metadata blocks, we must avoid mounting a
filesystem with different block size for mixed block groups, this causes
corruption (found by xfstests/083).

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 38c2ee1..55272b0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2302,6 +2302,14 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
+	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
+			(leafsize != nodesize && sectorsize != nodesize)) {
+		printk(KERN_WARNING "btrfs: unequal leaf/node/sector sizes "
+				"are not allowed for mixed block groups on %s\n",
+				sb->s_id);
+		goto fail_sb_buffer;
+	}
+
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
-- 
1.7.9




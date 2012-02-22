From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] Btrfs: silence a compiler warning
Date: Wed, 22 Feb 2012 10:30:55 +0300
Message-ID: <20120222073055.GB7389@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gcc warns that "ret" can be used uninitialized.  It can't actually be
used uninitialized because btrfs_num_copies() always returns 1 or more.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 064b29b..c053e90 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -643,7 +643,7 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(
 static int btrfsic_process_superblock(struct btrfsic_state *state,
 				      struct btrfs_fs_devices *fs_devices)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_super_block *selected_super;
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752022AbdCKXDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Mar 2017 18:03:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79D70AAB2
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Mar 2017 23:03:39 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] qgroup: Change qgroup_meta_rsv to 64bit
Date: Sat, 11 Mar 2017 17:03:26 -0600
Message-Id: <20170311230326.12308-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Using an int value is causing qg->reserved range checks to be triggered,
and incorrect accounting.

This affects exclusive qgroups only.

TEST CASE:

DEVICE=/dev/vdb
MOUNTPOINT=/mnt
SUBVOL=$MOUNTPOINT/tmp

umount $SUBVOL
umount $MOUNTPOINT

mkfs.btrfs -f $DEVICE
mount /dev/vdb $MOUNTPOINT
btrfs quota enable $MOUNTPOINT
btrfs subvol create $SUBVOL
umount $MOUNTPOINT
mount /dev/vdb $MOUNTPOINT
mount -o subvol=tmp $DEVICE $SUBVOL
btrfs qgroup limit -e 3G $SUBVOL

btrfs quota rescan /mnt -w

for i in `seq 1 44000`; do
  dd if=/dev/zero of=/mnt/tmp/test_$i bs=10k count=1
  if [[ $? > 0 ]]; then
     btrfs qgroup show -pcref $SUBVOL
     exit 1
  fi
done

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h  |  2 +-
 fs/btrfs/qgroup.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc2..c411590 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1259,7 +1259,7 @@ struct btrfs_root {
 	atomic_t will_be_snapshoted;
 
 	/* For qgroup metadata space reserve */
-	atomic_t qgroup_meta_rsv;
+	atomic64_t qgroup_meta_rsv;
 };
 static inline u32 btrfs_inode_sectorsize(const struct inode *inode)
 {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6215264..130c0da 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2963,20 +2963,20 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 	ret = qgroup_reserve(root, num_bytes, enforce);
 	if (ret < 0)
 		return ret;
-	atomic_add(num_bytes, &root->qgroup_meta_rsv);
+	atomic64_add(num_bytes, &root->qgroup_meta_rsv);
 	return ret;
 }
 
 void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	int reserved;
+	long reserved;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
 	    !is_fstree(root->objectid))
 		return;
 
-	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
+	reserved = atomic64_xchg(&root->qgroup_meta_rsv, 0);
 	if (reserved == 0)
 		return;
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
@@ -2991,8 +2991,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 		return;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
-	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
+	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
+	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
 }
 
-- 
2.10.2


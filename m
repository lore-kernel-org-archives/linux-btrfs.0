Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40894 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754694AbdCGGXJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 01:23:09 -0500
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Tue,  7 Mar 2017 06:42:51 +0100
Message-Id: <20170307054251.4361-1-kilobyte@angband.pl>
Subject: [PATCH] btrfs: fix a bogus warning when converting only data or metadata
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If your filesystem has, eg, data:raid0 metadata:raid1, and you run "btrfs
balance -dconvert=raid1", the meta.target field will be uninitialized.
That's otherwise ok, as it's unused except for this warning.

Thus, let's use the existing set of raid levels for the comparison.

As a side effect, non-convert balances will now nag about data>metadata.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
To reproduce:
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
mkfs.btrfs ra rb     # defaults to -draid0 -mraid1
losetup -f ra
losetup -f rb
mount /dev/loop0 /mnt/vol1
btrfs balance start -dconvert=raid1 /mnt/vol1

 fs/btrfs/volumes.c | 5 +++++
 1 file changed, 5 insertions(+)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3645af2749f8..c016db81ba43 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3846,6 +3846,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
+	/* if we're not converting, the target field is uninitialized */
+	if (!(bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT))
+		bctl->meta.target = fs_info->avail_metadata_alloc_bits;
+	if (!(bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT))
+		bctl->data.target = fs_info->avail_data_alloc_bits;
 	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
 		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
 		btrfs_warn(fs_info,
-- 
2.11.0


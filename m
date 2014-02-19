Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56526 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBSQKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 11:10:44 -0500
Received: by mail-ie0-f175.google.com with SMTP id at1so373691iec.34
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 08:10:44 -0800 (PST)
Received: from [10.0.1.18] (user-0cdvcvs.cable.mindspring.com. [24.223.179.252])
        by mx.google.com with ESMTPSA id y9sm28916634igl.7.2014.02.19.08.10.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 19 Feb 2014 08:10:42 -0800 (PST)
Message-ID: <5304D781.6020309@gmail.com>
Date: Wed, 19 Feb 2014 11:10:41 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Allow forced conversion of metadata to dup profile
 on multiple devices
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrfs balance start fails when trying to convert metadata or
system chunks to dup profile on filesystems with multiple devices.  This
requires that a conversion from a multi-device filesystem to a single
device filesystem use the following methodology:
    1. btrfs balance start -dconvert=single -mconvert=single \
       -sconvert=single -f /
    2. btrfs device delete / /dev/sdx
    3. btrfs balance start -mconvert=dup -sconvert=dup /
This results in a period of time (possibly very long if the devices are
big) where you don't have the protection guarantees of multiple copies
of metadata chunks.

After applying this patch, one can instead use the following methodology
for conversion from a multi-device filesystem to a single device
filesystem:
    1. btrfs balance start -dconvert=single -mconvert=dup \
       -sconvert=dup -f /
    2. btrfs device delete / /dev/sdx
This greatly reduces the chances of the operation causing data loss due
to a read error during the device delete.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
 fs/btrfs/volumes.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 07629e9..38a9522 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3152,10 +3152,8 @@ int btrfs_balance(struct btrfs_balance_control
*bctl,
 		num_devices--;
 	}
 	btrfs_dev_replace_unlock(&fs_info->dev_replace);
-	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-	if (num_devices == 1)
-		allowed |= BTRFS_BLOCK_GROUP_DUP;
-	else if (num_devices > 1)
+	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
+	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
 	if (num_devices > 2)
 		allowed |= BTRFS_BLOCK_GROUP_RAID5;
@@ -3221,6 +3219,21 @@ int btrfs_balance(struct btrfs_balance_control
*bctl,
 				goto out;
 			}
 		}
+		if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		    (bctl->sys.target & ~BTRFS_BLOCK_GROUP_DUP) ||
+		    (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		    (bctl->meta.target & ~BTRFS_BLOCK_GROUP_DUP)) &&
+		    (num_devs > 1)) {
+			if (bctl->flags & BTRFS_BALANCE_FORCE) {
+				btrfs_info(fs_info, "force conversion of metadata "
+					   "to dup profile on multiple devices");
+			} else {
+				btrfs_err(fs_info, "balance will reduce metadata "
+					  "integrity, use force if you want this");
+				ret = -EINVAL;
+				goto out;
+			}
+		}
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
  	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-- 
1.8.5.4


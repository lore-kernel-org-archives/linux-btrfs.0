From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: [PATCH] Btrfs: Don't error on resizing FS to same size
Date: Thu, 17 Nov 2011 21:04:34 +0000
Message-ID: <20111117210433.GA1817@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It seems overly harsh to fail a resize of a btrfs file system to the
same size when a shrink or grow would succeed.  User app GParted trips
over this error.  Allow it by bypassing the shrink or grow operation.

Signed-off-by: Mike Fleetwood <mike.fleetwood@googlemail.com>
---

Example failed resize:
    # strace -e trace=ioctl btrfs filesystem resize max /mnt/0
    Resize '/mnt/0' of 'max'
    ioctl(3, 0x50009403, 0xbfa5029c)        = -1 EINVAL (Invalid argument)
    ERROR: unable to resize '/mnt/0' - Invalid argument
    # echo $?
    30
    # dmesg | tail -1
    [426094.235018] new size for /dev/loop1 is 1073741824

---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dae5dfe..00b7024 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1251,7 +1251,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
-	} else {
+	} else if (new_size > old_size) {
 		ret = btrfs_shrink_device(device, new_size);
 	}
 
-- 
1.7.4.4


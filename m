From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: reverse enough space for file clone
Date: Fri, 29 Jul 2011 13:38:38 +0800
Message-ID: <4E32475E.2080404@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  # mount -t btrfs /dev/sda7 /mnt
  # dd if=/dev/zero of=/mnt/src bs=10K count=1
  # sync
  # clone 4K from /mnt/src to /mnt/dst

kernel BUG at fs/btrfs/delayed-inode.c:1693!

We should reverse space for both file extent item insertion and
inode update.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b980af..05af14c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2314,7 +2314,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			else
 				new_key.offset = destoff;
 
-			trans = btrfs_start_transaction(root, 1);
+			trans = btrfs_start_transaction(root, 2);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
-- 
1.7.3.1


From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs: fix defragmentation regression
Date: Fri, 02 Sep 2011 15:56:25 +0800
Message-ID: <4E608C29.10307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There's an off-by-one bug:

  # create a file with lots of 4K file extents
  # btrfs fi defrag /mnt/file
  # sync
  # filefrag -v /mnt/file
  Filesystem type is: 9123683e
  File size of /mnt/file is 1228800 (300 blocks, blocksize 4096)
   ext logical physical expected length flags
     0       0     3372              64
     1      64     3136     3435      1
     2      65     3436     3136     64
     3     129     3201     3499      1
     4     130     3500     3201     64
     5     194     3266     3563      1
     6     195     3564     3266     64
     7     259     3331     3627      1
     8     260     3628     3331     40 eof

After this patch:

  ...
  # filefrag -v /mnt/file
  Filesystem type is: 9123683e
  File size of /mnt/file is 1228800 (300 blocks, blocksize 4096)
   ext logical physical expected length flags
     0       0     3372             300 eof
  /mnt/file: 1 extent found

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..31fe6d4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1081,7 +1081,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		defrag_count += ret;
 		balance_dirty_pages_ratelimited_nr(inode->i_mapping, ret);
-		i += ret;
 
 		if (newer_than) {
 			if (newer_off == (u64)-1)
@@ -1101,7 +1100,10 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 				break;
 			}
 		} else {
-			i++;
+			if (ret > 0)
+				i += ret;
+			else
+				i++;
 		}
 	}
 
-- 
1.7.3.1

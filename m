From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Set file size correctly in file clone
Date: Fri, 19 Nov 2010 09:36:34 +0800
Message-ID: <4CE5D4A2.2050205@cn.fujitsu.com>
References: <4CE5D48A.6090009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sage@newdream.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE5D48A.6090009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Set src_offset = 0, src_length = 20K, dest_offset = 20K. And the
original filesize of the dest file 'file2' is 30K:

  # ls -l /mnt/file2
  -rw-r--r-- 1 root root 30720 Nov 18 16:42 /mnt/file2

Now clone file1 to file2, the dest file should be 40K, but it
still shows 30K:

  # ls -l /mnt/file2
  -rw-r--r-- 1 root root 30720 Nov 18 16:42 /mnt/file2

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 81b47bd..6b4bfa7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1873,8 +1873,8 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			 * but shouldn't round up the file size
 			 */
 			endoff = new_key.offset + datal;
-			if (endoff > off+olen)
-				endoff = off+olen;
+			if (endoff > destoff+olen)
+				endoff = destoff+olen;
 			if (endoff > inode->i_size)
 				btrfs_i_size_write(inode, endoff);
 
-- 
1.6.3


From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Check if dest_offset is block-size aligned before
 cloning file
Date: Fri, 19 Nov 2010 09:36:10 +0800
Message-ID: <4CE5D48A.6090009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sage@newdream.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've done the check for src_offset and src_length, and We should
also check dest_offset, otherwise we'll corrupt the destination
file:

  (After cloning file1 to file2 with unaligned dest_offset)
  # cat /mnt/file2
  cat: /mnt/file2: Input/output error

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 463d91b..81b47bd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1669,12 +1669,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		olen = len = src->i_size - off;
 	/* if we extend to eof, continue to block boundary */
 	if (off + len == src->i_size)
-		len = ((src->i_size + bs-1) & ~(bs-1))
-			- off;
+		len = ALIGN(src->i_size, bs) - off;
 
 	/* verify the end result is block aligned */
-	if ((off & (bs-1)) ||
-	    ((off + len) & (bs-1)))
+	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
+	    !IS_ALIGNED(destoff, bs))
 		goto out_unlock;
 
 	/* do any pending delalloc/csum calc on src, one way or
-- 
1.6.3


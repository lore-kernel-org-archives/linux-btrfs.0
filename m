From: Jeff Liu <jeff.liu@oracle.com>
Subject: don't fetch the inode size beforehand.
Date: Fri, 26 Aug 2011 21:32:45 +0800
Message-ID: <4E57A07D.7090306@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I think we don't need to fetch the inode size in advance. :-P.

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..f8ad957 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1698,7 +1698,7 @@ static int find_desired_extent(struct inode 
*inode, loff_t *offset, int origin)
      u64 lockend = i_size_read(inode);
      u64 start = *offset;
      u64 orig_start = *offset;
-    u64 len = i_size_read(inode);
+    u64 len;
      u64 last_end = 0;
      int ret = 0;


Thanks,
-Jeff

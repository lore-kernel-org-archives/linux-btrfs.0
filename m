From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix recursive auto-defrag
Date: Thu, 06 Oct 2011 11:39:54 +0800
Message-ID: <4E8D230A.4040801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Follow those steps:

  # mount -o autodefrag /dev/sda7 /mnt
  # dd if=/dev/urandom of=/mnt/tmp bs=200K count=1
  # sync
  # dd if=/dev/urandom of=/mnt/tmp bs=8K count=1 conv=notrunc

and then it'll go into a loop: writeback -> defrag -> writeback ...

It's because writeback writes [8K, 200K] and then writes [0, 8K].

I tried to make writeback know if the pages are dirtied by defrag,
but the patch was a bit intrusive. Here I simply set writeback_index
when we defrag a file.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..7a10f94 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1047,6 +1047,13 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	if (!max_to_defrag)
 		max_to_defrag = last_index - 1;
 
+	/*
+	 * make writeback starts from i, so the defrag range can be
+	 * written sequentially.
+	 */
+	if (i < inode->i_mapping->writeback_index)
+		inode->i_mapping->writeback_index = i;
+
 	while (i <= last_index && defrag_count < max_to_defrag) {
 		/*
 		 * make sure we stop running if someone unmounts
-- 1.7.3.1 

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/4] Btrfs: fix wrong max_to_defrag in btrfs_defrag_file()
Date: Fri, 02 Sep 2011 15:56:55 +0800
Message-ID: <4E608C47.6060308@cn.fujitsu.com>
References: <4E608C29.10307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E608C29.10307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

It's off-by-one, and thus we may skip the last page while defragmenting.

An example case:

  # create /mnt/file with 2 4K file extents
  # btrfs fi defrag /mnt/file
  # sync
  # filefrag /mnt/file
  /mnt/file: 2 extents found

So it's not defragmented.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6f2b257..57aa5b7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1046,7 +1046,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		i = range->start >> PAGE_CACHE_SHIFT;
 	}
 	if (!max_to_defrag)
-		max_to_defrag = last_index - 1;
+		max_to_defrag = last_index;
 
 	while (i <= last_index && defrag_count < max_to_defrag) {
 		/*
-- 
1.7.3.1

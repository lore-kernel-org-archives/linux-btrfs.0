From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 12/12] Btrfs: Fix file clone when source offset is not 0
Date: Thu, 27 Jan 2011 16:46:12 +0800
Message-ID: <4D4130D4.2000001@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Suppose:
- the source extent is: [0, 100]
- the src offset is 10
- the clone length is 90
- the dest offset is 0

This statement:

	new_key.offset = key.offset + destoff - off

will produce such an extent for the dest file:

	[ino, BTRFS_EXTENT_DATA_KEY, -10]

, which is obviously wrong.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f87552a..1b61dab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.objectid = inode->i_ino;
-			new_key.offset = key.offset + destoff - off;
+			if (off <= key.offset)
+				new_key.offset = key.offset + destoff - off;
+			else
+				new_key.offset = destoff;
 
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
-- 
1.6.3

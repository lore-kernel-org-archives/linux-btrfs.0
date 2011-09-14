From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: don't change inode flag of the dest clone file
Date: Wed, 14 Sep 2011 13:25:36 +0800
Message-ID: <4E703AD0.2060202@cn.fujitsu.com>
References: <4E703AC1.5060205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E703AC1.5060205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The dst file will have the same inode flags with dst file after
file clone, and I think it's unexpected.

For example, the dst file will suddenly become immutable after
getting some share of data with src file, if the src is immutable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dc82bbb..a401514 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2434,7 +2434,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			if (endoff > inode->i_size)
 				btrfs_i_size_write(inode, endoff);
 
-			BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
 			ret = btrfs_update_inode(trans, root, inode);
 			BUG_ON(ret);
 			btrfs_end_transaction(trans, root);
-- 1.7.3.1 

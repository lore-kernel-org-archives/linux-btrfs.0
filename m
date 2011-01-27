From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 08/12] Btrfs: Fix memory leak on finding existing super
Date: Thu, 27 Jan 2011 16:44:54 +0800
Message-ID: <4D413086.10109@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Ian Kent <raven@themaw.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ian Kent <raven@themaw.net>

We missed a memory deallocation in commit 450ba0ea.

If an existing super block is found at mount and there is no
error condition then the pre-allocated tree_root and fs_info
are no not used and are not freeded.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61bd79a..f50253c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -654,6 +654,8 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		}
 
 		btrfs_close_devices(fs_devices);
+		kfree(fs_info);
+		kfree(tree_root);
 	} else {
 		char b[BDEVNAME_SIZE];
 
-- 
1.6.3

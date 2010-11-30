From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] btrfs - fix memory leak on finding existing super
Date: Tue, 30 Nov 2010 21:31:03 +0800
Message-ID: <20101130133103.4661.35881.stgit@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ian Kent <raven@themaw.net>

We missed a memory deallocation in commit 450ba0ea.

If an existing super block is found at mount and there is no
error condition then the pre-allocated tree_root and fs_info
are no not used and are not freeded.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 47bf67c..f5cca1b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -654,6 +654,8 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		}
 
 		btrfs_close_devices(fs_devices);
+		kfree(fs_info);
+		kfree(tree_root);
 	} else {
 		char b[BDEVNAME_SIZE];
 


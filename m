From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 1/3] Btrfs: actually call btrfs_init_lockdep
Date: Tue, 27 Mar 2012 16:11:58 +0200
Message-ID: <e565d4b962948e70f37f417603caf131a773621b.1332852833.git.list.btrfs@jan-o-sch.net>
References: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_lockdep only makes our lockdep class names look prettier, thus
it did never hurt we forgot to actually call it. This turns our lockdep
identifier strings from lockdep auto-set #[id] into really pretty
"btrfs-fs-01" or "btrfs-csum-03".

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61717a4..5239003 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1404,6 +1404,8 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto unregister_ioctl;
 
+	btrfs_init_lockdep();
+
 	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
 	return 0;
 
-- 
1.7.3.4


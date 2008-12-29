From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not call kfree if kmalloc failed in btrfs_sysfs_add_super
Date: Mon, 29 Dec 2008 11:44:23 +0800
Message-ID: <49584797.6010402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

kfree should not be called if kmalloc is not success.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 300076e..04087c0 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -212,14 +212,13 @@ int btrfs_sysfs_add_super(struct btrfs_fs_info *fs)
 	fs->super_kobj.kset = btrfs_kset;
 	error = kobject_init_and_add(&fs->super_kobj, &btrfs_super_ktype,
 				     NULL, "%s", name);
+	kfree(name);
 	if (error)
 		goto fail;
 
-	kfree(name);
 	return 0;
 
 fail:
-	kfree(name);
 	printk(KERN_ERR "btrfs: sysfs creation for super failed\n");
 	return error;
 }
-- 
1.6.0.6



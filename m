Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34214 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3KSQII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 11:08:08 -0500
Received: by mail-wi0-f181.google.com with SMTP id f4so5690388wiw.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 08:08:07 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing sysfs group remove / fix leak
Date: Tue, 19 Nov 2013 16:07:47 +0000
Message-Id: <1384877267-32046-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From kmemleak:

  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f5f6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f284>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219281>] sysfs_new_dirent+0x51/0x130
    [<ffffffff812196d2>] create_dir+0x42/0xd0
    [<ffffffff812199ff>] sysfs_create_subdir+0x1f/0x30
    [<ffffffff8121b50e>] internal_create_group+0x5e/0x270
    [<ffffffff8121b753>] sysfs_create_group+0x13/0x20
    [<ffffffffa069c99e>] btrfs_sysfs_add_one+0x7e/0x280 [btrfs]
    [<ffffffffa0682792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa065883a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ad3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa56>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d77>] do_mount+0x237/0xa70
    [<ffffffff811c2640>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8804e37d45b8 (size 160):

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 669fdf7..9576771 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -424,6 +424,8 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	kobject_put(fs_info->device_dir_kobj);
 	kobject_del(fs_info->space_info_kobj);
 	kobject_put(fs_info->space_info_kobj);
+	sysfs_remove_group(&fs_info->super_kobj,
+			   &btrfs_feature_attr_group);
 	kobject_del(&fs_info->super_kobj);
 	kobject_put(&fs_info->super_kobj);
 	wait_for_completion(&fs_info->kobj_unregister);
-- 
1.7.9.5


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63048 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaGEDSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 23:18:11 -0400
Received: by mail-ig0-f174.google.com with SMTP id l13so9211620iga.13
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 20:18:11 -0700 (PDT)
Received: from [192.168.1.2] ([216.26.106.6])
        by mx.google.com with ESMTPSA id p12sm67814346igx.18.2014.07.04.20.18.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 04 Jul 2014 20:18:10 -0700 (PDT)
Message-ID: <53B76E71.3010709@gmail.com>
Date: Fri, 04 Jul 2014 22:18:09 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Remove unused parameter "name" from btrfs_qgroup_create
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

in btrfs_qgruop_create a fourth parameter "name" exists.
however this parameter is not used anywhere in the function
the only other place this function is called is ioctl and the call
passes NULL as the name paremeter which would seem to indicate its
lack of necessity.

Signed-off-by: Kevin Brandstatter <kjbrandstatter@gmail.com>
---
 fs/btrfs/ioctl.c  | 3 +--
 fs/btrfs/qgroup.c | 2 +-
 fs/btrfs/qgroup.h | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2a99f49..4b33d08 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4709,8 +4709,7 @@ static long btrfs_ioctl_qgroup_create(struct file
*file, void __user *arg)
 
     /* FIXME: check if the IDs really exist */
     if (sa->create) {
-        ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
-                      NULL);
+        ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid);
     } else {
         ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
     }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 98cb6b2..3d1c8be 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1091,7 +1091,7 @@ out:
 }
 
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-            struct btrfs_fs_info *fs_info, u64 qgroupid, char *name)
+            struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
     struct btrfs_root *quota_root;
     struct btrfs_qgroup *qgroup;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 5952ff1..31403ca 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -69,8 +69,7 @@ int btrfs_add_qgroup_relation(struct
btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
                   struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-            struct btrfs_fs_info *fs_info, u64 qgroupid,
-            char *name);
+            struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
                   struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
-- 
2.0.1

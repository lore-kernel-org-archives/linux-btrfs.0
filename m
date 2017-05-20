Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37560 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755708AbdETIj6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:39:58 -0400
Received: by mail-it0-f43.google.com with SMTP id g126so58110050ith.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:39:57 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id a137sm4874001ioe.41.2017.05.20.01.39.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:39:56 -0700 (PDT)
Date: Sat, 20 May 2017 08:39:55 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] btrfs: Add code to prevent qgroup creation for a
 non-existent subvol
Message-ID: <20170520083954.GA4253@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

This patch is to prepare for following patches in this patchset. The code
allows you to check if a subvol exists, and to only allow the creation
of qgroups on subvols that already exist. It doesn't make sense to allow
the creation of level 0 qgroups otherwise.

The behaviour is to inherit (create) a qgroup when you create a new
subvol with quota on. If there is an existing qgroup with this same
ID, it will be reset.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ioctl.c  |  2 +-
 fs/btrfs/qgroup.c | 11 ++++++++++-
 fs/btrfs/qgroup.h |  3 ++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2b1a8c1..5e20643 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4972,7 +4972,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
+		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid, 0);
 	} else {
 		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid, 0);
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a0699fd..28e2c7f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1317,10 +1317,19 @@ static int __btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists)
 {
 	int ret;
 
+	if (check_subvol_exists && btrfs_qgroup_level(qgroupid) == 0) {
+		ret = btrfs_subvolume_exists(fs_info, qgroupid);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			return -ENOENT;
+	}
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	ret = __btrfs_create_qgroup(trans, fs_info, qgroupid);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fc08bdb..1afbe40 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -125,7 +125,8 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid);
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid,
 			int check_in_use);
-- 
2.9.3


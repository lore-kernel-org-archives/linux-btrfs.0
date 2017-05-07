Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36822 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdEGWUo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 May 2017 18:20:44 -0400
Received: by mail-wr0-f194.google.com with SMTP id v42so6123230wrc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 May 2017 15:20:43 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?5oi05ZGo?= <tommy0705c@gmail.com>
Date: Mon, 8 May 2017 01:07:42 +0800
Message-ID: <CAFu1FXSTnJfye2dQwXaOMuXs8u8TD66o0DP6PtPZhhyHHvZbkg@mail.gmail.com>
Subject: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really exist"
 in ioctl.c
To: lbtrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really exist"
 in ioctl.c

These comments were already fixed in 2013.
btrfs_add_qgroup_relation, btrfs_ioctl_qgroup_create, btrfs_limit_qgroup
btrfs_add_qgroup_relation, btrfs_del_qgroup_relation have checked
qgroupid existed.

Signed-off-by: Daichou <tommy0705c@gmail.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a29dc3fd7152..6db06f4708f7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4900,7 +4900,6 @@ static long btrfs_ioctl_qgroup_assign(struct
file *file, void __user *arg)
  goto out;
  }

- /* FIXME: check if the IDs really exist */
  if (sa->assign) {
  ret = btrfs_add_qgroup_relation(trans, fs_info,
  sa->src, sa->dst);
@@ -4959,7 +4958,6 @@ static long btrfs_ioctl_qgroup_create(struct
file *file, void __user *arg)
  goto out;
  }

- /* FIXME: check if the IDs really exist */
  if (sa->create) {
  ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
  } else {
@@ -5013,7 +5011,6 @@ static long btrfs_ioctl_qgroup_limit(struct file
*file, void __user *arg)
  qgroupid = root->root_key.objectid;
  }

- /* FIXME: check if the IDs really exist */
  ret = btrfs_limit_qgroup(trans, fs_info, qgroupid, &sa->lim);

  err = btrfs_end_transaction(trans);

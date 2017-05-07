Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36572 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdEGW4A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 May 2017 18:56:00 -0400
Received: by mail-wm0-f65.google.com with SMTP id u65so11819206wmu.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 May 2017 15:56:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFu1FXThtkWSPngPDw7tOBy_tmsb6S8GX5jYfx+F7asO=uKV-w@mail.gmail.com>
References: <CAFu1FXThtkWSPngPDw7tOBy_tmsb6S8GX5jYfx+F7asO=uKV-w@mail.gmail.com>
From: =?UTF-8?B?5oi05ZGo?= <tommy0705c@gmail.com>
Date: Mon, 8 May 2017 00:51:50 +0800
Message-ID: <CAFu1FXQECS2q3gqKv90v0Oq2ZU1PZsOMnEwa3XH7a8ZqV3SE_g@mail.gmail.com>
Subject: Fwd: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really
 exist" in ioctl.c
To: lbtrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: 戴周 <tommy0705c@gmail.com>
Date: Mon, May 8, 2017 at 12:38 AM
Subject: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really
exist" in ioctl.c
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David
Sterba <dsterba@suse.com>


>From 0adb51c1fd6afde399e8f9307bff831b508892d1 Mon Sep 17 00:00:00 2001
From: Daichou <tommy0705c@gmail.com>
Date: Mon, 8 May 2017 00:03:25 +0800
Subject: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really exist"
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
--
2.12.2

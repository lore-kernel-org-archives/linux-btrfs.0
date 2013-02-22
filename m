Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53635 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3BVMC7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 07:02:59 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so368804pbb.41
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 04:02:58 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH 2/2] Btrfs: disable the qgroup level 0 for userspace use
Date: Fri, 22 Feb 2013 20:02:53 +0800
Message-Id: <1361534573-2412-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch tries to stop users to create/destroy qgroup level 0,
users can only create/destroy qgroup level more than 0.

See the fact:
	a subvolume/snapshot qgroup was created automatically
when creating subvolume/snapshot, so creating a qgroup level 0 can't
be a subvolume/snapshot qgroup, the only way to use it is that assigning
subvolume/snapshot qgroup to it, the point is that we don't want to have a
parent qgroup whose level is 0.

	So we want to force users to use qgroup with clear relations
which means a parent qgroup's level > child qgroup's level.For example:

                          2/0
                         /    \
                        /      \
                       /        \
                      1/0       1/1
                    /     \        \
                   /       \        \       
                  /         \        \
            0/256    0/257    0/258

This pattern of quota is nature and easy for users to understand, otherwise it will
make the quota configuration confusing and difficult to maintain.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Acked-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a31cd93..3590c21 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3755,7 +3755,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	if (!sa->qgroupid) {
+	if (!(sa->qgroupid >> 48)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.7.6


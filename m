Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16271 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1767597Ab2KOLfZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 06:35:25 -0500
Message-ID: <50A4D38D.6080107@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 19:35:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs: disable qgroup id 0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qgroup id 0 is a special number, we should set the id of a qgroup to 0.
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8e5b7fa..922a33a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3574,6 +3574,11 @@ static long btrfs_ioctl_qgroup_create(struct btrfs_root *root, void __user *arg)
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
+	if (!sa->qgroupid) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-- 
1.7.11.7

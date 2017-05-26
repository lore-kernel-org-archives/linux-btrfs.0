Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36063 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944933AbdEZUox (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 16:44:53 -0400
Received: by mail-io0-f181.google.com with SMTP id o12so16137346iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 13:44:52 -0700 (PDT)
Date: Fri, 26 May 2017 20:44:50 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: [PATCH v2 3/4] btrfs: Warn the user when the legacy
 btrfs_qgroup_create API is used
Message-ID: <20170526204449.GA18209@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>

This patch adds a warning to let the user know when the legacy
qgroup creation / removal API is in use. Eventually, we can
deprecate this API.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 78c8321..fba409f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5027,6 +5027,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	pr_info_once("btrfs: Usage of deprecated btrfs_qgroup_create ioctl\n");
+
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
-- 
2.9.3


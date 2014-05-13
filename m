Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:36090 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaEMCXh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 22:23:37 -0400
Message-ID: <537181DB.2010400@huawei.com>
Date: Tue, 13 May 2014 10:22:19 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <clm@fb.com>, <jbacik@fb.com>, David Taylor <davidt-btrfs@yadt.co.uk>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: replace simple_strtoul() with kstrtoul()
References: <1399947478-11287-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1399947478-11287-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

use the newer and more pleasant kstrtoul() to replace simple_strtoul(),
because simple_strtoul() is marked for obsoletion.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/btrfs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ad7de9..30bcc47 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1502,11 +1502,12 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	sizestr = vol_args->name;
 	devstr = strchr(sizestr, ':');
 	if (devstr) {
-		char *end;
 		sizestr = devstr + 1;
 		*devstr = '\0';
 		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
+		ret = kstrtoul(devstr, 10, &devid);
+		if (ret)
+			goto out_free;
 		if (!devid) {
 			ret = -EINVAL;
 			goto out_free;
-- 
1.8.1.2


.





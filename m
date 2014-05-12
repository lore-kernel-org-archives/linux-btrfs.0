Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:31361 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaELLBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 07:01:18 -0400
Message-ID: <5370A9ED.9000106@huawei.com>
Date: Mon, 12 May 2014 19:01:01 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <clm@fb.com>, <jbacik@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: replace simple_strtoul() with kstrtoul()
References: <1399892355-3781-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1399892355-3781-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

use the newer and more pleasant kstrtoul() to replace simple_strtoul(),
because simple_strtoul() is marked for obsoletion.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ad7de9..0075b7d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1506,7 +1506,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		sizestr = devstr + 1;
 		*devstr = '\0';
 		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
+		devid = kstrtoul(devstr, &end, 10);
 		if (!devid) {
 			ret = -EINVAL;
 			goto out_free;
-- 
1.8.1.2


.





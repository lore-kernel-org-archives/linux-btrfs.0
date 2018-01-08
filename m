Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3753 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756407AbeAHLqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 06:46:10 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <dsterba@suse.com>, <clm@fb.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <wangxiongfeng2@huawei.com>
Subject: [PATCH] btrfs: use correct string length
Date: Mon, 8 Jan 2018 19:51:22 +0800
Message-ID: <1515412282-57381-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

fs/btrfs/ioctl.c: In function 'btrfs_ioctl':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 1024 equals destination size [-Wstringop-truncation]

We need one less byte or call strlcpy() to make it a nul-terminated
string.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ef8aca..e88c9e8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2807,7 +2807,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 
 		rcu_read_lock();
 		name = rcu_dereference(dev->name);
-		strncpy(di_args->path, name->str, sizeof(di_args->path));
+		strncpy(di_args->path, name->str, sizeof(di_args->path) - 1);
 		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
-- 
1.8.3.1


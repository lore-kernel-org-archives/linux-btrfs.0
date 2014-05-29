Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753880AbaE2BYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 21:24:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4T1OpGc030461
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 09:24:51 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: replace EINVAL with ERANGE for resize when ULLONG_MAX
Date: Thu, 29 May 2014 09:19:58 +0800
Message-ID: <1401326398-13087-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To be accurate about the error case,
if the new size is beyond ULLONG_MAX, return ERANGE instead of EINVAL.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 05f8df8..f8478c3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1562,7 +1562,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		new_size = old_size - new_size;
 	} else if (mod > 0) {
 		if (new_size > ULLONG_MAX - old_size) {
-			ret = -EINVAL;
+			ret = -ERANGE;
 			goto out_free;
 		}
 		new_size = old_size + new_size;
-- 
1.8.1.4


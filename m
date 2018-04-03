Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35113 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755164AbeDCIeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Apr 2018 04:34:21 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <fstests@vger.kernel.org>
Subject: [PATCH] btrfs-progs: let mkfs return nozero value on thin provision device
Date: Tue, 3 Apr 2018 16:39:45 +0800
Message-ID: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when mkfs.btrfs on a thin provision device which has very small
backing size and big virtual size, all code works well in
mkfs.btrfs until close_ctree() is called.
close_ctree() fails to sync device due to small backing size
while closing devices.
However, mkfs returns 0 in such situation which causes failure of
xfstests generic/405.

So, let mkfs returns nonzero value if previous steps succeeded but
close_ctree() failed.
Then xfstests generic/405 passes now.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 mkfs/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 5a717f701cd5..9f7f2396df8f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1285,6 +1285,12 @@ out:
 		}
 	}
 
+	if (!ret && close_ret) {
+		ret = close_ret;
+		error("failed to close ctree, the filesystem may be inconsistent: %d",
+		      ret);
+	}
+
 	btrfs_close_all_devices();
 	free(label);
 
-- 
2.16.3




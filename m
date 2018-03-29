Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1658 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750753AbeC2JVq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 05:21:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 38A2348AE772
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:21:43 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Do not add extra slash if given path end with it
Date: Thu, 29 Mar 2018 17:11:19 +0800
Message-ID: <1522314679-762-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When use a given path end with a slash like below,
the output of path will have double slash.

Do not add extra slash if there is already one in the given
path.

$ btrfs filesystem du ./test/
output:
Total   Exclusive  Set shared  Filename
0.00B       0.00B           -  /home/gujx/device/tmp/test//foo

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-fi-du.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 8a44665c..74f57320 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -449,7 +449,7 @@ static int du_add_file(const char *filename, int dirfd,
 	}
 
 	pathtmp = pathp;
-	if (pathp == path)
+	if (pathp == path || *(pathp-1) == '/')
 		ret = sprintf(pathp, "%s", filename);
 	else
 		ret = sprintf(pathp, "/%s", filename);
-- 
2.14.3




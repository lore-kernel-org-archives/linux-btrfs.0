Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52558 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726442AbeILMml (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 08:42:41 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 42D974B69E01
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 15:39:22 +0800 (CST)
From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: change filename limit to 255 when creating subvolume
Date: Wed, 12 Sep 2018 15:39:03 +0800
Message-ID: <20180912073903.10134-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify the file name length limit to meet the Linux naming convention. 
In addition, the file name length is always bigger than 0, no need to 
compare with 0 again.

Issue: #145
Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7a884af..fe97fca3 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -715,7 +715,7 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 	}
 
 	len = strlen(newname);
-	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
+	if (len > BTRFS_VOL_NAME_MAX) {
 		error("snapshot name too long '%s'", newname);
 		goto out;
 	}
-- 
2.18.0

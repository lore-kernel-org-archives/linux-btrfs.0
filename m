Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48803 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725859AbeIRGsU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 02:48:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 054194B41ED3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 09:18:16 +0800 (CST)
From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: change filename limit to 255 when creating subvolume
Date: Tue, 18 Sep 2018 09:17:54 +0800
Message-ID: <20180918011754.7981-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify the file name length limit to meet the Linux naming convention.
In addition, the file name length is always bigger than 0, no need to
compare with 0 again.

Changelog:
v2:
 Fix the same problem in creating snapshot routine.

Issue: #145
Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---

v2: Also fix the same problem in creating snapshot routine.

 cmds-subvolume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7a884af1f5d..5a446c1ae2b4 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -155,7 +155,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	}
 
 	len = strlen(newname);
-	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
+	if (len > BTRFS_VOL_NAME_MAX) {
 		error("subvolume name too long: %s", newname);
 		goto out;
 	}
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

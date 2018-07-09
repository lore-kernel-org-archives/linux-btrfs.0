Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51525 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751028AbeGIGjT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 02:39:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 47F3F4B473E0
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2018 14:39:17 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove unused parameter
Date: Mon, 9 Jul 2018 14:39:15 +0800
Message-ID: <1531118355-5953-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since parameter flags is no more used since
commit d7407606564c ("btrfs: split parse_early_options() in two"),
remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..bf546d6c286c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -935,8 +935,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
  *
  * The value is later passed to mount_subvol()
  */
-static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
-		char **subvol_name, u64 *subvol_objectid)
+static int btrfs_parse_subvol_options(const char *options, char **subvol_name,
+		u64 *subvol_objectid)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *orig, *p;
@@ -1650,8 +1650,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
-	error = btrfs_parse_subvol_options(data, mode,
-					  &subvol_name, &subvol_objectid);
+	error = btrfs_parse_subvol_options(data, &subvol_name,
+					&subvol_objectid);
 	if (error) {
 		kfree(subvol_name);
 		return ERR_PTR(error);
-- 
2.17.1




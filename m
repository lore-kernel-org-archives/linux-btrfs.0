Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:60291 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765375AbcIOMQ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 08:16:26 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bkVaV-0002n7-Sr
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 14:16:19 +0200
Received: from 31-151-236-204.dynamic.upc.nl ([31.151.236.204] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bkVaL-0002rz-Ox
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 14:16:19 +0200
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id u8FC92kn022720
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 14:09:13 +0200
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id u8FC8qXa022643
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 14:08:52 +0200
Date: Thu, 15 Sep 2016 14:08:52 +0200
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH]btrfs-progs: btrfs-convert.c : check source file system state
Message-ID: <20160915120852.GA22577@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-convert.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index c10dc17..27da9ce 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2171,6 +2171,17 @@ static void ext2_copy_inode_item(struct btrfs_inode_item *dst,
 	}
 	memset(&dst->reserved, 0, sizeof(dst->reserved));
 }
+static int check_filesystem_state(struct btrfs_convert_context *cctx)
+{
+	ext2_filsys fs = cctx->fs_data;
+
+        if (!(fs->super->s_state & EXT2_VALID_FS))
+		return 1;
+	else if (fs->super->s_state & EXT2_ERROR_FS)
+		return 1;
+	else
+		return 0;
+}
 
 /*
  * copy a single inode. do all the required works, such as cloning
@@ -2340,6 +2351,10 @@ static int do_convert(const char *devname, int datacsum, int packing,
 	ret = convert_open_fs(devname, &cctx);
 	if (ret)
 		goto fail;
+	ret = check_filesystem_state(&cctx);
+	if (ret) 
+		warning("Source Filesystem is not clean, \
+			 running e2fsck is recommended.");
 	ret = convert_read_used_space(&cctx);
 	if (ret)
 		goto fail;
-- 
1.9.3


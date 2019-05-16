Return-Path: <SRS0=Y5xQ=TQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9FFC04AAF
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 13:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A928520818
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 13:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfEPNMx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 May 2019 09:12:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:55088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726692AbfEPNMx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 May 2019 09:12:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 439B3AA71
        for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2019 13:12:52 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs-progs: Correctly open filesystem on image file
Date:   Thu, 16 May 2019 16:12:49 +0300
Message-Id: <20190516131250.26621-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When btrfs' 'filesystem' subcommand is passed path to an image file it
currently fails since the code expects the image file is going to be
recognised by libblkid (called from btrfs_scan_devices()). This is not
the case since libblkid only scan well-known locations under /dev.

Fix this by explicitly calling open_ctree which will correctly open
the image and add it to the correct btrfs_fs_devices struct. This allows
subsequent cmd_filesystem_show logic to correctly show requested
information.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-filesystem.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b8beec13f0e5..f55ce9b4ab85 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -771,7 +771,18 @@ static int cmd_filesystem_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = btrfs_scan_devices();
+	if (type == BTRFS_ARG_REG) {
+		/*
+		 * We don't close the fs_info because it will free the device,
+		 * this is not a long-running process so it's fine
+		 */
+		if (open_ctree(search, btrfs_sb_offset(0), 0))
+			ret = 0;
+		else
+			ret = 1;
+	} else {
+		ret = btrfs_scan_devices();
+	}
 
 	if (ret) {
 		error("blkid device scan returned %d", ret);
-- 
2.7.4


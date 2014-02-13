Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:62560 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBMPNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 10:13:44 -0500
Received: by mail-yh0-f46.google.com with SMTP id v1so10162890yhn.5
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 07:13:43 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: fix max_inline mount option
Date: Thu, 13 Feb 2014 09:13:16 -0600
Message-Id: <1392304396-4952-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the only mount option for max_inline that has any effect is
max_inline=0.  Any other value that is supplied to max_inline will be
adjusted to a minimum of 4k.  Since max_inline has an effective maximum
of ~3900 bytes due to page size limitations, the current behaviour
only has meaning for max_inline=0.

This patch will allow the the max_inline mount option to accept non-zero
values as indicated in the documentation.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 97cc241..e73c80e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -566,7 +566,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				kfree(num);
 
 				if (info->max_inline) {
-					info->max_inline = max_t(u64,
+					info->max_inline = min_t(u64,
 						info->max_inline,
 						root->sectorsize);
 				}
-- 
1.8.3.2


Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B817C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C39360232
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhBISUe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbhBISRu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2021 13:17:50 -0500
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602F2C061793
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2021 10:07:08 -0800 (PST)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id D461114115D;
        Tue,  9 Feb 2021 19:05:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1612893925; bh=K1+jjerXmmhtCeDAwPvcMGj06l5KENzukiwqOcn4njM=;
        h=From:To:Date;
        b=wm+yoOEEFuVOeIbpywGo8eCW5ANVo4NbZk7uEVLCNlUuhRYqICbadHed0xs43sSBR
         N36VTjJ6uSaiJZwqwuE1PhGpegpuR4S9RgEOoEulsYVEE4C3pqksWWb8joojkpBOMB
         OHYupqBKrX6nfYtJ7xVHumrY55RZ4QbJwOZrdtf0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     u-boot@lists.denx.de
Cc:     linux-btrfs@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Tom Rini <trini@konsulko.com>
Subject: [PATCH u-boot 2/2] fs: btrfs: change directory list output to be aligned as before
Date:   Tue,  9 Feb 2021 19:05:08 +0100
Message-Id: <20210209180508.22132-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209180508.22132-1-marek.behun@nic.cz>
References: <20210209180508.22132-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit 325dd1f642dd ("fs: btrfs: Use btrfs_iter_dir() to ...")
when btrfs is listing a directory, the output is not aligned:

  <SYMLINK>         15  Wed Sep 09 13:20:03 2020  boot.scr -> @/boot/boot.scr
  <DIR>          0  Tue Feb 02 12:42:09 2021  @
  <FILE>        108  Tue Feb 02 12:54:04 2021  1.info

Return back to how it was displayed previously, i.e.:

  <SYM>         15  Wed Sep 09 13:20:03 2020  boot.scr -> @/boot/boot.scr
  <DIR>          0  Tue Feb 02 12:42:09 2021  @
  <   >        108  Tue Feb 02 12:54:04 2021  1.info

Instead of '<FILE>', print '<   >', as ext4 driver.

If an unknown directory item type is encountered, we will print the type
number left padded with spaces, enclosed by '?', instead of '<' and '>',
i.e.:

  ? 30?        .............................  name

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Fixes: 325dd1f642dd ("fs: btrfs: Use btrfs_iter_dir() to replace ...")
Cc: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Tom Rini <trini@konsulko.com>
---
 fs/btrfs/btrfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index 6b4c5feb53..52a243a659 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -22,13 +22,13 @@ static int show_dir(struct btrfs_root *root, struct extent_buffer *eb,
 	struct btrfs_inode_item ii;
 	struct btrfs_key key;
 	static const char* dir_item_str[] = {
-		[BTRFS_FT_REG_FILE]	= "FILE",
+		[BTRFS_FT_REG_FILE]	= "   ",
 		[BTRFS_FT_DIR] 		= "DIR",
-		[BTRFS_FT_CHRDEV]	= "CHRDEV",
-		[BTRFS_FT_BLKDEV]	= "BLKDEV",
-		[BTRFS_FT_FIFO]		= "FIFO",
-		[BTRFS_FT_SOCK]		= "SOCK",
-		[BTRFS_FT_SYMLINK]	= "SYMLINK",
+		[BTRFS_FT_CHRDEV]	= "CHR",
+		[BTRFS_FT_BLKDEV]	= "BLK",
+		[BTRFS_FT_FIFO]		= "FIF",
+		[BTRFS_FT_SOCK]		= "SCK",
+		[BTRFS_FT_SYMLINK]	= "SYM",
 	};
 	u8 type = btrfs_dir_type(eb, di);
 	char namebuf[BTRFS_NAME_LEN];
@@ -93,7 +93,7 @@ static int show_dir(struct btrfs_root *root, struct extent_buffer *eb,
 	if (type < ARRAY_SIZE(dir_item_str) && dir_item_str[type])
 		printf("<%s> ", dir_item_str[type]);
 	else
-		printf("DIR_ITEM.%u", type);
+		printf("?%3u? ", type);
 	if (type == BTRFS_FT_CHRDEV || type == BTRFS_FT_BLKDEV) {
 		ASSERT(key.type == BTRFS_INODE_ITEM_KEY);
 		printf("%4llu,%5llu  ", btrfs_stack_inode_rdev(&ii) >> 20,
-- 
2.26.2


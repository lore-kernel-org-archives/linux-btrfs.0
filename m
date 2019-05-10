Return-Path: <SRS0=Lj+K=TK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27167C04A6B
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 11:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F288120989
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 11:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfEJLQI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 May 2019 07:16:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:50568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727257AbfEJLPy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 May 2019 07:15:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 485C7AF94
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2019 11:15:52 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 09/17] btrfs: add common checksum type validation
Date:   Fri, 10 May 2019 13:15:39 +0200
Message-Id: <20190510111547.15310-10-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190510111547.15310-1-jthumshirn@suse.de>
References: <20190510111547.15310-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently btrfs is only supporting CRC32C as checksumming algorithm. As
this is about to change provide a function to validate the checksum type in
the superblock against all possible algorithms.

This makes adding new algorithms easier as there are fewer places to adjust
when adding new algorithms.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/disk-io.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 663efce22d98..ab13282d91d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -356,6 +356,16 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	return ret;
 }
 
+static bool btrfs_supported_super_csum(struct btrfs_super_block *sb)
+{
+	switch (btrfs_super_csum_type(sb)) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
@@ -368,6 +378,12 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	u16 csum_type = btrfs_super_csum_type(disk_sb);
 	int ret = 0;
 
+	if (!btrfs_supported_super_csum(disk_sb)) {
+		btrfs_err(fs_info, "unsupported checksum algorithm %u",
+			  csum_type);
+		ret = 1;
+	}
+
 	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
 		u32 crc = ~(u32)0;
 		char result[sizeof(crc)];
@@ -385,12 +401,6 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 			ret = 1;
 	}
 
-	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-				csum_type);
-		ret = 1;
-	}
-
 	return ret;
 }
 
@@ -2577,7 +2587,7 @@ static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
 	ret = validate_super(fs_info, sb, -1);
 	if (ret < 0)
 		goto out;
-	if (btrfs_super_csum_type(sb) != BTRFS_CSUM_TYPE_CRC32) {
+	if (!btrfs_supported_super_csum(sb)) {
 		ret = -EUCLEAN;
 		btrfs_err(fs_info, "invalid csum type, has %u want %u",
 			  btrfs_super_csum_type(sb), BTRFS_CSUM_TYPE_CRC32);
-- 
2.16.4


Return-Path: <SRS0=N9Hd=TW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98FBC072A4
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 08:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FB3920856
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 08:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfEVITR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 May 2019 04:19:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:60478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728598AbfEVITR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 May 2019 04:19:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 140B8AF4C;
        Wed, 22 May 2019 08:19:16 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 06/13] btrfs: format checksums according to type for printing
Date:   Wed, 22 May 2019 10:19:03 +0200
Message-Id: <20190522081910.7689-7-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190522081910.7689-1-jthumshirn@suse.de>
References: <20190522081910.7689-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a small helper for btrfs_print_data_csum_error() which formats the
checksum according to it's type for pretty printing.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d5b438706b77..f0a757eb5744 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -337,22 +337,42 @@ static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
 	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
 }
 
+static inline void btrfs_csum_format(struct btrfs_super_block *sb,
+				     u32 csum, u8 *cbuf)
+{
+	size_t size = btrfs_super_csum_size(sb) * 8;
+
+	switch (btrfs_super_csum_type(sb)) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		snprintf(cbuf, size, "0x%08x", csum);
+		break;
+	default: /* can't happen -  csum type is validated at mount time */
+		break;
+	}
+}
+
 static inline void btrfs_print_data_csum_error(struct btrfs_inode *inode,
 		u64 logical_start, u32 csum, u32 csum_expected, int mirror_num)
 {
 	struct btrfs_root *root = inode->root;
+	struct btrfs_super_block *sb = root->fs_info->super_copy;
+	u8 cbuf[BTRFS_CSUM_SIZE];
+	u8 ecbuf[BTRFS_CSUM_SIZE];
+
+	btrfs_csum_format(sb, csum, cbuf);
+	btrfs_csum_format(sb, csum_expected, ecbuf);
 
 	/* Output minus objectid, which is more meaningful */
 	if (root->root_key.objectid >= BTRFS_LAST_FREE_OBJECTID)
 		btrfs_warn_rl(root->fs_info,
-	"csum failed root %lld ino %lld off %llu csum 0x%08x expected csum 0x%08x mirror %d",
+	"csum failed root %lld ino %lld off %llu csum %s expected csum %s mirror %d",
 			root->root_key.objectid, btrfs_ino(inode),
-			logical_start, csum, csum_expected, mirror_num);
+			logical_start, cbuf, ecbuf, mirror_num);
 	else
 		btrfs_warn_rl(root->fs_info,
-	"csum failed root %llu ino %llu off %llu csum 0x%08x expected csum 0x%08x mirror %d",
+	"csum failed root %llu ino %llu off %llu csum %s expected csum %s mirror %d",
 			root->root_key.objectid, btrfs_ino(inode),
-			logical_start, csum, csum_expected, mirror_num);
+			logical_start, cbuf, ecbuf, mirror_num);
 }
 
 #endif
-- 
2.16.4


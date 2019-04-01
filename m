Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C02C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E5D20850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfDAF4B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:56:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:54340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfDAF4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:56:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 232F6ACBF;
        Mon,  1 Apr 2019 05:56:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Thorsten Hirsch <t.hirsch@web.de>
Subject: [PATCH v2 2/7] btrfs-progs: check/original: Add inode mode check
Date:   Mon,  1 Apr 2019 13:55:46 +0800
Message-Id: <20190401055551.6837-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190401055551.6837-1-wqu@suse.com>
References: <20190401055551.6837-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just like lowmem mode, check inode mode, specially for S_IFMT bits and
beyond.

Please note that, this check only applies to inodes in fs/subvol trees.
It doesn't apply to free space cache inodes.

Reported-by: Thorsten Hirsch <t.hirsch@web.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c          | 5 +++++
 check/mode-original.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/check/main.c b/check/main.c
index 7547209c5604..553c93caa2c9 100644
--- a/check/main.c
+++ b/check/main.c
@@ -616,6 +616,9 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		fprintf(stderr, ", odd inode flags");
 	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
 		fprintf(stderr, ", invalid inline ram bytes");
+	if (errors & I_ERR_INVALID_IMODE)
+		fprintf(stderr, ", invalid inode mode bit 0%o",
+			rec->imode & ~07777);
 	fprintf(stderr, "\n");
 	/* Print the orphan extents if needed */
 	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
@@ -811,6 +814,8 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 	if (!rec->checked || rec->merging)
 		return;
 
+	if (!is_valid_imode(rec->imode))
+		rec->errors |= I_ERR_INVALID_IMODE;
 	if (S_ISDIR(rec->imode)) {
 		if (rec->found_size != rec->isize)
 			rec->errors |= I_ERR_DIR_ISIZE_WRONG;
diff --git a/check/mode-original.h b/check/mode-original.h
index 25ca274118a7..e40a12930a6f 100644
--- a/check/mode-original.h
+++ b/check/mode-original.h
@@ -189,6 +189,7 @@ struct file_extent_hole {
 #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
 #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
 #define I_ERR_MISMATCH_DIR_HASH		(1 << 18)
+#define I_ERR_INVALID_IMODE		(1 << 19)
 
 struct inode_record {
 	struct list_head backrefs;
-- 
2.21.0


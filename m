Return-Path: <SRS0=ZM7b=7O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF79BC433DF
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA672207DF
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgFAPXQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:23:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:57008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgFAPXP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:23:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91A82ADF7;
        Mon,  1 Jun 2020 15:23:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9B5D9DA79B; Mon,  1 Jun 2020 17:23:12 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/9] btrfs: scrub: clean up temporary page variables in scrub_checksum_super
Date:   Mon,  1 Jun 2020 17:23:12 +0200
Message-Id: <2a57542d694e1857ec8ea6be2cbccf0e82630fc7.1591024792.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1591024792.git.dsterba@suse.com>
References: <cover.1591024792.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add proper variable for the scrub page and use it instead of repeatedly
dereferencing the other structures.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index abb39c5255d2..aecaf5c7f655 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1904,23 +1904,23 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
-	struct page *page;
+	struct scrub_page *spage;
 	char *kaddr;
 	int fail_gen = 0;
 	int fail_cor = 0;
 
 	BUG_ON(sblock->page_count < 1);
-	page = sblock->pagev[0]->page;
-	kaddr = page_address(page);
+	spage = sblock->pagev[0];
+	kaddr = page_address(spage->page);
 	s = (struct btrfs_super_block *)kaddr;
 
-	if (sblock->pagev[0]->logical != btrfs_super_bytenr(s))
+	if (spage->logical != btrfs_super_bytenr(s))
 		++fail_cor;
 
-	if (sblock->pagev[0]->generation != btrfs_super_generation(s))
+	if (spage->generation != btrfs_super_generation(s))
 		++fail_gen;
 
-	if (!scrub_check_fsid(s->fsid, sblock->pagev[0]))
+	if (!scrub_check_fsid(s->fsid, spage))
 		++fail_cor;
 
 	shash->tfm = fs_info->csum_shash;
@@ -1941,10 +1941,10 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		++sctx->stat.super_errors;
 		spin_unlock(&sctx->stat_lock);
 		if (fail_cor)
-			btrfs_dev_stat_inc_and_print(sblock->pagev[0]->dev,
+			btrfs_dev_stat_inc_and_print(spage->dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sblock->pagev[0]->dev,
+			btrfs_dev_stat_inc_and_print(spage->dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 	}
 
-- 
2.25.0


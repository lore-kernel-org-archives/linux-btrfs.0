Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5410CC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD19207D4
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgGBNrE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 09:47:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:45850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgGBNqz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jul 2020 09:46:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F3C44AD76;
        Thu,  2 Jul 2020 13:46:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/10] btrfs: Remove fail label in check_compressed_csum
Date:   Thu,  2 Jul 2020 16:46:47 +0300
Message-Id: <20200702134650.16550-8-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702134650.16550-1-nborisov@suse.com>
References: <20200702134650.16550-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2f30bf4127f8..48ceab7be0fe 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -178,7 +178,6 @@ static int check_compressed_csum(struct btrfs_inode *inode, struct bio *bio,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 	const u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	int ret;
 	struct page *page;
 	unsigned long i;
 	char *kaddr;
@@ -204,15 +203,12 @@ static int check_compressed_csum(struct btrfs_inode *inode, struct bio *bio,
 			if (btrfs_io_bio(bio)->dev)
 				btrfs_dev_stat_inc_and_print(btrfs_io_bio(bio)->dev,
 					BTRFS_DEV_STAT_CORRUPTION_ERRS);
-			ret = -EIO;
-			goto fail;
+			return -EIO;
 		}
 		cb_sum += csum_size;
 
 	}
-	ret = 0;
-fail:
-	return ret;
+	return 0;
 }
 
 /* when we finish reading compressed pages from the disk, we
-- 
2.17.1


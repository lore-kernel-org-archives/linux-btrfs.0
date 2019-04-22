Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF51FC10F11
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B615020859
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 13:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfDVNHe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 09:07:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:54264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfDVNHe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 09:07:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89057AD2B
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 13:07:33 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Document btrfs_csum_one_bio
Date:   Mon, 22 Apr 2019 16:07:31 +0300
Message-Id: <20190422130731.30226-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file-item.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 7e2cd9c81eb1..fa5057a4b53a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -412,6 +412,16 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	return ret;
 }
 
+/*
+ * btrfs_csum_one_bio - Calculates checksums of the data contained inside a bio
+ * @inode:	 Owner of the data inside the bio
+ * @bio:	 Contains the data to be checksummed
+ * @file_start:  offset in file this bio begins to describe
+ * @contig:	 Boolean. If true/1 means all bio vecs in this bio are
+ *		 contiguous and they begin at @file_start in the file. False/0
+ *		 means this bio can contains potentially discontigous bio vecs
+ *		 so the logical offset of each should be calculated separately.
+ */
 blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 		       u64 file_start, int contig)
 {
-- 
2.17.1


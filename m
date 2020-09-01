Return-Path: <SRS0=FDMB=CK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AB0C433E2
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB34021655
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgIAOlP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:41:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:55638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgIAOkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Sep 2020 10:40:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C41CB65A;
        Tue,  1 Sep 2020 14:40:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Add kerneldoc for setup_items_for_insert
Date:   Tue,  1 Sep 2020 17:40:00 +0300
Message-Id: <20200901144001.4265-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901144001.4265-1-nborisov@suse.com>
References: <20200901144001.4265-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 26e653e92956..bb89c0954ca1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4744,10 +4744,16 @@ void btrfs_extend_item(struct btrfs_path *path, u32 data_size)
 	}
 }
 
-/*
- * this is a helper for btrfs_insert_empty_items, the main goal here is
- * to save stack depth by doing the bulk of the work in a function
- * that doesn't call btrfs_search_slot
+/**
+ * setup_items_for_insert - Helper called before inserting one or more items
+ * in a leaf. Main purpose is to save stack depth by doing the bulk of the work
+ * in a function that doesn't call btrfs_search_slot
+ *
+ * @root:	root we are inserting items in
+ * @path:	points to the leaf/slot where we are going to insert new items
+ * @cpu_key:	array of keys for items to be inserted
+ * @data_size:	size of the body of each item we are going to insert
+ * @nr:		size of @cpu_key/@data_size arrays
  */
 void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 			    const struct btrfs_key *cpu_key, u32 *data_size,
-- 
2.17.1


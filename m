Return-Path: <SRS0=Lj+Q=5C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FC1C10F29
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45392206EC
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgCQILy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 04:11:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:42350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgCQILy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Mar 2020 04:11:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 616F2AD31
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2020 08:11:53 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 06/39] btrfs: relocation: Add backref_cache::fs_info member
Date:   Tue, 17 Mar 2020 16:10:52 +0800
Message-Id: <20200317081125.36289-7-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317081125.36289-1-wqu@suse.com>
References: <20200317081125.36289-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add this member so that we can grab fs_info without the help from
reloc_control.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 837a8a9a3434..560a144d5b95 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -163,6 +163,8 @@ struct backref_cache {
 
 	/* The list of useless backref nodes during backref cache build */
 	struct list_head useless_node;
+
+	struct btrfs_fs_info *fs_info;
 };
 
 /*
@@ -264,7 +266,8 @@ static void mapping_tree_init(struct mapping_tree *tree)
 	spin_lock_init(&tree->lock);
 }
 
-static void backref_cache_init(struct backref_cache *cache)
+static void backref_cache_init(struct btrfs_fs_info *fs_info,
+			       struct backref_cache *cache)
 {
 	int i;
 	cache->rb_root = RB_ROOT;
@@ -275,6 +278,7 @@ static void backref_cache_init(struct backref_cache *cache)
 	INIT_LIST_HEAD(&cache->leaves);
 	INIT_LIST_HEAD(&cache->pending_edge);
 	INIT_LIST_HEAD(&cache->useless_node);
+	cache->fs_info = fs_info;
 }
 
 static void backref_cache_cleanup(struct backref_cache *cache)
@@ -4303,7 +4307,7 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
 
 	INIT_LIST_HEAD(&rc->reloc_roots);
 	INIT_LIST_HEAD(&rc->dirty_subvol_roots);
-	backref_cache_init(&rc->backref_cache);
+	backref_cache_init(fs_info, &rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
 	extent_io_tree_init(fs_info, &rc->processed_blocks,
 			    IO_TREE_RELOC_BLOCKS, NULL);
-- 
2.25.1


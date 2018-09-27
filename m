Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AA2C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6367215E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 23:59:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6367215E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbeI1GUa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 02:20:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:38506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725924AbeI1GUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 02:20:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D70F0B016
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 23:59:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: Check level for leaves and nodes
Date:   Fri, 28 Sep 2018 07:59:34 +0800
Message-Id: <20180927235934.5215-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although we have tree level check at tree read runtime, it's completely
based on its parent level.
We still need to do accurate level check to avoid invalid tree blocks
sneak into kernel space.

The check itself is simple, for leaf its level should always be 0.
For nodes its level should be in range [1, BTRFS_MAX_LEVEL - 1].

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index db835635372f..cab0b1f1f741 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -487,6 +487,13 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
+	if (btrfs_header_level(leaf) != 0) {
+		generic_err(fs_info, leaf, 0,
+			"invalid level for leaf, have %d expect 0",
+			btrfs_header_level(leaf));
+		return -EUCLEAN;
+	}
+
 	/*
 	 * Extent buffers from a relocation tree have a owner field that
 	 * corresponds to the subvolume tree they are based on. So just from an
@@ -645,9 +652,16 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
 	unsigned long nr = btrfs_header_nritems(node);
 	struct btrfs_key key, next_key;
 	int slot;
+	int level = btrfs_header_level(node);
 	u64 bytenr;
 	int ret = 0;
 
+	if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
+		generic_err(fs_info, node, 0,
+			"invalid level for node, have %d expect [1, %d]",
+			level, BTRFS_MAX_LEVEL - 1);
+		return -EUCLEAN;
+	}
 	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(fs_info)) {
 		btrfs_crit(fs_info,
 "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%u]",
-- 
2.19.0


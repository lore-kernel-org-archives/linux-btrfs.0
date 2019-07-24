Return-Path: <SRS0=kS6Y=VV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF80C7618B
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 08:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9FC21951
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 08:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfGXIgE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jul 2019 04:36:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:44778 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfGXIgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jul 2019 04:36:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C01EAEBD
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2019 08:36:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: extent-tree: Unify the parameters of btrfs_inc_extent_ref()
Date:   Wed, 24 Jul 2019 16:35:54 +0800
Message-Id: <20190724083554.5545-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The old parameters, @ref_generation and @owner_objectid, are pretty
confusing when using auto-completion.

Unify the parameters as a quick fix.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index b73abe140b1c..0d12563b7261 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2537,10 +2537,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 root_objectid, u64 owner, u64 offset);
 void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 parent,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner_objectid);
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 owner, u64 offset);
 int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 bytenr,
 			    u64 orig_parent, u64 parent,
-- 
2.22.0


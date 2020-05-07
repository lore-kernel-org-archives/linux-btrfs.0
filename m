Return-Path: <SRS0=WhU1=6V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2000EC38A2A
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 20:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20F924966
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 20:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgEGUU1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 May 2020 16:20:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGUU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 May 2020 16:20:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3B3FAE0A;
        Thu,  7 May 2020 20:20:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4A383DA732; Thu,  7 May 2020 22:19:37 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 04/19] btrfs: don't use set/get token in leaf_space_used
Date:   Thu,  7 May 2020 22:19:37 +0200
Message-Id: <1cc25c58e0c35e35bc01e621de48649bdca6746d.1588853772.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1588853772.git.dsterba@suse.com>
References: <cover.1588853772.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The token is supposed to cache the last page used by the set/get
helpers. In leaf_space_used the first and last items are accessed, it's
not likely they'd be on the same page so there's some overhead caused
updating the token address but not using it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 576111cdea1d..6dbeb23c59ec 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3507,19 +3507,17 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
 {
 	struct btrfs_item *start_item;
 	struct btrfs_item *end_item;
-	struct btrfs_map_token token;
 	int data_len;
 	int nritems = btrfs_header_nritems(l);
 	int end = min(nritems, start + nr) - 1;
 
 	if (!nr)
 		return 0;
-	btrfs_init_map_token(&token, l);
 	start_item = btrfs_item_nr(start);
 	end_item = btrfs_item_nr(end);
-	data_len = btrfs_token_item_offset(&token, start_item) +
-		btrfs_token_item_size(&token, start_item);
-	data_len = data_len - btrfs_token_item_offset(&token, end_item);
+	data_len = btrfs_item_offset(l, start_item) +
+		   btrfs_item_size(l, start_item);
+	data_len = data_len - btrfs_item_offset(l, end_item);
 	data_len += sizeof(struct btrfs_item) * nr;
 	WARN_ON(data_len < 0);
 	return data_len;
-- 
2.25.0


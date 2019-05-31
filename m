Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFB2C04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 17:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9094A26CA5
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 17:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfEaRAb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 13:00:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfEaRAa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 13:00:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C293DAD6F
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2019 17:00:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 775A3DA85E; Fri, 31 May 2019 19:01:23 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/5] btrfs: assert extent map tree lock in add_extent_mapping
Date:   Fri, 31 May 2019 19:01:23 +0200
Message-Id: <5fb9699164475ff7ba825fb31b7b0d1b84d2f359.1559321947.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559321947.git.dsterba@suse.com>
References: <cover.1559321947.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As add_extent_mapping is called from several functions, let's add the
lock annotation. The tree is going to be modified so it must be the
exclusive lock.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 9558d79faf1e..a73af4159495 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -384,6 +384,8 @@ int add_extent_mapping(struct extent_map_tree *tree,
 {
 	int ret = 0;
 
+	lockdep_assert_held_exclusive(&tree->lock);
+
 	ret = tree_insert(&tree->map, em);
 	if (ret)
 		goto out;
-- 
2.21.0


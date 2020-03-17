Return-Path: <SRS0=Lj+Q=5C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859AAC10F29
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6781620674
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgCQIMb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 04:12:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:42700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgCQIMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Mar 2020 04:12:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 25705ADA1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2020 08:12:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 20/39] btrfs: Move link_backref_edge() to backref.c
Date:   Tue, 17 Mar 2020 16:11:06 +0800
Message-Id: <20200317081125.36289-21-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317081125.36289-1-wqu@suse.com>
References: <20200317081125.36289-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.h    | 16 ++++++++++++++++
 fs/btrfs/relocation.c | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 87d0735908ed..b21304d3f3f8 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -274,4 +274,20 @@ void backref_cache_init(struct btrfs_fs_info *fs_info,
 struct backref_node *alloc_backref_node(struct backref_cache *cache,
 					u64 bytenr, int level);
 struct backref_edge *alloc_backref_edge(struct backref_cache *cache);
+
+#define		LINK_LOWER	(1 << 0)
+#define		LINK_UPPER	(1 << 1)
+static inline void link_backref_edge(struct backref_edge *edge,
+				     struct backref_node *lower,
+				     struct backref_node *upper,
+				     int link_which)
+{
+	ASSERT(upper && lower && upper->level == lower->level + 1);
+	edge->node[LOWER] = lower;
+	edge->node[UPPER] = upper;
+	if (link_which & LINK_LOWER)
+		list_add_tail(&edge->list[LOWER], &lower->upper);
+	if (link_which & LINK_UPPER)
+		list_add_tail(&edge->list[UPPER], &upper->lower);
+}
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0357dc8861fc..efd49553ada0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -225,22 +225,6 @@ static void free_backref_node(struct backref_cache *cache,
 	}
 }
 
-#define		LINK_LOWER	(1 << 0)
-#define		LINK_UPPER	(1 << 1)
-static void link_backref_edge(struct backref_edge *edge,
-			      struct backref_node *lower,
-			      struct backref_node *upper,
-			      int link_which)
-{
-	ASSERT(upper && lower && upper->level == lower->level + 1);
-	edge->node[LOWER] = lower;
-	edge->node[UPPER] = upper;
-	if (link_which & LINK_LOWER)
-		list_add_tail(&edge->list[LOWER], &lower->upper);
-	if (link_which & LINK_UPPER)
-		list_add_tail(&edge->list[UPPER], &upper->lower);
-}
-
 static void free_backref_edge(struct backref_cache *cache,
 			      struct backref_edge *edge)
 {
-- 
2.25.1


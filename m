Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16493 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbbHUNJY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 09:09:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7LD9For004936
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 21:09:15 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Add initialztion of rec->crossing_stripes
Date: Fri, 21 Aug 2015 21:07:43 +0800
Message-ID: <3632be46c332732074edadc308bf0201b75cb6db.1440162456.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rec->crossing_stripes is not initialized in allocate place,
and have possibility causing wrong report for normal tree block.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 4f18e45..2e6dc68 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4419,6 +4419,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->metadata = metadata;
 	rec->flag_block_full_backref = -1;
 	rec->bad_full_backref = 0;
+	rec->crossing_stripes = 0;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
 	INIT_LIST_HEAD(&rec->list);
-- 
1.8.5.1


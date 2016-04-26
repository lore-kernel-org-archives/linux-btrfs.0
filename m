Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbcDZCud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 22:50:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: fsck: Fix found bytes accounting error
Date: Tue, 26 Apr 2016 10:49:49 +0800
Message-Id: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the new add_extent_rec_nolookup() function, we add bytes_used to
update found bytes accounting.

However there is a typo that we used tmpl->nr, which should be rec->nr.
This will make us to add 1 for data backref, instead the correct size.

Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index d59968b..b207f8e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4550,7 +4550,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	rec->cache.size = tmpl->nr;
 	ret = insert_cache_extent(extent_cache, &rec->cache);
 	BUG_ON(ret);
-	bytes_used += tmpl->nr;
+	bytes_used += rec->nr;
 
 	if (tmpl->metadata)
 		rec->crossing_stripes = check_crossing_stripes(rec->start,
-- 
2.8.0




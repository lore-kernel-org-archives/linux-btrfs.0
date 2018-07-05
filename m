Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753220AbeGEHqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:46:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 44DC8AF54
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:46:00 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: check: orig: Don't panic out when unexpected root item is referring to one extent
Date: Thu,  5 Jul 2018 15:45:56 +0800
Message-Id: <20180705074558.20022-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With crafted image, expected root item can refer to certain extent, and
original mode uses BUG_ON() to handle such case.

Fix it by gracefully return error.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200403
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 8db300abb825..6f1182106071 100644
--- a/check/main.c
+++ b/check/main.c
@@ -3724,7 +3724,12 @@ static int check_owner_ref(struct btrfs_root *root,
 		if (btrfs_header_owner(buf) == back->root)
 			return 0;
 	}
-	BUG_ON(rec->is_root);
+	/*
+	 * Some unexpected root item referring to this one, return 1 to
+	 * indicate owner not found
+	 */
+	if (rec->is_root)
+		return 1;
 
 	/* try to find the block by search corresponding fs tree */
 	key.objectid = btrfs_header_owner(buf);
-- 
2.18.0


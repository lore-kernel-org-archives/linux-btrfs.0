Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36617 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbJSLuP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:50:15 -0400
Received: by pacfv9 with SMTP id fv9so93780012pac.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:50:14 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 10/10] btrfs-progs: return -ENOMEM properly in btrfs_read_block_groups()
Date: Mon, 19 Oct 2015 19:38:00 +0800
Message-Id: <1445254680-11102-11-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Breaking from the while loop makes ret overwritten to zero, goto error
label directly and return -ENOMEM.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 0c8152a..97cf961 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3255,7 +3255,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache = kzalloc(sizeof(*cache), GFP_NOFS);
 		if (!cache) {
 			ret = -ENOMEM;
-			break;
+			goto error;
 		}
 
 		read_extent_buffer(leaf, &cache->item,
-- 
2.4.3


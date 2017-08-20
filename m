Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60828 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753274AbdHTUST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 16:18:19 -0400
Subject: [PATCH 1/4] btrfs: Delete an error message for a failed memory
 allocation in btrfsic_process_superblock()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Message-ID: <f03ea416-7ebb-152b-2e32-d35551d7af26@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:17:37 +0200
MIME-Version: 1.0
In-Reply-To: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 21:10:17 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/check-integrity.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7d65d98d2790..9701a38860d6 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -656,10 +656,8 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 
 	BUG_ON(NULL == state);
 	selected_super = kzalloc(sizeof(*selected_super), GFP_NOFS);
-	if (NULL == selected_super) {
-		pr_info("btrfsic: error, kmalloc failed!\n");
+	if (!selected_super)
 		return -ENOMEM;
-	}
 
 	list_for_each_entry(device, dev_head, dev_list) {
 		int i;
-- 
2.14.0


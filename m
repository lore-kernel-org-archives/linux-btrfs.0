Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42003 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3G3TqL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 15:46:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8171E9A069F
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 13:46:11 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id ieTIc1bE00FVDSLt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 13:46:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check to see if we have an inline item properly
Date: Tue, 30 Jul 2013 15:46:08 -0400
Message-ID: <1375213568-3118-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If our item isn't big enough to have an actual inline item when we have skinny
metadata enabled just return 1 in find_inline_backref so we can move on to the
next item.  This probably wasn't causing a problem since we check the values of
ptr and end properly, but just in case this will keep us from doing extra work.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/relocation.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 5a23d87..8168fb3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -641,6 +641,11 @@ int find_inline_backref(struct extent_buffer *leaf, int slot,
 		WARN_ON(item_size < sizeof(*ei) + sizeof(*bi));
 		return 1;
 	}
+	if (key.type == BTRFS_METADATA_ITEM_KEY &&
+	    item_size <= sizeof(*ei)) {
+		WARN_ON(item_size < sizeof(*ei));
+		return 1;
+	}
 
 	if (key.type == BTRFS_EXTENT_ITEM_KEY) {
 		bi = (struct btrfs_tree_block_info *)(ei + 1);
-- 
1.7.7.6


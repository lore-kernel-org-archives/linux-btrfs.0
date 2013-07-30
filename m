Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39599 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab3G3X1R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 19:27:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so2745486wib.5
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 16:27:16 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: add missing error check to find_parent_nodes
Date: Wed, 31 Jul 2013 00:26:35 +0100
Message-Id: <1375226795-7671-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
References: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Ensure extent buffer is freed on error.

 fs/btrfs/backref.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bc5e8c..980e85a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -935,8 +935,10 @@ again:
 				}
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
-				ref->inode_list = eie;
 				free_extent_buffer(eb);
+				if (ret < 0)
+					goto out;
+				ref->inode_list = eie;
 			}
 			ret = ulist_add_merge(refs, ref->parent,
 					      (uintptr_t)ref->inode_list,
-- 
1.7.9.5


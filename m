Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:58869 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3G3Syc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 14:54:32 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so5268998wev.8
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 11:54:30 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing error check to find_parent_nodes
Date: Tue, 30 Jul 2013 19:54:22 +0100
Message-Id: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/backref.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bc5e8c..1ba87c5 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -935,6 +935,8 @@ again:
 				}
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
+				if (ret < 0)
+					goto out;
 				ref->inode_list = eie;
 				free_extent_buffer(eb);
 			}
-- 
1.7.9.5


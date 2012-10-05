Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40457 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab2JEUlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:41:46 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id PnjzRrW3fFGvRsHy (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 14:41:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not warn_on when we cannot alloc a page for an extent buffer
Date: Fri, 5 Oct 2012 16:47:20 -0400
Message-ID: <1349470040-6970-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's just annoying and the user will have gotten a nice OOM killer message
so they are already fully aware they are screwed :).  Thanks,

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8c37cb6..7dc69b3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4249,10 +4249,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 
 	for (i = 0; i < num_pages; i++, index++) {
 		p = find_or_create_page(mapping, index, GFP_NOFS);
-		if (!p) {
-			WARN_ON(1);
+		if (!p)
 			goto free_eb;
-		}
 
 		spin_lock(&mapping->private_lock);
 		if (PagePrivate(p)) {
-- 
1.7.7.6


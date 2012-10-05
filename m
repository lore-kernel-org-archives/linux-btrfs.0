Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40473 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab2JEUmt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:42:49 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id OdcNhNOKsTlIetYh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 14:42:48 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't bug on enomem in readpage
Date: Fri, 5 Oct 2012 16:48:24 -0400
Message-ID: <1349470104-7240-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get rid of the BUG_ON(ret == -ENOMEM) in __extent_read_full_page.  Thanks,

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b82d244..8c37cb6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2751,12 +2751,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag);
-			BUG_ON(ret == -ENOMEM);
-			nr++;
-			*bio_flags = this_bio_flag;
+			if (!ret) {
+				nr++;
+				*bio_flags = this_bio_flag;
+			}
 		}
-		if (ret)
+		if (ret) {
 			SetPageError(page);
+			unlock_extent(tree, cur, cur + iosize - 1);
+		}
 		cur = cur + iosize;
 		pg_offset += iosize;
 	}
-- 
1.7.7.6


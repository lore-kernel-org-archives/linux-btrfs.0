Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:14367 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab2JKNzk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 09:55:40 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 30.20 OK)
	with ESMTP id p073b4o9BCPpL6 for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Oct 2012 15:25:16 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Fix wrong error handling code
Date: Thu, 11 Oct 2012 15:25:16 +0200
Message-Id: <1349961916-19655-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gcc says "warning: comparison of unsigned expression >= 0 is always
true" because i is an unsigned long. And gcc is right this time.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 64dc93f..a32ebfe 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4104,8 +4104,8 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
 
 	return eb;
 err:
-	for (i--; i >= 0; i--)
-		__free_page(eb->pages[i]);
+	for (; i > 0; i--)
+		__free_page(eb->pages[i - 1]);
 	__free_extent_buffer(eb);
 	return NULL;
 }
-- 
1.7.12.3


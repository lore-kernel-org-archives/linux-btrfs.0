Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36390 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2HNHt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 03:49:26 -0400
Received: by yhmm54 with SMTP id m54so93198yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 00:49:26 -0700 (PDT)
Message-ID: <502A02F5.50909@gmail.com>
Date: Tue, 14 Aug 2012 15:49:09 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: correct the comment for extent_io.c/clear_extent_bits
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be "clear" instead of "set" for clear_extent_bits.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index ebb35b2..638ee0e 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -195,7 +195,7 @@ static int clear_state_bit(struct extent_io_tree *tree,
 }
 
 /*
- * set some bits on a range in the tree.
+ * clear some bits on a range in the tree.
  */
 int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 		      u64 end, int bits, gfp_t mask)
-- 
1.7.1


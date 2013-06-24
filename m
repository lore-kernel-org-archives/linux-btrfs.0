Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:35378 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3FXHRF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 03:17:05 -0400
Received: by mail-yh0-f41.google.com with SMTP id z20so4738775yhz.14
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 00:17:03 -0700 (PDT)
Message-ID: <51C7F09B.1020302@gmail.com>
Date: Mon, 24 Jun 2013 15:09:15 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix the comment for extent_io.c/clear_extent_bits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be 'clear', not 'set'.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  extent_io.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent_io.c b/extent_io.c
index 5093aeb..8f51250 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -197,7 +197,7 @@ static int clear_state_bit(struct extent_io_tree *tree,
  }

  /*
- * set some bits on a range in the tree.
+ * clear some bits on a range in the tree.
   */
  int clear_extent_bits(struct extent_io_tree *tree, u64 start,
  		      u64 end, int bits, gfp_t mask)
-- 
1.7.10.4


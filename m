Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58023 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2HPOyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 10:54:09 -0400
Received: by ggdk6 with SMTP id k6so2981668ggd.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 07:54:08 -0700 (PDT)
Message-ID: <502D0986.8050202@gmail.com>
Date: Thu, 16 Aug 2012 22:53:58 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix trivial typo for the comment of BTRFS_FREE_INO_OBJECTID
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be "storing".

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ctree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4bab807..f9289db 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -116,7 +116,7 @@ struct btrfs_ordered_sum;
 #define BTRFS_FREE_SPACE_OBJECTID -11ULL
 
 /*
- * The inode number assigned to the special inode for sotring
+ * The inode number assigned to the special inode for storing
  * free ino cache
  */
 #define BTRFS_FREE_INO_OBJECTID -12ULL
-- 
1.7.1

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2HPOyW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 10:54:22 -0400
Received: by pbbrr13 with SMTP id rr13so1693020pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 07:54:21 -0700 (PDT)
Message-ID: <502D0999.4060302@gmail.com>
Date: Thu, 16 Aug 2012 22:54:17 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix trivial typo for the comment of BTRFS_FREE_INO_OBJECTID
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be "storing".

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 ctree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ctree.h b/ctree.h
index d218b88..8f3cd7e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -86,7 +86,7 @@ struct btrfs_trans_handle;
 #define BTRFS_FREE_SPACE_OBJECTID -11ULL
 
 /*
- * The inode number assigned to the special inode for sotring
+ * The inode number assigned to the special inode for storing
  * free ino cache
  */
 #define BTRFS_FREE_INO_OBJECTID -12ULL
-- 
1.7.1

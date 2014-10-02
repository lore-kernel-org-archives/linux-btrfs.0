Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaJBQuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 93140AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:02 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 04/14] btrfs: remove unused extent state bits
Date: Thu,  2 Oct 2014 18:50:02 +0200
Message-Id: <01d5bc3789f8464abd13cc44e3cd6df9d17f2802.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The last users are long gone.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5e91fb9d1764..1e06f0e4a185 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -11,8 +11,6 @@
 #define EXTENT_NEW (1 << 4)
 #define EXTENT_DELALLOC (1 << 5)
 #define EXTENT_DEFRAG (1 << 6)
-#define EXTENT_DEFRAG_DONE (1 << 7)
-#define EXTENT_BUFFER_FILLED (1 << 8)
 #define EXTENT_BOUNDARY (1 << 9)
 #define EXTENT_NODATASUM (1 << 10)
 #define EXTENT_DO_ACCOUNTING (1 << 11)
@@ -34,7 +32,6 @@
 
 /* these are bit numbers for test/set bit */
 #define EXTENT_BUFFER_UPTODATE 0
-#define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
 #define EXTENT_BUFFER_CORRUPT 3
 #define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
@@ -57,7 +54,6 @@
  * map has page->private set to one.
  */
 #define EXTENT_PAGE_PRIVATE 1
-#define EXTENT_PAGE_PRIVATE_FIRST_PAGE 3
 
 struct extent_state;
 struct btrfs_root;
-- 
1.8.4.5


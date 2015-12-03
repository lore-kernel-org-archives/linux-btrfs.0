Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbbLCQ6d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:33 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AE496ADD8
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:58:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/12] btrfs: make clear_extent_buffer_uptodate return void
Date: Thu,  3 Dec 2015 17:56:42 +0100
Message-Id: <e2c9f804b9ea12263553373a2ce711ae986f1890.1449161602.git.dsterba@suse.com>
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
References: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does not return any errors, nor anything from the callgraph.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 +--
 fs/btrfs/extent_io.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 47db9069bf05..d5778e821d60 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5227,7 +5227,7 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 	return was_dirty;
 }
 
-int clear_extent_buffer_uptodate(struct extent_buffer *eb)
+void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	unsigned long i;
 	struct page *page;
@@ -5240,7 +5240,6 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 		if (page)
 			ClearPageUptodate(page);
 	}
-	return 0;
 }
 
 void set_extent_buffer_uptodate(struct extent_buffer *eb)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 013af0512f1a..ad1d28c1cfd4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -331,7 +331,7 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 void set_extent_buffer_uptodate(struct extent_buffer *eb);
-int clear_extent_buffer_uptodate(struct extent_buffer *eb);
+void clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_under_io(struct extent_buffer *eb);
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
-- 
2.6.2


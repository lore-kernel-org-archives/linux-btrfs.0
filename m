Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932551AbeDWXGQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 19:06:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 45E9BAC92
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 23:06:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: simplify counting number of eb pages
Date: Tue, 24 Apr 2018 01:03:42 +0200
Message-Id: <faf2e8e2cb4f87f4b418b177256d8950cd8deba1.1524523682.git.dsterba@suse.com>
In-Reply-To: <cover.1524523681.git.dsterba@suse.com>
References: <cover.1524523681.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The eb length is nodesize, as initialized in __alloc_extent_buffer.
Regardless of start, we should always get the same number of pages, so
use that fact.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a53009694b16..ee92c1289edd 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -454,8 +454,7 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline unsigned long num_extent_pages(u64 start, u64 len)
 {
-	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
-		(start >> PAGE_SHIFT);
+	return len >> PAGE_SHIFT;
 }
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
-- 
2.16.2


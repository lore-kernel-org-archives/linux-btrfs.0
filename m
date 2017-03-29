Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36811 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753026AbdC2Sta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 14:49:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2182AAC9A
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 18:49:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use clear_page where appropriate
Date: Wed, 29 Mar 2017 20:48:44 +0200
Message-Id: <20170329184844.8639-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a helper to clear whole page, with a arch-specific optimized
code. The replaced cases do not seem to be in performace critical code,
but we still might get some percent gain.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/scrub.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index da6841efac26..c5e6180cdb8c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -355,7 +355,7 @@ static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
 	io_ctl->orig = io_ctl->cur;
 	io_ctl->size = PAGE_SIZE;
 	if (clear)
-		memset(io_ctl->cur, 0, PAGE_SIZE);
+		clear_page(io_ctl->cur);
 }
 
 static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb1239f..08ae2331d402 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1634,7 +1634,7 @@ static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
 	if (spage->io_error) {
 		void *mapped_buffer = kmap_atomic(spage->page);
 
-		memset(mapped_buffer, 0, PAGE_SIZE);
+		clear_page(mapped_buffer);
 		flush_dcache_page(spage->page);
 		kunmap_atomic(mapped_buffer);
 	}
-- 
2.12.0


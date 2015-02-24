Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35708 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbbBXKra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 05:47:30 -0500
Received: by padfa1 with SMTP id fa1so35231375pad.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 02:47:29 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 2/3] btrfs: fix race on ENOMEM in alloc_extent_buffer
Date: Tue, 24 Feb 2015 02:47:05 -0800
Message-Id: <bb30d69d671243192fb08002b31375e55afe9644.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
References: <cover.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Consider the following interleaving of overlapping calls to
alloc_extent_buffer:

Call 1:

- Successfully allocates a few pages with find_or_create_page
- find_or_create_page fails, goto free_eb
- Unlocks the allocated pages

Call 2:
- Calls find_or_create_page and gets a page in call 1's extent_buffer
- Finds that the page is already associated with an extent_buffer
- Grabs a reference to the half-written extent_buffer and calls
  mark_extent_buffer_accessed on it

mark_extent_buffer_accessed will then try to call mark_page_accessed on
a null page and panic.

The fix is to decrement the reference count on the half-written
extent_buffer before unlocking the pages so call 2 won't use it. We
should also set exists = NULL in the case that we don't use exists to
avoid accidentally returning a freed extent_buffer in an error case.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c7233ff..7ecfae0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4867,6 +4867,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 				mark_extent_buffer_accessed(exists, p);
 				goto free_eb;
 			}
+			exists = NULL;
 
 			/*
 			 * Do this so attach doesn't complain and we need to
@@ -4930,12 +4931,12 @@ again:
 	return eb;
 
 free_eb:
+	WARN_ON(!atomic_dec_and_test(&eb->refs));
 	for (i = 0; i < num_pages; i++) {
 		if (eb->pages[i])
 			unlock_page(eb->pages[i]);
 	}
 
-	WARN_ON(!atomic_dec_and_test(&eb->refs));
 	btrfs_release_extent_buffer(eb);
 	return exists;
 }
-- 
2.3.0


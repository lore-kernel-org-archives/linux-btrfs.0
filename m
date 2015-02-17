Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40784 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbBQSoS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 13:44:18 -0500
Received: by paceu11 with SMTP id eu11so8249999pac.7
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 10:44:17 -0800 (PST)
Date: Tue, 17 Feb 2015 10:44:15 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: handle race on ENOMEM in alloc_extent_buffer
Message-ID: <20150217184415.GA3297@mew>
References: <cover.1424168589.git.osandov@osandov.com>
 <4fcdbbd7d6dc95598323b46dcf5db4356cb7dee8.1424168589.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4fcdbbd7d6dc95598323b46dcf5db4356cb7dee8.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 17, 2015 at 02:51:08AM -0800, Omar Sandoval wrote:
> Consider the following interleaving of overlapping calls to
> alloc_extent_buffer:
> 
> Call 1:
> 
> - Successfully allocates a few pages with find_or_create_page
> - find_or_create_page fails, goto free_eb
> - Unlocks the allocated pages
> 
> Call 2:
> - Calls find_or_create_page and gets a page in call 1's extent_buffer
> - Finds that the page is already associated with an extent_buffer
> - Grabs a reference to the half-written extent_buffer and calls
>   mark_extent_buffer_accessed on it
> 
> mark_extent_buffer_accessed will then try to call mark_page_accessed on
> a null page and panic.
> 
> The fix is to clear page->private of the half-written extent_buffer's
> pages all at once while holding mapping->private_lock.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  fs/btrfs/extent_io.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
[snip]

Actually, I just realized that there's a simpler fix. I can resend the
whole series for easier merging once I get some review, but for now,
here's what I'm talking about:


btrfs: handle race on ENOMEM in alloc_extent_buffer

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
extent_buffer before unlocking the pages so call 2 won't use it. We also
set exists = NULL in the case that we don't use exists to avoid
accidentally returning a freed extent_buffer in an error case.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 790dbae..6b3cd72 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4850,6 +4850,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 				mark_extent_buffer_accessed(exists, p);
 				goto free_eb;
 			}
+			exists = NULL;
 
 			/*
 			 * Do this so attach doesn't complain and we need to
@@ -4913,12 +4914,12 @@ again:
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
Omar

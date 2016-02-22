Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:45266 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752383AbcBVAh6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:37:58 -0500
Message-ID: <1456101474.31061.16.camel@perches.com>
Subject: Re: [PATCH] Btrfs: compression: added line after variable
 declaration
From: Joe Perches <joe@perches.com>
To: Philippe Loctaux <phil@philippeloctaux.com>, clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Feb 2016 16:37:54 -0800
In-Reply-To: <1456097209-3916-1-git-send-email-phil@philippeloctaux.com>
References: <1456097209-3916-1-git-send-email-phil@philippeloctaux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2016-02-22 at 00:26 +0100, Philippe Loctaux wrote:
> Added line after variable declaration, fixing checkpatch warning.
[]
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
[]
> @@ -522,6 +522,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  
>  			if (zero_offset) {
>  				int zeros;
> +
>  				zeros = PAGE_CACHE_SIZE - zero_offset;
>  				userpage = kmap_atomic(page);
>  				memset(userpage + zero_offset, 0, zeros);

This zeros temporary is used once.
Perhaps it should just be removed instead.

Maybe the userpage declaration should move too.

Something like:
---
 fs/btrfs/compression.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3346cd8..be41f83 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -517,14 +517,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		free_extent_map(em);
 
 		if (page->index == end_index) {
-			char *userpage;
 			size_t zero_offset = isize & (PAGE_CACHE_SIZE - 1);
 
 			if (zero_offset) {
-				int zeros;
-				zeros = PAGE_CACHE_SIZE - zero_offset;
-				userpage = kmap_atomic(page);
-				memset(userpage + zero_offset, 0, zeros);
+				char *userpage = kmap_atomic(page);
+
+				memset(userpage + zero_offset, 0,
+				       PAGE_CACHE_SIZE - zero_offset);
 				flush_dcache_page(page);
 				kunmap_atomic(userpage);
 			}


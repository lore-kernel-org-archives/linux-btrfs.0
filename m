Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:47356 "EHLO
	17.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbcBVAnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:43:37 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 0587B115019C
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 01:43:36 +0100 (CET)
Date: Mon, 22 Feb 2016 01:43:33 +0100
From: Philippe Loctaux <phil@philippeloctaux.com>
To: Joe Perches <joe@perches.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: compression: added line after variable declaration
Message-ID: <20160222004333.GA16775@carbon.home>
References: <1456097209-3916-1-git-send-email-phil@philippeloctaux.com>
 <1456101474.31061.16.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1456101474.31061.16.camel@perches.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, I see now :)
I'll try your changes and tell if they work or not :)

--
Philippe Loctaux
phil@philippeloctaux.com


On Sun, Feb 21, 2016 at 04:37:54PM -0800, Joe Perches wrote:
> On Mon, 2016-02-22 at 00:26 +0100, Philippe Loctaux wrote:
> > Added line after variable declaration, fixing checkpatch warning.
> []
> > diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> []
> > @@ -522,6 +522,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
> >  
> >  			if (zero_offset) {
> >  				int zeros;
> > +
> >  				zeros = PAGE_CACHE_SIZE - zero_offset;
> >  				userpage = kmap_atomic(page);
> >  				memset(userpage + zero_offset, 0, zeros);
> 
> This zeros temporary is used once.
> Perhaps it should just be removed instead.
> 
> Maybe the userpage declaration should move too.
> 
> Something like:
> ---
>  fs/btrfs/compression.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 3346cd8..be41f83 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -517,14 +517,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  		free_extent_map(em);
>  
>  		if (page->index == end_index) {
> -			char *userpage;
>  			size_t zero_offset = isize & (PAGE_CACHE_SIZE - 1);
>  
>  			if (zero_offset) {
> -				int zeros;
> -				zeros = PAGE_CACHE_SIZE - zero_offset;
> -				userpage = kmap_atomic(page);
> -				memset(userpage + zero_offset, 0, zeros);
> +				char *userpage = kmap_atomic(page);
> +
> +				memset(userpage + zero_offset, 0,
> +				       PAGE_CACHE_SIZE - zero_offset);
>  				flush_dcache_page(page);
>  				kunmap_atomic(userpage);
>  			}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

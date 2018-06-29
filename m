Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934210AbeF2O3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 10:29:50 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53632AE9F
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 14:29:49 +0000 (UTC)
Date: Fri, 29 Jun 2018 16:29:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/14] btrfs: pass only eb to num_extent_pages
Message-ID: <20180629142947.GU2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1530262400.git.dsterba@suse.com>
 <6dcc9a3bbb003dff2feff4328d27e5bf88b21e9d.1530262400.git.dsterba@suse.com>
 <52aa9c57-4e7c-1421-2c13-e1d114eeb112@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52aa9c57-4e7c-1421-2c13-e1d114eeb112@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 12:08:10PM +0300, Nikolay Borisov wrote:
> >  	for (i = 0; i < num_pages; i++)
> >  		copy_page(page_address(dst->pages[i]),
> >  				page_address(src->pages[i]));
> > diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> > index 0bfd4aeb822d..d8382a4a7f46 100644
> > --- a/fs/btrfs/extent_io.h
> > +++ b/fs/btrfs/extent_io.h
> > @@ -440,10 +440,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
> >  			     int mirror_num);
> >  void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
> >  
> > -static inline unsigned long num_extent_pages(u64 start, u64 len)
> > +static inline unsigned long num_extent_pages(const struct extent_buffer *eb)
> >  {
> > -	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
> > -		(start >> PAGE_SHIFT);
> > +	return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
> > +		(eb->start >> PAGE_SHIFT);
> 
> This is a good opportunity to eliminate the open-coded round_up:
> 
> round_up(eb->start + eb->len, PAGE_SIZE)

Ok, I'll add this patch:

@@ -442,8 +442,8 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline int num_extent_pages(const struct extent_buffer *eb)
 {
-       return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
-               (eb->start >> PAGE_SHIFT);
+       return (round_up(eb->start + eb->len, PAGE_SIZE) >> PAGE_SHIFT) -
+              (eb->start >> PAGE_SHIFT);
 }
 
 static inline void extent_buffer_get(struct extent_buffer *eb)

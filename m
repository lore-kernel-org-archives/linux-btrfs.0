Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44366 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728139AbeIMAeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 20:34:00 -0400
Date: Wed, 12 Sep 2018 12:27:46 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip set_page_dirty if eb is dirty
Message-ID: <20180912192745.elkmdpl5hyrawxks@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1536703587-94565-1-git-send-email-bo.liu@linux.alibaba.com>
 <e74ad1e7-4b37-a1c6-596b-56dc4fcf96ba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e74ad1e7-4b37-a1c6-596b-56dc4fcf96ba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 09:37:20AM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.09.2018 01:06, Liu Bo wrote:
> > As long as @eb is marked with EXTENT_BUFFER_DIRTY, all of its pages
> > are dirty, so no need to set pages dirty again.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> 
> Does make it any performance difference, numbers?
>

To be honest, the performance difference would be trivial in a normal
big test round.  But I just looked into the difference from my ftrace,
removing the loop can reduce the time spent by 10us in my box.

> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Thanks a lot for reviewing.

thanks,
-liubo
> > ---
> >  fs/btrfs/extent_io.c | 11 +++++++----
> >  fs/btrfs/extent_io.h |  2 +-
> >  2 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 628f1aef34b0..fb2bf50134a1 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -5165,11 +5165,11 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
> >  	WARN_ON(atomic_read(&eb->refs) == 0);
> >  }
> >  
> > -int set_extent_buffer_dirty(struct extent_buffer *eb)
> > +bool set_extent_buffer_dirty(struct extent_buffer *eb)
> >  {
> >  	int i;
> >  	int num_pages;
> > -	int was_dirty = 0;
> > +	bool was_dirty;
> >  
> >  	check_buffer_tree_ref(eb);
> >  
> > @@ -5179,8 +5179,11 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
> >  	WARN_ON(atomic_read(&eb->refs) == 0);
> >  	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
> >  
> > -	for (i = 0; i < num_pages; i++)
> > -		set_page_dirty(eb->pages[i]);
> > +	if (!was_dirty) {
> > +		for (i = 0; i < num_pages; i++)
> > +			set_page_dirty(eb->pages[i]);
> > +	}
> > +
> >  	return was_dirty;
> >  }
> >  
> > diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> > index b4d03e677e1d..f2ab42d57f02 100644
> > --- a/fs/btrfs/extent_io.h
> > +++ b/fs/btrfs/extent_io.h
> > @@ -479,7 +479,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> >  void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> >  				unsigned long pos, unsigned long len);
> >  void clear_extent_buffer_dirty(struct extent_buffer *eb);
> > -int set_extent_buffer_dirty(struct extent_buffer *eb);
> > +bool set_extent_buffer_dirty(struct extent_buffer *eb);
> >  void set_extent_buffer_uptodate(struct extent_buffer *eb);
> >  void clear_extent_buffer_uptodate(struct extent_buffer *eb);
> >  int extent_buffer_under_io(struct extent_buffer *eb);
> > 

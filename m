Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36358 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728139AbeIMAeh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 20:34:37 -0400
Date: Wed, 12 Sep 2018 12:28:25 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: assert page dirty bit
Message-ID: <20180912192824.3oyclzdpfiis7rqw@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
 <65915dec-83d5-d79b-c848-d1f4efce8bb8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <65915dec-83d5-d79b-c848-d1f4efce8bb8@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 09:38:49AM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.09.2018 01:06, Liu Bo wrote:
> > Just in case that someone breaks the rule that pages are dirty as long
> > as eb is dirty.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/btrfs/extent_io.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index fb2bf50134a1..99895f196ecb 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -5184,6 +5184,11 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
> >  			set_page_dirty(eb->pages[i]);
> >  	}
> >  
> > +#ifdef BTRFS_DEBUG
> 
> And this will never be compiled since the actual ifdef name is
> "CONFIG_BTRFS_DEBUG"
>

Oops, will fix it.

thanks,
-liubo

> > +	for (i = 0; i < num_pages; i++)
> > +		ASSERT(PageDirty(eb->pages[i]));
> > +#endif
> > +
> >  	return was_dirty;
> >  }
> >  
> > 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754473AbdDJPej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 11:34:39 -0400
Date: Mon, 10 Apr 2017 17:34:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About the behavior of inline extent
Message-ID: <20170410153437.GB4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <f9dc56cc-720e-0df1-f6c7-790e93276ee0@cn.fujitsu.com>
 <68B899DF-1EFE-4463-A3F8-BD03E0B811DC@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <68B899DF-1EFE-4463-A3F8-BD03E0B811DC@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 10:17:52AM -0400, Josef Bacik wrote:
> 
> > On Apr 9, 2017, at 11:27 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > 
> > Hi,
> > 
> > Recent btrfs/137 test case makes me wonder what's the designed behavior of btrfs inline data extent.
> > 
> > The current behavior in fact is quite a chaos.
> > We need a standard of how inline extent should behave.
> > 
> > 1) max_inline limit
> >   The problem of current max_inline is, it's never clear what it is
> >   limiting.
> > 
> >   For example, we don't allow page sized inline extent if not
> >   compressed.
> >   But we allow page sized inline extent if it's compressed.
> >   Is it just limiting size after compression?
> >   What if we really want to limit size before compression?
> > 
> 
> max_inline is for the actual space on disk.  Compression takes up less
> space, therefore you can fit bigger actual data into the inline area.

But in practice the other limits apply so we never inline file larger
than sectorsize. So the percieved behaviour is more like it's limit of
the file size, not the actual storage.

> > 2) inline extent condition
> >   Is inline extent allowed if we have following regular extent?
> > 
> >   For plain extent, prealloc can cause regular extent to co-exist with
> >   inlined one.
> >   While normal write will only convert inlined extent to regular one.
> > 
> >   While for compressed extent, it can co-exist with regular extent, by
> >   # xfs_io -f -c "pwrite 0 4k" -c sync -c "pwrite 4k 16k" /mnt/btrfs/file
> > 
> >   So which is the correct behavior?
> >   Personally I think we should not allow co-exist, as it's already
> >   causing a lot of fixes for it, that's to say neither current
> >   behavior is correct.
> 
> Historically we didn't have [inline][regular] because inline was
> always < block size, so any change to the inline extent to extend it
> resulted in a regular extent.  Obviously that changed with fallocate,
> so it is perfectly reasonable to have [inline][regular extent]

I'm not sure it's perfectly reasonable, makes things confusing. Does all
the extent handling code expect another extent after an inline?

In my understanding, more from the user's perspective, is that inline
extent covers entire file smaller than some limit, otherwise it's all
regular extents.

> > 3) inline extent and fallocate
> >   For inline extent, as long as we are calling fallocate inside the
> >   page size, only the isize is expanded.
> > 
> >   Only beyond page size, we get prealloc extents.
> >   (However inlined extent is still here, not converted)
> > 
> >   What's the designed behavior? Convert inline to regular or just
> >   leave it as is?
> 
> Leave it.

"Convert."

> fallocate doesn't change anything about existing regular
> extents.  Calling fallocate on a range completely inside of a regular
> extent does nothing, why would this change with an inline extent?

Because this leads to unexpected extent layout, contradicting what we've
told users for a long time.  Inline + regular does not bring anything
special anyway.

> Now
> past the inline extent you get a new extent, exactly the same behavior
> as a regular extent.  Thanks,


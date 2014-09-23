Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34450 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaIWNjq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 09:39:46 -0400
Date: Tue, 23 Sep 2014 21:39:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: add missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20140923133930.GC3337@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1411404065-767-1-git-send-email-fdmanana@suse.com>
 <20140923101439.GB3337@localhost.localdomain>
 <CAL3q7H41eCaj_8oEvLrUt9pqM_AxCYyTztkn5qzWDXuraxNoVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H41eCaj_8oEvLrUt9pqM_AxCYyTztkn5qzWDXuraxNoVg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 23, 2014 at 02:03:07PM +0100, Filipe David Manana wrote:
> On Tue, Sep 23, 2014 at 11:14 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Mon, Sep 22, 2014 at 05:41:04PM +0100, Filipe Manana wrote:
> >> If submit_extent_page() fails in write_one_eb(), we end up with the current
> >> page not marked dirty anymore, unlocked and marked for writeback. But we never
> >> end up calling end_page_writeback() against the page, which will make calls to
> >> filemap_fdatawait_range (e.g. at transaction commit time) hang forever waiting
> >> for the writeback bit to be cleared from the page.
> >>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >> ---
> >>  fs/btrfs/extent_io.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> >> index 3af4966..91f866c 100644
> >> --- a/fs/btrfs/extent_io.c
> >> +++ b/fs/btrfs/extent_io.c
> >> @@ -3668,6 +3668,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
> >>               if (ret) {
> >>                       set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
> >>                       SetPageError(p);
> >> +                     end_page_writeback(p);
> >
> > This is not always true, and it depends on the place where we get error in
> > submit_extent_page(), whether it has built and submitted a bio, if it's true,
> > case can be different as bio_endio will be called, and calling end_page_writeback()
> > again will end up with panic.
> 
> No, it's always true when the caller is write_one_eb(). If
> submit_extent_page() returns an error, we're sure that the page wasn't
> added to a bio, because bio_ret is always not NULL (but *bio_ret can
> be). Also, if we call submit_one_bio() in submit_extent_page() (first
> if statement) , we know that the bio doesn't contain the page.

I see, you're right.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
-liubo

> 
> thanks
> 
> >
> > thanks,
> > -liubo
> >
> >>                       if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
> >>                               end_extent_buffer_writeback(eb);
> >>                       ret = -EIO;
> >> --
> >> 1.9.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."

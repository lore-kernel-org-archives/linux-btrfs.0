Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22290 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbdBFQ1D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 11:27:03 -0500
Date: Mon, 6 Feb 2017 08:26:54 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: takafumi-sslab <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20170206162654.GA15505@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
 <20161222062044.GC11373@localhost.localdomain>
 <a90bf4a2-ca72-26c2-10f3-d38a3106dc6a@sslab.ics.keio.ac.jp>
 <20170130200858.GA10490@localhost.localdomain>
 <83e8f70a-e8e2-2800-00e1-807401188e4d@sslab.ics.keio.ac.jp>
 <20170201161932.GA19291@localhost.localdomain>
 <b8fa6a68-72a8-b745-b71c-c25d89a7a911@sslab.ics.keio.ac.jp>
 <20170206033527.GA23573@localhost.localdomain>
 <fe79b315-196c-b981-5151-9c8cc1901632@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fe79b315-196c-b981-5151-9c8cc1901632@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2017 at 02:50:18PM +0900, takafumi-sslab wrote:
> 
> 
> On 2017/02/06 12:35, Liu Bo wrote:
> > a) __extent_writepage has handled the case when nr == 0.
> 
> Yes, I agree this.
> 
> > b) when nr == 1, the page is marked with writeback bit and added into a
> >     bio, thus we have bio_end to deal with page bits.
> 
> However, I don't think this is always correct,
> because, as I said before as the Error A, when (bio_ret == NULL or *bio_ret
> == NULL) and btrfs_bio_alloc() fails, the page is not added into a bio.
> Thus, bio_end does not deal with the page's bit, and the writeback bit
> remains with nr == 1.
> 
> To confirm this, I inject a fault to mimic the fail of btrfs_bio_alloc().
> I can reproduce the hang at the kernel ver4.10-rc7 that commit id is
> d5adbfcd5f7bcc6fa58a41c5c5ada0e5c826ce2c
> and  Ftrace log messages are like below
> 
> a.out-2867  : __extent_writepage: call __extent_writepage_io:
> page:0xffffea000006d200(writeback:0), nr:0, logged at just previous to line
> 3523 of extent_io.c
> a.out-2867  : __extent_writepage_io: call submit_extent_page:
> page:0xffffea000006d200(writeback:1), nr:0, bio_ret:0xffffc90003bd7d40,
> *bio_ret: (null), logged at just previous to line 3443 of extent_io.c
> a.out-2867  : submit_extent_page.isra.53: Mimic Error A: btrfs_bio_alloc()
> fails and submit_extent_page() return -ENOMEM, logged at just previous to
> line 2807 of extent_io.c
> a.out-2867  : __extent_writepage_io: after call submit_extent_page:
> page:0xffffea000006d200(writeback:1), nr:0, bio_ret:0xffffc90003bd7d40,
> *bio_ret: (null), logged at just next to line 3447 of extent_io.c
> a.out-2867  : __extent_writepage_io: nr == 1:
> page:0xffffea000006d200(writeback:1), nr:1, bio_ret:0xffffc90003de7d40,
> logged at just next to line 3456 of extent_io.c //nr == 1 and the writeback
> bit remains
> a.out-2867  : __extent_writepage: after call __extent_writepage_io:
> page:0xffffea000006d200(writeback:1), nr:1, logged at just next to line 3524
> of extent_io.c // __extent_writepage does not handle, because nr == 1
> ...
> sync-2868   : __filemap_fdatawait_range: wait_on_page_writeback:
> page:0xffffea000006d200, logged at just previous to line 404 of mm/filemap.c
> // Then, sync hangs

Thanks for the efforts to prove it, nice.  Obviously I missed that @nr
will even be bumped up by one if ENOMEM, so yes, we need to clear the
writeback bit.

But shouldn't @nr means nr_submitted_successfully?  If a submit fails,
it makes no senses to keep submitting subsequent parts.

Anyway, for now I think the proposed fix is good to solve the problem, so you
may add

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Sincerely,
> 
> -takafumi
> > 
> > So I don't think the patch is necessary for now.
> > 
> > But as I said, the fact (nr == 0 or 1) would be changed if the
> > subpagesize blocksize is supported.
> > 
> > Thanks,
> > 
> > -liubo
> > 
> > > Sincerely,
> > > 
> > > -takafumi
> > > > Thanks,
> > > > 
> > > > -liubo
> > > > > Sincerely,
> > > > > 
> > > > > On 2017/01/31 5:09, Liu Bo wrote:
> > > > > > On Fri, Jan 13, 2017 at 03:12:31PM +0900, takafumi-sslab wrote:
> > > > > > > Thanks for your replying.
> > > > > > > 
> > > > > > > I understand this bug is more complicated than I expected.
> > > > > > > I classify error cases under submit_extent_page() below
> > > > > > > 
> > > > > > > A: ENOMEM error at btrfs_bio_alloc() in submit_extent_page()
> > > > > > > I first assumed this case and sent the mail.
> > > > > > > When bio_ret is NULL, submit_extent_page() calls btrfs_bio_alloc().
> > > > > > > Then, btrfs_bio_alloc() may fail and submit_extent_page() returns -ENOMEM.
> > > > > > > In this case, bio_endio() is not called and the page's writeback bit
> > > > > > > remains.
> > > > > > > So, there is a need to call end_page_writeback() in the error handling.
> > > > > > > 
> > > > > > > B: errors under submit_one_bio() of submit_extent_page()
> > > > > > > Errors that occur under submit_one_bio() handles at bio_endio(), and
> > > > > > > bio_endio() would call end_page_writeback().
> > > > > > > 
> > > > > > > Therefore, as you mentioned in the last mail, simply adding
> > > > > > > end_page_writeback() like my last email and commit 55e3bd2e0c2e1 can
> > > > > > > conflict in the case of B.
> > > > > > > To avoid such conflict, one easy solution is adding PageWriteback() check
> > > > > > > too.
> > > > > > > 
> > > > > > > How do you think of this solution?
> > > > > > (sorry for the late reply.)
> > > > > > 
> > > > > > I think its caller, "__extent_writepage", has covered the above case
> > > > > > by setting page writeback again.
> > > > > > 
> > > > > > Thanks,
> > > > > > 
> > > > > > -liubo
> > > > > > > Sincerely,
> > > > > > > 
> > > > > > > On 2016/12/22 15:20, Liu Bo wrote:
> > > > > > > > On Fri, Dec 16, 2016 at 03:41:50PM +0900, Takafumi Kubota wrote:
> > > > > > > > > This is actually inspired by Filipe's patch(55e3bd2e0c2e1).
> > > > > > > > > 
> > > > > > > > > When submit_extent_page() in __extent_writepage_io() fails,
> > > > > > > > > Btrfs misses clearing a writeback bit of the failed page.
> > > > > > > > > This causes the false under-writeback page.
> > > > > > > > > Then, another sync task hangs in filemap_fdatawait_range(),
> > > > > > > > > because it waits the false under-writeback page.
> > > > > > > > > 
> > > > > > > > > CPU0                            CPU1
> > > > > > > > > 
> > > > > > > > > __extent_writepage_io()
> > > > > > > > >       ret = submit_extent_page() // fail
> > > > > > > > > 
> > > > > > > > >       if (ret)
> > > > > > > > >         SetPageError(page)
> > > > > > > > >         // miss clearing the writeback bit
> > > > > > > > > 
> > > > > > > > >                                     sync()
> > > > > > > > >                                       ...
> > > > > > > > >                                       filemap_fdatawait_range()
> > > > > > > > >                                         wait_on_page_writeback(page);
> > > > > > > > >                                         // wait the false under-writeback page
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
> > > > > > > > > ---
> > > > > > > > >      fs/btrfs/extent_io.c | 4 +++-
> > > > > > > > >      1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > > > > > > > index 1e67723..ef9793b 100644
> > > > > > > > > --- a/fs/btrfs/extent_io.c
> > > > > > > > > +++ b/fs/btrfs/extent_io.c
> > > > > > > > > @@ -3443,8 +3443,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
> > > > > > > > >      					 bdev->bio, max_nr,
> > > > > > > > >      					 end_bio_extent_writepage,
> > > > > > > > >      					 0, 0, 0, false);
> > > > > > > > > -		if (ret)
> > > > > > > > > +		if (ret) {
> > > > > > > > >      			SetPageError(page);
> > > > > > > > > +			end_page_writeback(page);
> > > > > > > > > +		}
> > > > > > > > OK...this could be complex as we don't know which part in
> > > > > > > > submit_extent_page gets the error, if the page has been added into bio
> > > > > > > > and bio_end would call end_page_writepage(page) as well, so whichever
> > > > > > > > comes later, the BUG() in end_page_writeback() would complain.
> > > > > > > > 
> > > > > > > > Looks like commit 55e3bd2e0c2e1 also has the same problem although I
> > > > > > > > gave it my reviewed-by.
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > 
> > > > > > > > -liubo
> > > > > > > > 
> > > > > > > > >      		cur = cur + iosize;
> > > > > > > > >      		pg_offset += iosize;
> > > > > > > > > -- 
> > > > > > > > > 1.9.3
> > > > > > > > > 
> > > > > > > > > --
> > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > -- 
> > > > > > > Keio University
> > > > > > > System Software Laboratory
> > > > > > > Takafumi Kubota
> > > > > > > takafumi.kubota1012@sslab.ics.keio.jp
> > > > > > > 
> > > > > -- 
> > > > > Keio University
> > > > > System Software Laboratory
> > > > > Takafumi Kubota
> > > > > takafumi.kubota1012@sslab.ics.keio.jp
> > > > > 
> > > -- 
> > > Keio University
> > > System Software Laboratory
> > > Takafumi Kubota
> > > takafumi.kubota1012@sslab.ics.keio.jp
> > > 
> 
> -- 
> Keio University
> System Software Laboratory
> Takafumi Kubota
> takafumi.kubota1012@sslab.ics.keio.jp
> 

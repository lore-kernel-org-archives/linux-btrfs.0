Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31043 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdBAQVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 11:21:30 -0500
Date: Wed, 1 Feb 2017 08:19:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: takafumi-sslab <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org, fdmanana@suse.com, naota@elisp.net
Subject: Re: [PATCH] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20170201161932.GA19291@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
 <20161222062044.GC11373@localhost.localdomain>
 <a90bf4a2-ca72-26c2-10f3-d38a3106dc6a@sslab.ics.keio.ac.jp>
 <20170130200858.GA10490@localhost.localdomain>
 <83e8f70a-e8e2-2800-00e1-807401188e4d@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83e8f70a-e8e2-2800-00e1-807401188e4d@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 01, 2017 at 12:27:24PM +0900, takafumi-sslab wrote:
> Thanks for your reply.
> 
> I think you mentioned about the below if-block in __extent_writepage().
> 
> if (nr == 0) {
>         /* make sure the mapping tag for page dirty gets cleared */
>         set_page_writeback(page);
>         end_page_writeback(page);
> }

Right.

> 
> However, this if-block only works when nr is 0, and does not work in the
> case we indicated.
> According to the below codes that we excerpt from __extent_writepage_io(),
> nr is incremented even if submit_extent_page() fails.
> Therefore, we should safely clear the writeback bit in the error handling
> after the fail of submit_extent_page() call
> 
>     while (cur <= end) {
>         ...
>         ret = submit_extent_page(...);
>         if (ret)
>             SetPageError(page);
> 
>         cur = cur + iosize;
>         pg_offset += iosize;
>         nr++;
>     }
> done:
>     *nr_ret = nr; // *nr_ret is nr of __extent_writepage()

It'd be either nr == 0 or nr == 1,

right now (nr > 1) couldn't happen on btrfs because it assumes
blocksize == PAGE_SIZE, so we could only submit_extent_page once for
each page, and bio_ret is used to batch bio submit.

(But it could be changed after subpagesize block patchset, and there is
more work rather than just adding a end_page_writeback, e.g. writepage
endio also needs to be updated).

Thanks,

-liubo
> 
> Sincerely,
> 
> On 2017/01/31 5:09, Liu Bo wrote:
> > On Fri, Jan 13, 2017 at 03:12:31PM +0900, takafumi-sslab wrote:
> > > Thanks for your replying.
> > > 
> > > I understand this bug is more complicated than I expected.
> > > I classify error cases under submit_extent_page() below
> > > 
> > > A: ENOMEM error at btrfs_bio_alloc() in submit_extent_page()
> > > I first assumed this case and sent the mail.
> > > When bio_ret is NULL, submit_extent_page() calls btrfs_bio_alloc().
> > > Then, btrfs_bio_alloc() may fail and submit_extent_page() returns -ENOMEM.
> > > In this case, bio_endio() is not called and the page's writeback bit
> > > remains.
> > > So, there is a need to call end_page_writeback() in the error handling.
> > > 
> > > B: errors under submit_one_bio() of submit_extent_page()
> > > Errors that occur under submit_one_bio() handles at bio_endio(), and
> > > bio_endio() would call end_page_writeback().
> > > 
> > > Therefore, as you mentioned in the last mail, simply adding
> > > end_page_writeback() like my last email and commit 55e3bd2e0c2e1 can
> > > conflict in the case of B.
> > > To avoid such conflict, one easy solution is adding PageWriteback() check
> > > too.
> > > 
> > > How do you think of this solution?
> > (sorry for the late reply.)
> > 
> > I think its caller, "__extent_writepage", has covered the above case
> > by setting page writeback again.
> > 
> > Thanks,
> > 
> > -liubo
> > > Sincerely,
> > > 
> > > On 2016/12/22 15:20, Liu Bo wrote:
> > > > On Fri, Dec 16, 2016 at 03:41:50PM +0900, Takafumi Kubota wrote:
> > > > > This is actually inspired by Filipe's patch(55e3bd2e0c2e1).
> > > > > 
> > > > > When submit_extent_page() in __extent_writepage_io() fails,
> > > > > Btrfs misses clearing a writeback bit of the failed page.
> > > > > This causes the false under-writeback page.
> > > > > Then, another sync task hangs in filemap_fdatawait_range(),
> > > > > because it waits the false under-writeback page.
> > > > > 
> > > > > CPU0                            CPU1
> > > > > 
> > > > > __extent_writepage_io()
> > > > >     ret = submit_extent_page() // fail
> > > > > 
> > > > >     if (ret)
> > > > >       SetPageError(page)
> > > > >       // miss clearing the writeback bit
> > > > > 
> > > > >                                   sync()
> > > > >                                     ...
> > > > >                                     filemap_fdatawait_range()
> > > > >                                       wait_on_page_writeback(page);
> > > > >                                       // wait the false under-writeback page
> > > > > 
> > > > > Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
> > > > > ---
> > > > >    fs/btrfs/extent_io.c | 4 +++-
> > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > > > index 1e67723..ef9793b 100644
> > > > > --- a/fs/btrfs/extent_io.c
> > > > > +++ b/fs/btrfs/extent_io.c
> > > > > @@ -3443,8 +3443,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
> > > > >    					 bdev->bio, max_nr,
> > > > >    					 end_bio_extent_writepage,
> > > > >    					 0, 0, 0, false);
> > > > > -		if (ret)
> > > > > +		if (ret) {
> > > > >    			SetPageError(page);
> > > > > +			end_page_writeback(page);
> > > > > +		}
> > > > OK...this could be complex as we don't know which part in
> > > > submit_extent_page gets the error, if the page has been added into bio
> > > > and bio_end would call end_page_writepage(page) as well, so whichever
> > > > comes later, the BUG() in end_page_writeback() would complain.
> > > > 
> > > > Looks like commit 55e3bd2e0c2e1 also has the same problem although I
> > > > gave it my reviewed-by.
> > > > 
> > > > Thanks,
> > > > 
> > > > -liubo
> > > > 
> > > > >    		cur = cur + iosize;
> > > > >    		pg_offset += iosize;
> > > > > -- 
> > > > > 1.9.3
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

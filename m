Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50390 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdEIWus (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 18:50:48 -0400
Date: Tue, 9 May 2017 15:49:13 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6 RFC] utilize bio_clone_fast to clean up
Message-ID: <20170509224913.GG17312@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <20170505142447.GC10575@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170505142447.GC10575@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 04:24:47PM +0200, David Sterba wrote:
> On Mon, Apr 17, 2017 at 06:16:21PM -0700, Liu Bo wrote:
> > This attempts to use bio_clone_fast() in the places where we clone bio,
> > such as when bio got cloned for multiple disks and when bio got split
> > during dio submit.
> > 
> > One benefit is to simplify dio submit to avoid calling bio_add_page one by
> > one.
> > 
> > Another benefit is that comparing to bio_clone_bioset, bio_clone_fast is
> > faster because of copying the vector pointer directly, and bio_clone_fast
> > doesn't modify bi_vcnt, so the extra work is to fix up bi_vcnt usage we
> > currently have to use bi_iter to iterate bvec.
> > 
> > Liu Bo (6):
> >   Btrfs: use bio_clone_fast to clone our bio
> 
> Please extend the changelog of this patch, use the text in the cover
> letter.
>

OK.

> >   Btrfs: use bio_clone_bioset_partial to simplify DIO submit
> 
> This patch is too big, can you split it to smaller chunks? I was not
> able to review it, it seems to touch several things at once, it's hard
> to keep the context.
>

Oh I see, the diff does look scary but the changes are in fact not
intrusive, I'll try to do something.

> >   Btrfs: change how we iterate bios in endio
> >   Btrfs: record error if one block has failed to retry
> >   Btrfs: change check-integrity to use bvec_iter
> >   Btrfs: unify naming of btrfs_io_bio
> 
> The rest looks ok.
> 
> Have you done perofrmance tests? Not that it's necessary, but would be
> interesting to see the effects. The effects of simplified code are
> likely unmeasurable, but the _fast version skips some mempool exercises
> so this could lead to improvements under memory pressure. And these is
> hardly deterministic conditions, could be hard. I'me expecting some
> latency improvemtnest.

I haven't done the perf. test since it is a RFC that I basically hope
to check whether the idea makes sense.

And yes, using bio_clone_fas could save us some memory which is
allocated for bio->bi_io_vec if (nr_iovecs > inline_vecs).

I'll do some tests to see if there is any perf. difference and drop a
notice to intel's test robot if they can do much broader perf. tests
against it.

Thank you for the comments.

Thanks,

-liubo

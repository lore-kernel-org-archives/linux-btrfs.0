Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752691AbeFIAfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 20:35:54 -0400
Date: Sat, 9 Jun 2018 02:33:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
Message-ID: <20180609003306.GJ3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
 <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 10:14:51PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年06月05日 22:07, David Sterba wrote:
> > On Tue, Jun 05, 2018 at 09:47:46PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2018年06月05日 21:42, David Sterba wrote:
> >>> On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
> >>>> Hi David,
> >>>>
> >>>> It would be pretty nice if we could get this fix (or previous RFC patch)
> >>>> to get into current release cycle.
> >>>>
> >>>> As it's a unrecoverable data corruption, it would be better to get it
> >>>> fixed as soon as possible.
> >>>
> >>> That we can do, I'm planning to send 2nd pull by the end of the next
> >>> week as there's at least one patch in the queue now.
> >>>
> >>> This patch seems to big, can you please prepare a minimal version?
> >>
> >> The previous version (a completely different direction though) is much
> >> smaller.
> >> https://patchwork.kernel.org/patch/10440541/
> >>
> >> However personally speaking, I still prefer this one, as it's much simpler.
> > 
> > As this will go to older stable kernels, I'd rather split that to more
> > patches where the first one is
> > 
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -2799,7 +2799,7 @@ static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
> >                         have_csum = scrub_find_csum(sctx, logical, csum);
> >                         if (have_csum == 0)
> >                                 ++sctx->stat.no_csum;
> > -                       if (sctx->is_dev_replace && !have_csum) {
> > +                       if (0 && sctx->is_dev_replace && !have_csum) {
> >                                 ret = copy_nocow_pages(sctx, logical, l,
> >                                                        mirror_num,
> >                                                       physical_for_dev_replace);
> > ---
> > 
> > and then the whole callchain of copy_nocow_pages continues.
> 
> Understood.
> I could go this method.

FYI, I'd need to send the 2nd pull request on Tuesday so I'm adding the
proposed fix with the current changelog to the queue now.

https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/commit/?h=next-fixes&id=8c83e0b1b20b094491bec6c52839aa3596a87f03

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50977 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbeFEO0y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 10:26:54 -0400
Date: Tue, 5 Jun 2018 16:24:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
Message-ID: <20180605142406.GD3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
 <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 10:14:51PM +0800, Qu Wenruo wrote:
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
> 
> However I'm a little concerned about such "if (0 &&" usage.
> 
> Although with gcc 8.1 it works without any warning, it still looks
> pretty strange, as compiler could one day detect such dead branch and
> find copy_nocow_pages() is never used.

I've checked that this does not produce any warnings, gcc 7.3.1. The
condition looks strange but does what we want. The whole series will be
in 4.18, the first patch in stable versions. If gcc does not warn today,
it will not in the future in any of the versions.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbdKXL1u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 06:27:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73A55AAC1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 11:27:49 +0000 (UTC)
Date: Fri, 24 Nov 2017 12:25:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Introduce macros to handle bytes and sector
 conversion
Message-ID: <20171124112553.GV3553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171124041008.32656-1-wqu@suse.com>
 <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 24, 2017 at 08:53:09AM +0200, Nikolay Borisov wrote:
> On 24.11.2017 06:10, Qu Wenruo wrote:
> > Since block I/O is always done in unit of 512 bytes, add BI_SECTOR_SIZE
> > and BI_SECTOR_SHIFT macros and to_sector() and to_bytes() for later
> > use.
> > 
> > Although the best position to define such things should be bvec.h, and
> > to_sector() to_bytes() are also defined in device-mapper.h, there are
> > a lot of code defining their own SECTOR_SIZE and to_bytes() in
> > device-mapper is not using u64 (unsigned long long) but unsigned long,
> > which doesn't fit btrfs usage.
> > 
> > So define btrfs' own macros and inlined converters.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >  fs/btrfs/ctree.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 8fc690384c58..8f6f57167661 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3734,4 +3734,17 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
> >  #endif
> >  	return 0;
> >  }
> > +
> > +#define BI_SECTOR_SHIFT		(9)
> > +#define BI_SECTOR_SIZE		(1 << BI_SECTOR_SHIFT)
> > +
> > +static inline u64 to_bytes(sector_t n)
> > +{
> > +	return ((u64)n << BI_SECTOR_SHIFT);
> > +}
> > +
> > +static inline sector_t to_sector(u64 n)
> > +{
> > +	return (n >> BI_SECTOR_SHIFT);
> > +}
> 
> nit: I don't like the naming, I'd rather have something similar to what
> xfs has for its conversion macros i.e:
> 
> XFS_FSS_TO_BB - filesystem sector to basic block (bb in this case is 512
> bytes)
> 
> so why not - BTRFS_B_TO_BB or BTRFS_B_TO_S and BTRFS_S_TO_B. Or
> something like that but just to_bytes and to_sector look a bit silly.
> It's not a big paint point but more of a "let's get the good ideas from
> other fsses"

I don't like the naming in the patch either, but I don't think we should
copy the xfs naming. There are differences in the building objects,
thers's nothing like a 'basic block' and thus BB in btrfs does not refer
to anything we know. It's fine for xfs as this has been there since the
beginning. The wordy_naming in btrfs is similar in that way and has been
part of the format (names of the on-disk structures etc), so we're past
the time to switch to something completely different.

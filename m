Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57655 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751501AbdF0RMR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 13:12:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE36BAB1E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 17:12:15 +0000 (UTC)
Date: Tue, 27 Jun 2017 19:11:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Optimise layout of btrfs_block_group_cache
Message-ID: <20170627171106.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1498488155-9941-1-git-send-email-nborisov@suse.com>
 <1498488155-9941-2-git-send-email-nborisov@suse.com>
 <da2bf011-533c-8af8-cc33-d15d5c18d5f8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da2bf011-533c-8af8-cc33-d15d5c18d5f8@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 06:30:34PM +0300, Nikolay Borisov wrote:
> 
> 
> On 26.06.2017 17:42, Nikolay Borisov wrote:
> > With this patch applied pahole stats look like:
> > 
> > /* size: 840, cachelines: 14, members: 40 */
> > /* sum members: 833, holes: 1, sum holes: 7 */
> > /* bit holes: 1, sum bit holes: 28 bits */
> > /* last cacheline: 8 bytes */
> > 
> > No functional changes.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >  fs/btrfs/ctree.h | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index cdd3775e930b..bdd06bbeb9aa 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -586,6 +586,11 @@ struct btrfs_block_group_cache {
> >  	unsigned int iref:1;
> >  	unsigned int has_caching_ctl:1;
> >  	unsigned int removed:1;
> > +	/*
> > +	 * Does the block group need to be added to the free space tree?
> > +	 * Protected by free_space_lock.
> > +	 */
> > +	unsigned int needs_free_space:1;
> Upon closer inspection of memory-barriers.txt I'm not confident in this
> change. This puts fields protected by different locks in the same
> bitfield which can lead to corrupted values.

Alternatively, you can switch the flags to unsigned long and access them
using set_bit/test_bit, they're atomic regarding updates.

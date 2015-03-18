Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbbCRNkC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:40:02 -0400
Date: Wed, 18 Mar 2015 14:40:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Thorarensen <sebth@naju.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <20150318134000.GY20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
 <20150316172800.GP20767@twin.jikos.cz>
 <alpine.DEB.2.02.1503180257380.3687@miria.naju.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1503180257380.3687@miria.naju.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 03:12:28AM +0100, Sebastian Thorarensen wrote:
> On Mon, 16 Mar 2015, David Sterba wrote:
> > > +static int ext2_free_block_range(ext2_filsys fs, u64 block, int num)
> > > +{
> > > +	BUG_ON(block != (blk_t)block);
> >
> > What's the purpose of this? Some kind of overflow check?
> 
> ext2_free_block contains the same check, so I put one in
> ext2_free_block_range for consistency. I assumed it was an overflow check
> as blk_t is u32.

Ok, keep it there so we don't forget. A better error handling is
desirable though.

> > Otherwise looks good. If you're going to resend, please split the patch
> > into one logical change per patch:
> > 
> > 1) generic and preparatory changes, like moving the check_node to
> > utils.c, moving the mkfs default leaf size
> > 
> > 2) the changes to convert, ie. most of this patch minus 1 and 3
> > 
> > 3) the tests
> 
> Thanks for the review! Will resend with the fixes when I know whether
> blocks[] must be aligned to nodesize or not.

As mentioned in the other mail, current implementation is fine.

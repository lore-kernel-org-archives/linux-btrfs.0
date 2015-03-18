Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbbCRNKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:10:12 -0400
Date: Wed, 18 Mar 2015 14:10:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Thorarensen <sebth@naju.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <20150318131009.GX20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
 <alpine.DEB.2.02.1503031249060.3687@miria.naju.se>
 <20150316173439.GQ20767@twin.jikos.cz>
 <alpine.DEB.2.02.1503180239540.3687@miria.naju.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1503180239540.3687@miria.naju.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 02:57:31AM +0100, Sebastian Thorarensen wrote:
> On Mon, 16 Mar 2015, David Sterba wrote:
> > I think it's right, however I'm not sure if there are any guarantees
> > about the range alignment. Btrfs should be fine with 4k (ie. sectorsize
> > which is PAGE_SIZE) alignment for a node, but this could lead to some
> > pathological layout and I'm not 100% sure the exact nodesize alignment
> > is not required somewhere.
> 
> Ah, I didn't think of that. Yes, ext2_alloc_block_range can allocate
> unaligned (with respect to nodesize) ranges.
> 
> I made a test with a conversion that resulted in unaligned blocks[], and
> neither btrfs check nor scrub complained on the converted filesystem, but
> I will do some research to find out whether blocks[] must be aligned or
> not.

Thanks for the test.

So far I haven't found any requirements for the exact nodesize alignment
for metadata blocsk, I think it's safe.

Given that the node allocation is opencoded inside convert, we can easily
add a fallback to request a bit larger range and satisfy the alignment.
This would leave the small unallocatable ranges behind and outside of
the btrfs' sight.

I'm fine with current code for first implementation.

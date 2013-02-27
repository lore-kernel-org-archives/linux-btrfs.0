Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33074 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab3B0UxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 15:53:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UAo0A-0007Pc-QJ
	for linux-btrfs@vger.kernel.org; Wed, 27 Feb 2013 21:53:22 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 21:53:22 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 21:53:22 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Swapfile on btrfs
Date: Wed, 27 Feb 2013 12:52:50 -0800
Message-ID: <kglrn1$cdu$1@ger.gmane.org>
References: <kgjad5$7kt$1@ger.gmane.org> <20130227175226.GM27541@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:

> On Tue, Feb 26, 2013 at 01:45:12PM -0800, Alex Elsayed wrote:
>> Hey, I was looking at the wiki 'unclaimed projects' list and I thought
>> I'd take a look at what might be needed to use the swap-over-n{fs,bd}
>> functionality in order to implement swapfile support. It *looks* like
>> it's surprisingly uncomplicated - to the point where I suspect I'm
>> missing something, and would like some sanity checking.
>> 
>> My primary references for this are the patch[1] implementing
>> swap-over-NFS and HEAD of cmason's for-linus branch.
> 
> The patch [1] is not enough to cook swap support for btrfs, have look at
> the rest of the series. There's some explanation how the interfaces look
> like. The read/write mechanism is done via direct_IO, but the filesystem
> has to add the swap_activate and swap_deactivate operations and take
> care of preallocating the swap file extents.
> 
> Details:
> 
> Analogy of these patches has to be done in btrfs as well:
> 
> d56b4ddf7781e	nfs: teach the NFS client how to treat PG_swapcache 
pages
> 29418aa4bd487	nfs: disable data cache revalidation for swapfiles
> 
> The patch you've analyzed in detail adds some nfs-specific bits, not the
> core work (and thus I don't disagree that it looks surprisingly
> uncomplicated :)
> 
> The generic swap support is demonstrated in
> 
> a509bc1a9e48	mm: swap: implement generic handler for 
swap_activate
> 
> and in case of btrfs it has to avoid using bmap.
> 
> Thanks for tackling this project, I think it's not an easy one. There
> are implications and API requirements that need to be taken into account
> wrt snapshots and stable block ranges during the file lifetime.  I have
> a few commetns about that from Mel and can share them if you still want
> to proceed with this project.
> 
> david

Thanks for the information! I probably will keep going on this, since at 
this point my disk basically boils down to an EFI system partition and a 
LUKS volume containing swap and btrfs over LVM. Being able to dwap the swap 
partition would let me drop LVM, and simplify my setup a little (along with 
letting me omit the LVM module from dracut).

It will, however, likely take a while - I'm not particularly skilled with C, 
and the kernel is still slightly magic in places, but I'm stubborn and pick 
up on patterns reasonably well so hopefully it'll get done eventually.

Also, in talking on IRC with Hugo Mills he helped me realize another issue - 
specifically, that a.) DIO to compressed data falls back to buffered IO, and 
b.) (at least according to the wiki) the compress_force mount option takes 
precedence over the NOCOMPRESS file flag.

Thinking about it further, I realized that individual extents could be 
compressed, at which point this could get rather onerous on swapon since we 
might well need to check each and every extent to make sure it isn't 
compressed.

Any suggestions?



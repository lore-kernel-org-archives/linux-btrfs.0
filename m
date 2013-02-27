Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035Ab3B0Rw3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 12:52:29 -0500
Date: Wed, 27 Feb 2013 18:52:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Swapfile on btrfs
Message-ID: <20130227175226.GM27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <kgjad5$7kt$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kgjad5$7kt$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 01:45:12PM -0800, Alex Elsayed wrote:
> Hey, I was looking at the wiki 'unclaimed projects' list and I thought I'd 
> take a look at what might be needed to use the swap-over-n{fs,bd} 
> functionality in order to implement swapfile support. It *looks* like it's 
> surprisingly uncomplicated - to the point where I suspect I'm missing 
> something, and would like some sanity checking.
> 
> My primary references for this are the patch[1] implementing swap-over-NFS 
> and HEAD of cmason's for-linus branch.

The patch [1] is not enough to cook swap support for btrfs, have look at
the rest of the series. There's some explanation how the interfaces look
like. The read/write mechanism is done via direct_IO, but the filesystem
has to add the swap_activate and swap_deactivate operations and take
care of preallocating the swap file extents.

Details:

Analogy of these patches has to be done in btrfs as well:

d56b4ddf7781e	nfs: teach the NFS client how to treat PG_swapcache pages
29418aa4bd487	nfs: disable data cache revalidation for swapfiles

The patch you've analyzed in detail adds some nfs-specific bits, not the
core work (and thus I don't disagree that it looks surprisingly
uncomplicated :)

The generic swap support is demonstrated in

a509bc1a9e48	mm: swap: implement generic handler for swap_activate

and in case of btrfs it has to avoid using bmap.

Thanks for tackling this project, I think it's not an easy one. There
are implications and API requirements that need to be taken into account
wrt snapshots and stable block ranges during the file lifetime.  I have
a few commetns about that from Mel and can share them if you still want
to proceed with this project.

david

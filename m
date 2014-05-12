Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbaELRKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 13:10:18 -0400
Date: Mon, 12 May 2014 19:10:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Russell Coker <russell@coker.com.au>,
        linux-btrfs@vger.kernel.org
Subject: Re: known UUID and metadata consistency
Message-ID: <20140512171017.GF6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201405111416.28012.russell@coker.com.au>
 <20140511091041.GA23212@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140511091041.GA23212@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 11, 2014 at 10:10:41AM +0100, Hugo Mills wrote:
> a) The chunk tree is whole and consistent
> b) We need to (or have been asked to) rebuild the chunk tree from scratch
> 
>    So I think, yes, you can make fake metadata blocks, but you have to
> rely on either (a) your fake data being written to exactly the right
> place and not overwritten by a balance, or (b) having the chunk tree
> broken and the admin looking for a usable set of metadata with
> btrfs-find-root and choosing your fake (with enough plausible complex
> data in it to fool them).
> 
>    I've probably missed loads of points here, but I think this is a
> good start for the conversation. :)

I think you've covered most of it.

One thing that looks as a show stopper is the fact that the fake data
blocks that would become the metadata blocks would lie out of any
metadata group. I'm not familiar with the chunk rebuilder, but this
seems as a simple check to do when it tries to guess the block group
layout from what it finds on disk.

Otherwise, faking the metadata block contents seems very fragile, we'd
need at least some knowledge where the block will end up in the key
space and also something about the adjacent blocks -- all must fit at
the time when the fsck will happen.

The logical offset of the block is incorporated in the metadata blocks
in the upper layers as a key and this propagates up the tree, so
replacing one block pointer would disrupt the key ordering, unless it's
at the beginning/end of a gap in the key space so it could point to a
data blockgroup.

Replacing a chain of nodes would need a correct parent transaction ids
that match the current state of the fs.

*more handwaving*

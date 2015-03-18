Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf1.bahnhof.se ([213.80.101.25]:49462 "EHLO mxf1.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbbCRB5k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 21:57:40 -0400
Date: Wed, 18 Mar 2015 02:57:31 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: David Sterba <dsterba@suse.cz>
cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
In-Reply-To: <20150316173439.GQ20767@twin.jikos.cz>
Message-ID: <alpine.DEB.2.02.1503180239540.3687@miria.naju.se>
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se> <alpine.DEB.2.02.1503031249060.3687@miria.naju.se> <20150316173439.GQ20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Mar 2015, David Sterba wrote:
> I think it's right, however I'm not sure if there are any guarantees
> about the range alignment. Btrfs should be fine with 4k (ie. sectorsize
> which is PAGE_SIZE) alignment for a node, but this could lead to some
> pathological layout and I'm not 100% sure the exact nodesize alignment
> is not required somewhere.

Ah, I didn't think of that. Yes, ext2_alloc_block_range can allocate
unaligned (with respect to nodesize) ranges.

I made a test with a conversion that resulted in unaligned blocks[], and
neither btrfs check nor scrub complained on the converted filesystem, but
I will do some research to find out whether blocks[] must be aligned or
not.

-- 
Sebastian Thorarensen

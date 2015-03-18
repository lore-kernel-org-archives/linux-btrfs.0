Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:65135 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467AbbCRCMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 22:12:37 -0400
Date: Wed, 18 Mar 2015 03:12:28 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: David Sterba <dsterba@suse.cz>
cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
In-Reply-To: <20150316172800.GP20767@twin.jikos.cz>
Message-ID: <alpine.DEB.2.02.1503180257380.3687@miria.naju.se>
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se> <20150316172800.GP20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Mar 2015, David Sterba wrote:
> > +static int ext2_free_block_range(ext2_filsys fs, u64 block, int num)
> > +{
> > +	BUG_ON(block != (blk_t)block);
>
> What's the purpose of this? Some kind of overflow check?

ext2_free_block contains the same check, so I put one in
ext2_free_block_range for consistency. I assumed it was an overflow check
as blk_t is u32.

> Otherwise looks good. If you're going to resend, please split the patch
> into one logical change per patch:
> 
> 1) generic and preparatory changes, like moving the check_node to
> utils.c, moving the mkfs default leaf size
> 
> 2) the changes to convert, ie. most of this patch minus 1 and 3
> 
> 3) the tests

Thanks for the review! Will resend with the fixes when I know whether
blocks[] must be aligned to nodesize or not.

-- 
Sebastian Thorarensen

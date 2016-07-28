Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34879 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbcG1ETG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 00:19:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so9258581wmg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 21:19:05 -0700 (PDT)
Date: Thu, 28 Jul 2016 00:18:47 -0400
From: Sanidhya Solanki <lkml.page@gmail.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
Message-ID: <20160728001847.481b7e77@ad>
In-Reply-To: <e0eb3366-7183-59b1-7cdc-3debd4e45b79@inwind.it>
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
	<f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
	<CAJCQCtTFGMku4FJZN7oH4=UV+F+Tz_FLD7RbUE5JWgaQKFtH4A@mail.gmail.com>
	<20160727021233.7e10ee48@ad>
	<e0eb3366-7183-59b1-7cdc-3debd4e45b79@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 27 Jul 2016 18:25:48 +0200
Goffredo Baroncelli <kreijack@inwind.it> wrote:
> I am not able to understand this sentence: on the best of my knowledge,
> in btrfs the RAID5/RAID6 stripe is composed by several sub-stripes (I am
> not sure about the terminology to adopt); the number of sub-stripe is equal 
> to the number of the disk.
> 
> Until now, in btrfs the size of sub-stripe is fixed to 64k, so the size
> of a stripe is equal to 64k * <number of disks>. So for raid5 the minimum
> stripe size is 192k, for raid6 is 256k.
> Why you are writing that the real stripe size is 4kb (may be that you are
> referring to the be the page size ?).

No problem with going over the details one more time. 
What I called and what was agreed to be called stripe size in the email sent
originally sent by Chris Murphy (link below) is actually how a single block 
of data is laid out on disk.

This number is a component of the stripe element size (which you called the
sub-stripe). This has nothing to do with how DIFFERENT but concurrent stripes
(which you defined as 64k * <number of disk>) of data are laid out on disk.
Their relation is such that they follow the order when they are read, but are
otherwise unrelated to each other. The correct way to look at a stripe is as
follows (with its current value before this patch in brackets):

Stripe Element Size (64 KiB) = 
	    Stripe size (1024B) * Number of elements per stripe element (64)

For the stripe code, the stripe element size matters, and for the metadata,
the stripe size matters.

The (64k * <number of disks>) is how concurrent stripes of data are distributed
across the RAID disks. The order is only important when performing an I/O 
operation.

Reference email: https://www.spinics.net/lists/linux-btrfs/msg57471.html

Hope this makes it simpler.

Sanidhya

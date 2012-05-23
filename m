Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45357 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab2EWTvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 15:51:00 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so5191512qcr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 12:51:00 -0700 (PDT)
Message-ID: <1337802657.3158.11.camel@ayu>
Subject: Re: SSD erase state and reducing SSD wear
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 23 May 2012 15:50:57 -0400
In-Reply-To: <jpj0l7$gd7$1@dough.gmane.org>
References: <jph1hu$2tq$1@dough.gmane.org> <1337746777.2479.9.camel@ayu>
	 <jpj0l7$gd7$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2012-05-23 at 16:44 +0100, Martin wrote:
> On 23/05/12 05:19, Calvin Walton wrote:
> > On Tue, 2012-05-22 at 22:47 +0100, Martin wrote:
> >> I've got two recent examples of SSDs. Their pristine state from the
> >> manufacturer shows:
> > 
> >> Device Model:     OCZ-VERTEX3
> >> 00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 
> >> Device Model:     OCZ VERTEX PLUS
> >> 00000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

> >> Can btrfs detect the erase state and pad unused space in filesystem
> >> writes with the same value so as to reduce SSD wear?

> > The benefit to doing this on the Vertex Plus is probably fairly small,
> > since to rewrite a block - even if the block is partially unwritten - is
> > still likely to require a read-modify-write cycle with an erase step.
> > The granularity of the erase blocks is just too big for the savings to
> > be very meaningful.
> 
> My understanding is that the 'wear' mechanism in flash is a problem of
> charge getting trapped in the insulation material itself that surrounds
> the floating gate of a cell. The permanently trapped charge accumulates
> further for each change of state until a high enough offset voltage has
> accumulated to exceed what can be tolerated for correct operation of the
> cell.
> 
> Hence, writing the *same value* as that for already stored for a cell
> should not cause any wear being as you are not changing the state of a
> cell. (No change in charge levels.)
> 
> For non-Sandforce controllers, that suggests doing a read-modify-write
> to pad out whatever minimum sized write chunk. That would be rather poor
> for performance, and the manufacturer's secrecy means we cannot be sure
> of the underlying write block size for minimum sized alignment.

It's very unlikely that the firmware in any modern high-performance SSD
would ever do an in-place read-modify-write sequence. If you write data
to the same sector on the disc twice, it is more likely to actually
write to two different places in the flash.

A flash erase block typically won't be re-used until all of the data
that had been in it gets rewritten somewhere else. The Indilinx
controller in the Vertex 1 drives have a garbage collector that runs in
the background to look for flash erase blocks that have been partially
rewritten, and consolidate the remaining data from multiple blocks into
one block to free new space for future writing.

> Alternatively, padding out writes with the erased state value means that
> no further wear should be caused for when that block is eventually
> TRIMed/erased for rewriting.

It is certainly possible that this could be the case. The difference is
likely to be fairly minimal. But unless you are an SSD manufacturer,
you'll probably never know how much actual difference it would make :)

-- 
Calvin Walton <calvin.walton@kepstin.ca>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49643 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab2EWPpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 11:45:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SXDk9-00034L-Sh
	for linux-btrfs@vger.kernel.org; Wed, 23 May 2012 17:44:57 +0200
Received: from cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com ([217.137.143.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 17:44:57 +0200
Received: from m_btrfs by cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 17:44:57 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: SSD erase state and reducing SSD wear
Date: Wed, 23 May 2012 16:44:39 +0100
Message-ID: <jpj0l7$gd7$1@dough.gmane.org>
References: <jph1hu$2tq$1@dough.gmane.org> <1337746777.2479.9.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <1337746777.2479.9.camel@ayu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/05/12 05:19, Calvin Walton wrote:
> On Tue, 2012-05-22 at 22:47 +0100, Martin wrote:
>> I've got two recent examples of SSDs. Their pristine state from the
>> manufacturer shows:
> 
>> Device Model:     OCZ-VERTEX3
>> 00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
>> Device Model:     OCZ VERTEX PLUS
>> 00000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
>> What's a good way to test what state they get erased to from a TRIM
>> operation?
> 
> This pristine state probably matches up with the result of a trim
> command on the drive. In particular, a freshly erased flash block is in
> a state where the bits are all 1, so the Vertex Plus drive is showing
> you the flash contents directly. The Vertex 3 has substantially more
> processing, and the 0s are effectively generated on the fly for unmapped
> flash blocks (similar to how the missing portions of a sparse file
> contains 0s).

So for that example of reading an 'empty' drive, the OCZ-VERTEX3 might
not even be reading the flash chips at all!...


>> Can btrfs detect the erase state and pad unused space in filesystem
>> writes with the same value so as to reduce SSD wear?
> 
> On the Vertex 3, this wouldn't actually do what you'd hope. The firmware
> in that drive actually compresses, deduplicates, and encrypts all the
> data prior to writing it to flash - and as a result the data that hits
> the flash looks nothing like what the filesystem wrote.
> (For best performance, it might make sense to disable btrfs's built-in
> compression on the Vertex 3 drive to allow the drive's compression to
> kick in. Let us know if you benchmark it either way.)

Very good comment, thanks. That leaves a very good question of how the
Sandforce controller uses the flash. Does it implement its own 'virtual
block level' interface to then use the underlying flash using structures
that are not visible externally?

What does that do to concerns about alignment?...

And for what granularity of write chunks?


> The benefit to doing this on the Vertex Plus is probably fairly small,
> since to rewrite a block - even if the block is partially unwritten - is
> still likely to require a read-modify-write cycle with an erase step.
> The granularity of the erase blocks is just too big for the savings to
> be very meaningful.

My understanding is that the 'wear' mechanism in flash is a problem of
charge getting trapped in the insulation material itself that surrounds
the floating gate of a cell. The permanently trapped charge accumulates
further for each change of state until a high enough offset voltage has
accumulated to exceed what can be tolerated for correct operation of the
cell.

Hence, writing the *same value* as that for already stored for a cell
should not cause any wear being as you are not changing the state of a
cell. (No change in charge levels.)

For non-Sandforce controllers, that suggests doing a read-modify-write
to pad out whatever minimum sized write chunk. That would be rather poor
for performance, and the manufacturer's secrecy means we cannot be sure
of the underlying write block size for minimum sized alignment.


Alternatively, padding out writes with the erased state value means that
no further wear should be caused for when that block is eventually
TRIMed/erased for rewriting.

That should also be a 'soft' option for the Sandforce controllers in
that /hopefully/ their compression/deduplication will compress down the
padding so as not to be a problem.

(Damn the Manufacturer's secrecy!)


Regards,
Martin





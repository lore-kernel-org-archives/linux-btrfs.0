Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54670 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbbLCG36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 01:29:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a4NOu-0006gq-A1
	for linux-btrfs@vger.kernel.org; Thu, 03 Dec 2015 07:29:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 07:29:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 07:29:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compression disk space saving - what are your results?
Date: Thu, 3 Dec 2015 06:29:50 +0000 (UTC)
Message-ID: <pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
	<CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
	<565F028C.6000707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 02 Dec 2015 09:39:08 -0500 as
excerpted:

> On 2015-12-02 09:03, Imran Geriskovan wrote:
>>>> What are your disk space savings when using btrfs with compression?
>>
>>> [Some] posters have reported that for mostly text, compress didn't
>>> give them expected compression results and they needed to use
>>> compress-force.
>>
>> "compress-force" option compresses regardless of the "compressibility"
>> of the file.
>>
>> "compress" option makes some inference about the "compressibility" and
>> decides to compress or not.
>>
>> I wonder how that inference is done?
>> Can anyone provide some pseudo code for it?

> I'm not certain how BTRFS does it, but my guess would be trying to
> compress the block, then storing the uncompressed version if the
> compressed one is bigger.

No pseudocode as I'm not a dev and wouldn't want to give the wrong 
impression, but as I believe I replied recently in another thread, based 
on comments the devs have made...

With compress, btrfs does a(n intended to be fast) trial compression of 
the first 128 KiB block or two and uses the result of that to decide 
whether to compress the entire file.

Compress-force simply bypasses that first decision point, processing the 
file as if the test always succeeded and compression was chosen.

If the decision to compress is made, the file is (evidently, again, not a 
dev, but filefrag results support) compressed a 128 KiB block at a time 
with the resulting size compared against the uncompressed version, with 
the smaller version stored.

(Filefrag doesn't understand btrfs compression and reports individual 
extents for each 128 KiB compression block, if compressed.  However, for 
many files processed with compress-force, filefrag doesn't report the 
expected size/128-KiB extents, but rather something lower.  If
filefrag -v is used, details of each "extent" are listed, and some show 
up as multiples of 128 KiB, indicating runs of uncompressable blocks that 
unlike actually compressed blocks, filefrag can and does report correctly 
as single extents.  The conclusion is thus as above, that btrfs is 
testing the compression result of each block, and not compressing if the 
"compression" ends up being negative, that is, if the "compressed" size 
is larger than the uncompressed size.)

> On a side note, I really wish BTRFS would just add LZ4 support.  It's a
> lot more deterministic WRT decompression time than LZO, gets a similar
> compression ratio, and runs faster on most processors for both
> compression and decompression.

There were patches (at least RFC level, IIRC) floating around years ago 
to add lz4... I wonder what happened to them?  My impression was that a 
large deployment somewhere may actually be running them as well, making 
them well tested (and obviously well beyond preliminary RFC level) by 
now, altho that impression could well be wrong.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


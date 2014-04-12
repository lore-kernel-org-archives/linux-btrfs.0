Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43541 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaDLRPG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 13:15:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZ1WB-0003uY-Rd
	for linux-btrfs@vger.kernel.org; Sat, 12 Apr 2014 19:15:03 +0200
Received: from ip4da2a5ae.direct-adsl.nl ([77.162.165.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 19:15:03 +0200
Received: from koen by ip4da2a5ae.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 19:15:03 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 12 Apr 2014 19:12:48 +0200
Message-ID: <libs6f$q4i$1@ger.gmane.org>
References: <2692878.dRG1K49eOP@fnix> <20140404150906.GR7442@carfax.org.uk> <20140412131710.GR7322@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20140412131710.GR7322@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Marc MERLIN schreef op 12-04-14 15:17:
> On Fri, Apr 04, 2014 at 04:09:06PM +0100, Hugo Mills wrote:
>>> - Generally speaking, does LZO compression improve or degrade
>>> performance ? I'm not able to figure it out clearly.
>> 
>> Yes, it improves or degrades performance. :)
>> 
>> It'll depend entirely on what you're doing with it. If you're storing
>> lots of zeroes (Phoronix, I'm looking at you), then you'll get huge
>> speedups. If you're storing video data, you'll get a (very) slight
>> performance drop as it scompresses the first few blocks of the file and
>> then gives up. I suspect that in general, the performance differences
>> won't be noticable unless you have highly compressible large files, but
>> if you _really_ care about it, benchmark it(*).
>> 
>> Hugo.
>> 
>> (*) If you don't want to go through the effort of benchmarking, you 
>> don't care enough about it, and should just pick something at random.
> 
> Speaking of this bit, I once tried to use zlib instead of lzo, and
> somehow it felt that my laptop on SSD booted noticeably slower after
> that, which felt weird since decompression speed should be about the
> same.
> 
> Has anyone else noticed anything like this?

LZO should decompress a lot faster than zlib, I know that's the case on ARM
and 32bit x86.

regards,

Koen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFTSXQQMkyGM64RGpERAtTRAJ9WQg0xA3s3AA+jMryzn6PVWpyEegCbBZTR
IzOZtgJvMbLT2fXdw0fOCxQ=
=2FXK
-----END PGP SIGNATURE-----


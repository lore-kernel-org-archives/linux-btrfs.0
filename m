Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:56562 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KUIcW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 03:32:22 -0500
Message-ID: <528DC511.80909@hesbynett.no>
Date: Thu, 21 Nov 2013 09:32:17 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no>	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>	<528C8F8E.9030908@hesbynett.no> <CAJBj3vcCgaNsS7JTZM9SEvjus09ZmaXT_iEwEvDOpjxt1BVZsg@mail.gmail.com>
In-Reply-To: <CAJBj3vcCgaNsS7JTZM9SEvjus09ZmaXT_iEwEvDOpjxt1BVZsg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/11/13 19:09, John Williams wrote:
> On Wed, Nov 20, 2013 at 2:31 AM, David Brown <david.brown@hesbynett.no> wrote:
>> That's certainly a reasonable way to look at it.  We should not limit
>> the possibilities for high-end systems because of the limitations of
>> low-end systems that are unlikely to use 3+ parity anyway.  I've also
>> looked up a list of the processors that support SSE3 and PSHUFB - a lot
>> of modern "low-end" x86 cpus support it.  And of course it is possible
>> to implement general G(2^8) multiplication without PSHUFB, using a
>> lookup table - it is important that this can all work with any CPU, even
>> if it is slow.
> 
> Unfortunately, it is SSSE3 that is required for PSHUFB. The SSE3 set
> with only two-esses does not suffice. I made that same mistake when I
> first heard about Andrea's 6-parity work. SSSE3 vs. SSE3, confusing
> notation!
> 
> SSSE3 is significantly less widely supported than SSE3. Particularly
> on AMD, only the very latest CPUs seem to support SSSE3. Intel support
> for SSSE3 goes back much further than AMD support.
> 
> Maybe it is not such a big problem, since it may be possible to
> support two "roads". Both roads would include the current md RAID-5
> and RAID-6. But one road, which those lacking CPUs supporting SSSE3
> might choose, would continue on to the non-SSSE3 triple-parity 2^-1
> technique, and then dead-end. The other road would continue with the
> Cauchy matrix technique through 3-parity all the way to 6-parity.
> 
> It might even be feasible to allow someone stuck at the end of the
> non-SSSE3 road to convert to the Cauchy road. You would have to go
> through all the 2^-1 triple-parity and convert it to Cauchy
> triple-parity. But then you would be safely on the Cauchy road.
> 

I would not like to see two alternative triple-parity solutions - I
think that would lead to confusion, and a non-Cauchy triple parity would
not be extendible without a rebuild (I've talked before about the idea
of temporarily adding an extra parity drive with an asymmetric layout.
I really like the idea, so I keep pushing for it!).

I think it is better to accept that 3+ parity will be slow on processors
that don't support PSHUFB.  We should try to find the best alternative
SIMD for other realistic processors (such as on AMD chips without
PSHUFB, ARM's with NEON, PPC with Altivec, etc.) - but a simple table
lookup will always work as a fallback.  Other than that I think it is
fair to say that if you want /fast/ 3+ parity, you need a reasonably
modern non-budget-class cpu.



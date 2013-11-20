Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:59396 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3KTSoD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:44:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAJBj3vcCgaNsS7JTZM9SEvjus09ZmaXT_iEwEvDOpjxt1BVZsg@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<528C8F8E.9030908@hesbynett.no>
	<CAJBj3vcCgaNsS7JTZM9SEvjus09ZmaXT_iEwEvDOpjxt1BVZsg@mail.gmail.com>
Date: Wed, 20 Nov 2013 19:44:01 +0100
Message-ID: <CAGKKSfUemNRq-X6meNKiyQBERzXRmLvOXkcwn8TGFf_Tq=_Atw@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: John Williams <jwilliams4200@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi John,

Yes. There are still AMD CPUs sold without SSSE3. Most notably Athlon.
Instead, Intel is providing SSSE3 from the Core 2 Duo.

A detailed list is available at: http://en.wikipedia.org/wiki/SSSE3

Ciao,
Andrea

On Wed, Nov 20, 2013 at 7:09 PM, John Williams <jwilliams4200@gmail.com> wrote:
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

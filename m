Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:18011 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3KUGOz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 01:14:55 -0500
Message-ID: <528DA4E5.5040201@hardwarefreak.com>
Date: Thu, 21 Nov 2013 00:15:01 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>,
        John Williams <jwilliams4200@gmail.com>
CC: David Brown <david.brown@hesbynett.no>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no>	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>	<528C8F8E.9030908@hesbynett.no>	<CAJBj3vcCgaNsS7JTZM9SEvjus09ZmaXT_iEwEvDOpjxt1BVZsg@mail.gmail.com> <CAGKKSfUemNRq-X6meNKiyQBERzXRmLvOXkcwn8TGFf_Tq=_Atw@mail.gmail.com>
In-Reply-To: <CAGKKSfUemNRq-X6meNKiyQBERzXRmLvOXkcwn8TGFf_Tq=_Atw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2013 12:44 PM, Andrea Mazzoleni wrote:

> Yes. There are still AMD CPUs sold without SSSE3. Most notably Athlon.
> Instead, Intel is providing SSSE3 from the Core 2 Duo.

I hate branding discontinuity, due to the resulting confusion...

Athlon, Athlon64, Athlon64 X2, Athlon X2 (K10), Athlon II X2, Athlon X2
(Piledriver).  Anyone confused?

The Trinity and Richland core "Athlon X2" and "Athlon X4" branded
processors certainly do support SSSE3, as well as SSE4, AVX, etc.  These
are the dual/quad core APUs whose graphics cores don't pass QC and are
surgically disabled.  AMD decided to brand them as "Athlon" processors.
 Available since ~2011.  For example:

http://www.cpu-world.com/CPUs/Bulldozer/AMD-Athlon%20X2%20370K%20-%20AD370KOKA23HL%20-%20AD370KOKHLBOX.html

The "Athlon II X2/X3/X4" processors have been out of production for a
couple of years now, but a scant few might still be found for sale in
the channel.  The X2 is based on the clean sheet Regor dual core 45nm
design.  The X3 and X4 are Phenom II rejects with various numbers of
defective cores and defective L3 caches.  None support SSSE3.

To say "there are still AMD CPUs sold without SSSE3... Most notably
Athlon" may be technically true if some Athlon II stragglers exist in
the channel.  But it isn't really a fair statement of today's reality.
AMD hasn't manufactured a CPU without SSSE3 for a couple of years now.
And few, if any, Athlon II X2/3/4 chips lacking SSSE3 are for sale.
Though there are certainly many such chips still in deployed desktop
machines.

> A detailed list is available at: http://en.wikipedia.org/wiki/SSSE3

Never trust Wikipedia articles to be complete and up to date.  However,
it does mention Athlon X2 and X4 as planned future product in the
Piledriver lineup.  Obviously this should be updated to past tense.

-- 
Stan

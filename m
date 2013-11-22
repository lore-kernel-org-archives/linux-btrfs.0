Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:13389 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3KVJfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 04:35:42 -0500
Message-ID: <528F2575.80605@hardwarefreak.com>
Date: Fri, 22 Nov 2013 03:35:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com> <CAJBj3veHCTbGstLoUec67sMWuyHQMmZNY4A6bwcb+HQOgjJ_Ew@mail.gmail.com>
In-Reply-To: <CAJBj3veHCTbGstLoUec67sMWuyHQMmZNY4A6bwcb+HQOgjJ_Ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2013 5:38 PM, John Williams wrote:
> On Thu, Nov 21, 2013 at 2:57 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> He wrote that article in late 2009.  It seems pretty clear he wasn't
>> looking 10 years forward to 20TB drives, where the minimum mirror
>> rebuild time will be ~18 hours, and parity rebuild will be much greater.
> 
> Actually, it is completely obvious that he WAS looking ten years
> ahead, seeing as several of his graphs have time scales going to
> 2009+10 = 2019.

Only one graph goes to 2019, the rest are 2010 or less.  That being the
case, his 2019 graph deals with projected reliability of single, double,
and triple parity.

> And he specifically mentions longer rebuild times as one of the
> reasons why higher parity RAIDs are needed.

Yes, he certainly does.  But *only* in the context of the array
surviving for the duration of a rebuild.  He doesn't state that he cares
what the total duration is, he doesn't guess what it might be, nor does
he seem to care about the degraded performance before or during the
rebuild.  He is apparently of the mindset "more parity will save us,
until we need more parity, until we need more parity, until we need
more...".

Following this path, parity will eventually eat more disks of capacity
than RAID10 does today for average array counts, and the only reason for
it being survival of ever increasing rebuild duration.

This is precisely why I proposed "RAID 15".  It gives you the single
disk cloning rebuild speed of RAID 10.  When parity hits 5P then RAID 15
becomes very competitive for smaller arrays.  And since drives at that
point will be 40-50TB each, even small arrays will need lots of
protection against UREs and additional failures during massive rebuild
times.  Here I'd say RAID 15 will beat 5P hands down.

-- 
Stan

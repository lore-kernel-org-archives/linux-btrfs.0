Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52000 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3KVPBP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 10:01:15 -0500
MIME-Version: 1.0
In-Reply-To: <528F2575.80605@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
	<528DADB1.8010604@hardwarefreak.com>
	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
	<528E8FEC.2070204@hardwarefreak.com>
	<CAJBj3veHCTbGstLoUec67sMWuyHQMmZNY4A6bwcb+HQOgjJ_Ew@mail.gmail.com>
	<528F2575.80605@hardwarefreak.com>
Date: Fri, 22 Nov 2013 07:01:14 -0800
Message-ID: <CAJBj3vft=Bnz1Hb-P96JZmfJNSE_m-S4SJ7nY3nev33SvCOmgQ@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: John Williams <jwilliams4200@gmail.com>
To: stan@hardwarefreak.com
Cc: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 1:35 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Only one graph goes to 2019, the rest are 2010 or less.  That being the
> case, his 2019 graph deals with projected reliability of single, double,
> and triple parity.

The whole article goes to 2019 (or longer). He shows current trends
and discusses where they are going in the future. The whole point of
the article is looking ahead into the future.

> Following this path, parity will eventually eat more disks of capacity
> than RAID10 does today for average array counts, and the only reason for
> it being survival of ever increasing rebuild duration.

No, that is not what the article finds. In the near future (about 10
years), triple-parity will suffice. Beyond that, perhaps quad-parity
will be required, but predicting that far ahead is usually worthless
in the computer industry.

> When parity hits 5P then RAID 15
> becomes very competitive for smaller arrays.  And since drives at that
> point will be 40-50TB each, even small arrays will need lots of
> protection against UREs and additional failures during massive rebuild
> times.  Here I'd say RAID 15 will beat 5P hands down.

I'll take triple- or 4-parity every time over the disk-wasting and
less reliable RAID 15. There is no need for 5-parity in the near
future.  I see no advantage of RAID 15, and several disadvantages.

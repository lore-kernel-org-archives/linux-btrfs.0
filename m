Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56289 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3KUHFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 02:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <528DADB1.8010604@hardwarefreak.com>
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
Date: Wed, 20 Nov 2013 23:05:04 -0800
Message-ID: <CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
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

On Wed, Nov 20, 2013 at 10:52 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 11/20/2013 8:46 PM, John Williams wrote:
>> For myself or any machines I managed for work that do not need high
>> IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
>> similar schemes with arrays of 16 - 32 drives.
>
> You must see a week long rebuild as acceptable...

It would not be a problem if it did take that long, since I would have
extra parity units as backup in case of a failure during a rebuild.

But of course it would not take that long. Take, for example, a 24 x
3TB triple-parity array (21+3) that has had two drive failures
(perhaps the rebuild started with one failure, but there was soon
another failure). I would expect the rebuild to take about a day.

>> on a subject Adam Leventhal has already
>> covered in detail in an article "Triple-Parity RAID and Beyond" which
>> seems to match the subject of this thread quite nicely:
>>
>> http://queue.acm.org/detail.cfm?id=1670144
>
> Mr. Leventhal did not address the overwhelming problem we face, which is
> (multiple) parity array reconstruction time.  He assumes the time to
> simply 'populate' one drive at its max throughput is the total
> reconstruction time for the array.

Since Adam wrote the code for RAID-Z3 for ZFS, I'm sure he is aware of
the time to restore data to failed drives. I do not see any flaw in
his analysis related to the time needed to restore data to failed
drives.

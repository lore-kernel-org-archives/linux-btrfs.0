Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:28891 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3KUW5m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 17:57:42 -0500
Message-ID: <528E8FEC.2070204@hardwarefreak.com>
Date: Thu, 21 Nov 2013 16:57:48 -0600
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
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com> <CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
In-Reply-To: <CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2013 1:05 AM, John Williams wrote:
> On Wed, Nov 20, 2013 at 10:52 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 11/20/2013 8:46 PM, John Williams wrote:
>>> For myself or any machines I managed for work that do not need high
>>> IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
>>> similar schemes with arrays of 16 - 32 drives.
>>
>> You must see a week long rebuild as acceptable...
> 
> It would not be a problem if it did take that long, since I would have
> extra parity units as backup in case of a failure during a rebuild.
> 
> But of course it would not take that long. Take, for example, a 24 x
> 3TB triple-parity array (21+3) that has had two drive failures
> (perhaps the rebuild started with one failure, but there was soon
> another failure). I would expect the rebuild to take about a day.

You're looking at today.  We're discussing tomorrow's needs.  Today's
6TB 3.5" drives have sustained average throughput of ~175MB/s.
Tomorrow's 20TB drives will be lucky to do 300MB/s.  As I said
previously, at that rate a straight disk-disk copy of a 20TB drive takes
18.6 hours.  This is what you get with RAID1/10/51.  In the real world,
rebuilding a failed drive in a 3P array of say 8 of these disks will
likely take at least 3 times as long, 2 days 6 hours minimum, probably
more.  This may be perfectly acceptable to some, but probably not to all.

>>> on a subject Adam Leventhal has already
>>> covered in detail in an article "Triple-Parity RAID and Beyond" which
>>> seems to match the subject of this thread quite nicely:
>>>
>>> http://queue.acm.org/detail.cfm?id=1670144
>>
>> Mr. Leventhal did not address the overwhelming problem we face, which is
>> (multiple) parity array reconstruction time.  He assumes the time to
>> simply 'populate' one drive at its max throughput is the total
>> reconstruction time for the array.
> 
> Since Adam wrote the code for RAID-Z3 for ZFS, I'm sure he is aware of
> the time to restore data to failed drives. I do not see any flaw in
> his analysis related to the time needed to restore data to failed
> drives.

He wrote that article in late 2009.  It seems pretty clear he wasn't
looking 10 years forward to 20TB drives, where the minimum mirror
rebuild time will be ~18 hours, and parity rebuild will be much greater.

-- 
Stan

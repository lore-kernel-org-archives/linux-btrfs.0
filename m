Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:21969 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3KXED7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 23:03:59 -0500
Message-ID: <52917AA8.1040300@hardwarefreak.com>
Date: Sat, 23 Nov 2013 22:03:52 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, John Williams <jwilliams4200@gmail.com>
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com>	<20131123100753.1820ab7c@notabene.brown>	<5290252A.8020508@hardwarefreak.com>	<20131123160428.6f1c5898@notabene.brown>	<CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com> <20131123181208.5103bee4@notabene.brown>
In-Reply-To: <20131123181208.5103bee4@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/2013 1:12 AM, NeilBrown wrote:
> On Fri, 22 Nov 2013 21:34:41 -0800 John Williams <jwilliams4200@gmail.com>

>> Even a single 8x PCIe 3.0 card has potentially over 7GB/s of bandwidth.
>>
>> Bottom line is that IO bandwidth is not a problem for a system with
>> prudently chosen hardware.

Quite right.

>> More likely is that you would be CPU limited (rather than bus limited)
>> in a high-parity rebuild where more than one drive failed. But even
>> that is not likely to be too bad, since Andrea's single-threaded
>> recovery code can recover two drives at nearly 1GB/s on one of my
>> machines. I think the code could probably be threaded to achieve a
>> multiple of that running on multiple cores.
> 
> Indeed.  It seems likely that with modern hardware, the  linear write speed
> would be the limiting factor for spinning-rust drives.

Parity array rebuilds are read-modify-write operations.  The main
difference from normal operation RMWs is that the write is always to the
same disk.  As long as the stripe reads and chunk reconstruction outrun
the write throughput then the rebuild speed should be as fast as a
mirror rebuild.  But this doesn't appear to be what people are
experiencing.  Parity rebuilds would seem to take much longer.

I have always surmised that the culprit is rotational latency, because
we're not able to get a real sector-by-sector streaming read from each
drive.  If even only one disk in the array has to wait for the platter
to come round again, the entire stripe read is slowed down by an
additional few milliseconds.  For example, in an 8 drive array let's say
each stripe read is slowed 5ms by only one of the 7 drives due to
rotational latency, maybe acoustical management, or some other firmware
hiccup in the drive.  This slows down the entire stripe read because we
can't do parity reconstruction until all chunks are in.  An 8x 2TB array
with 512KB chunk has 4 million stripes of 4MB each.  Reading 4M stripes,
that extra 5ms per stripe read costs us

(4,000,000 * 0.005)/3600 = 5.56 hours

Now consider that arrays typically have a few years on them before the
first drive failure.  During our rebuild it's likely that some drives
will take a few rotations to return a sector that's marginal.  So  this
might slow down a stripe read by dozens of milliseconds, maybe a full
second.  If this happens to multiple drives many times throughout the
rebuild it will add even more elapsed time, possibly additional hours.

Reading stripes asynchronously or in parallel, which I assume we already
do to some degree, can mitigate these latencies to some extent.  But I
think in the overall picture, things of this nature are what is driving
parity rebuilds to dozens of hours for many people.  And as I stated
previously, when drives reach 10-20TB, this becomes far worse because
we're reading 2-10x as many stripes.  And the more drives per array the
greater the odds of incurring latency during a stripe read.

With a mirror reconstruction we can stream the reads.  Though we can't
avoid all of the drive issues above, the total number of hiccups causing
latency will be at most 1/7th those of the parity 8 drive array case.

-- 
Stan

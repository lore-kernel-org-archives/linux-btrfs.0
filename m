Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:24157 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3KWDqw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 22:46:52 -0500
Message-ID: <5290252A.8020508@hardwarefreak.com>
Date: Fri, 22 Nov 2013 21:46:50 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: John Williams <jwilliams4200@gmail.com>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com> <20131123100753.1820ab7c@notabene.brown>
In-Reply-To: <20131123100753.1820ab7c@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2013 5:07 PM, NeilBrown wrote:
> On Thu, 21 Nov 2013 16:57:48 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> On 11/21/2013 1:05 AM, John Williams wrote:
>>> On Wed, Nov 20, 2013 at 10:52 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>> On 11/20/2013 8:46 PM, John Williams wrote:
>>>>> For myself or any machines I managed for work that do not need high
>>>>> IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
>>>>> similar schemes with arrays of 16 - 32 drives.
>>>>
>>>> You must see a week long rebuild as acceptable...
>>>
>>> It would not be a problem if it did take that long, since I would have
>>> extra parity units as backup in case of a failure during a rebuild.
>>>
>>> But of course it would not take that long. Take, for example, a 24 x
>>> 3TB triple-parity array (21+3) that has had two drive failures
>>> (perhaps the rebuild started with one failure, but there was soon
>>> another failure). I would expect the rebuild to take about a day.
>>
>> You're looking at today.  We're discussing tomorrow's needs.  Today's
>> 6TB 3.5" drives have sustained average throughput of ~175MB/s.
>> Tomorrow's 20TB drives will be lucky to do 300MB/s.  As I said
>> previously, at that rate a straight disk-disk copy of a 20TB drive takes
>> 18.6 hours.  This is what you get with RAID1/10/51.  In the real world,
>> rebuilding a failed drive in a 3P array of say 8 of these disks will
>> likely take at least 3 times as long, 2 days 6 hours minimum, probably
>> more.  This may be perfectly acceptable to some, but probably not to all.
> 
> Could you explain your logic here?  Why do you think rebuilding parity
> will take 3 times as long as rebuilding a copy?  Can you measure that sort of
> difference today?

I've not performed head-to-head timed rebuild tests of mirror vs parity
RAIDs.  I'm making the elapsed guess for parity RAIDs based on posts
here over the past ~3 years, in which many users reported 16-24+ hour
rebuild times for their fairly wide (12-16 1-2TB drive) RAID6 arrays.

This is likely due to their chosen rebuild priority and concurrent user
load during rebuild.  Since this seems to be the norm, instead of giving
100% to the rebuild, I thought it prudent to take this into account,
instead of the theoretical minimum rebuild time.

> Presumably when we have 20TB drives we will also have more cores and quite
> possibly dedicated co-processors which will make the CPU load less
> significant.

But (when) will we have the code to fully take advantage of these?  It's
nearly 2014 and we still don't have a working threaded write model for
levels 5/6/10, though maybe soon.  Multi-core mainstream x86 CPUs have
been around for 8 years now, SMP and ccNUMA systems even longer.  So the
need has been there for a while.

I'm strictly making an observation (possibly not fully accurate) here.
I am not casting stones.  I'm not a programmer and am thus unable to
contribute code, only ideas and troubleshooting assistance for fellow
users.  Ergo I have no right/standing to complain about the rate of
feature progress.  I know that everyone hacking md is making the most of
the time they have available.  So again, not a complaint, just an
observation.

-- 
Stan

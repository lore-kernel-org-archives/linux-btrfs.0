Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:23370 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3KXVNO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 16:13:14 -0500
Message-ID: <52926BE3.1000301@hardwarefreak.com>
Date: Sun, 24 Nov 2013 15:13:07 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>
CC: NeilBrown <neilb@suse.de>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com>	<20131123100753.1820ab7c@notabene.brown>	<5290252A.8020508@hardwarefreak.com>	<20131123160428.6f1c5898@notabene.brown>	<CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com>	<20131123181208.5103bee4@notabene.brown>	<52917AA8.1040300@hardwarefreak.com> <CAJBj3vdKsmQ=ovG5LnoDz_DqLFp5+o_j0JUWtWTRP+jzbbZkhg@mail.gmail.com>
In-Reply-To: <CAJBj3vdKsmQ=ovG5LnoDz_DqLFp5+o_j0JUWtWTRP+jzbbZkhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/2013 11:14 PM, John Williams wrote:
> On Sat, Nov 23, 2013 at 8:03 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> Parity array rebuilds are read-modify-write operations.  The main
>> difference from normal operation RMWs is that the write is always to the
>> same disk.  As long as the stripe reads and chunk reconstruction outrun
>> the write throughput then the rebuild speed should be as fast as a
>> mirror rebuild.  But this doesn't appear to be what people are
>> experiencing.  Parity rebuilds would seem to take much longer.
> 
> "This" doesn't appear to be what SOME people, who have reported
> issues, are experiencing. Their issues must be examined on a case by
> case basis.

Given what you state below this may very well be the case.

> But I, and a number of other people I have talked to or corresponded
> with, have had mdadm RAID 5 or RAID 6 rebuilds of one drive run at
> approximately the optimal sequential write speed of the replacement
> drive. It is not unusual on a reasonably configured system.

I freely admit I may have drawn an incorrect conclusion about md parity
rebuild performance based on incomplete data.  I simply don't recall
anyone stating here in ~3 years that their parity rebuilds were speedy,
but quite the opposite.  I guess it's possible that each one of those
cases was due to another factor, such as user load, slow CPU, bus
bottleneck, wonky disk firmware, backplane issues, etc.

-- 
Stan

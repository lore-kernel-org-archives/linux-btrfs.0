Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:18712 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3KYCEh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 21:04:37 -0500
Message-ID: <5292B030.5030305@hardwarefreak.com>
Date: Sun, 24 Nov 2013 20:04:32 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: Alex Elsayed <eternaleye@gmail.com>, linux-raid@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com> <528DADB1.8010604@hardwarefreak.com> <CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com> <528E8FEC.2070204@hardwarefreak.com> <20131123100753.1820ab7c@notabene.brown> <5290252A.8020508@hardwarefreak.com> <20131123160428.6f1c5898@notabene.brown> <CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com> <20131123181208.5103bee4@notabene.brown> <52917AA8.1040300@hardwarefreak.com> <CAJBj3vdKsmQ=ovG5LnoDz_DqLFp5+o_j0JUWtWTRP+jzbbZkhg@mail.gmail.com> <52926BE3.1000301@hardwarefreak.com> <l6u3h9$l72$2@ger.gmane.org>
In-Reply-To: <l6u3h9$l72$2@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2013 5:53 PM, Alex Elsayed wrote:
> Stan Hoeppner wrote:
> 
>> On 11/23/2013 11:14 PM, John Williams wrote:
>>> On Sat, Nov 23, 2013 at 8:03 PM, Stan Hoeppner <stan@hardwarefreak.com>
>>> wrote:
> <snip>
>>
>>> But I, and a number of other people I have talked to or corresponded
>>> with, have had mdadm RAID 5 or RAID 6 rebuilds of one drive run at
>>> approximately the optimal sequential write speed of the replacement
>>> drive. It is not unusual on a reasonably configured system.
>>
>> I freely admit I may have drawn an incorrect conclusion about md parity
>> rebuild performance based on incomplete data.  I simply don't recall
>> anyone stating here in ~3 years that their parity rebuilds were speedy,
>> but quite the opposite.  I guess it's possible that each one of those
>> cases was due to another factor, such as user load, slow CPU, bus
>> bottleneck, wonky disk firmware, backplane issues, etc.
>>
> 
> Well, there's also the issue of selection bias - people come to the list and

"Selection bias" would infer I'm doing some kind of formal analysis,
which is obviously not the case, though I do understand the point you're
making.

> complain when their RAID is taking forever to resync. People generally don't 
> come to the list and complain when their RAID resyncs quickly and without 
> issues.

When folks report problems on linux-raid it is commonplace for others to
reply that the same feature works fine for them, that the problem may be
configuration specific, etc.  When people have reported slow RAID5/6
rebuilds in the past, and these were not always reported in direct help
requests but as "me too" posts, I don't recall others saying their
parity rebuilds are speedy.  I'm not saying nobody ever has, simply that
I don't recall such.  Which is why I've been under the impression that
parity rebuilds are generally slow for everyone.

I wish I had hardware available to perform relevant testing.  It would
be nice to have some real data on this showing apples to apples rebuild
times for the various RAID levels on the same hardware.

-- 
Stan

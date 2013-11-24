Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:24584 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KXVol (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 16:44:41 -0500
Message-ID: <52927343.9000203@hardwarefreak.com>
Date: Sun, 24 Nov 2013 15:44:35 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: russell@coker.com.au
CC: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131123181208.5103bee4@notabene.brown> <52917AA8.1040300@hardwarefreak.com> <201311241619.08668.russell@coker.com.au>
In-Reply-To: <201311241619.08668.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/2013 11:19 PM, Russell Coker wrote:
> On Sun, 24 Nov 2013, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> I have always surmised that the culprit is rotational latency, because
>> we're not able to get a real sector-by-sector streaming read from each
>> drive.  If even only one disk in the array has to wait for the platter
>> to come round again, the entire stripe read is slowed down by an
>> additional few milliseconds.  For example, in an 8 drive array let's say
>> each stripe read is slowed 5ms by only one of the 7 drives due to
>> rotational latency, maybe acoustical management, or some other firmware
>> hiccup in the drive.  This slows down the entire stripe read because we
>> can't do parity reconstruction until all chunks are in.  An 8x 2TB array
>> with 512KB chunk has 4 million stripes of 4MB each.  Reading 4M stripes,
>> that extra 5ms per stripe read costs us
>>
>> (4,000,000 * 0.005)/3600 = 5.56 hours
> 
> If that is the problem then the solution would be to just enable read-ahead.  
> Don't we already have that in both the OS and the disk hardware?  The hard-
> drive read-ahead buffer should at least cover the case where a seek completes 
> but the desired sector isn't under the heads.

I'm not sure if read-ahead would solve such a problem, if indeed this is
a possible problem.  AFAIK the RAID5/6 drivers process stripes serially,
not asynchronously, so I'd think the rebuild may still stall for ms at a
time in such a situation.

> RAM size is steadily increasing, it seems that the smallest that you can get 
> nowadays is 1G in a phone and for a server the smallest is probably 4G.
> 
> On the smallest system that might have an 8 disk array you should be able to 
> use 512M for buffers which allows a read-ahead of 128 chunks.
> 
>> Now consider that arrays typically have a few years on them before the
>> first drive failure.  During our rebuild it's likely that some drives
>> will take a few rotations to return a sector that's marginal.
> 
> Are you suggesting that it would be a common case that people just write data 
> to an array and never read it or do an array scrub?  I hope that it will 
> become standard practice to have a cron job scrubbing all filesystems.

Given the frequency of RAID5 double drive failure "save me!" help
requests we see on a very regular basis here, it seems pretty clear this
is exactly what many users do.

>> So  this
>> might slow down a stripe read by dozens of milliseconds, maybe a full
>> second.  If this happens to multiple drives many times throughout the
>> rebuild it will add even more elapsed time, possibly additional hours.
> 
> Have you observed such 1 second reads in practice?

We seem to have regular reports from DIY hardware users intentionally
using mismatched consumer drives, as many believe this gives them
additional protection against a firmware bug in a given drive model.
But then they often see multiple second timeouts causing drives to be
kicked, or performance to be slow, because of the mismatched drives.

In my time on this list, it seems pretty clear that the vast majority of
posters use DIY hardware, not matched, packaged, tested solutions from
the likes of Dell, HP, IBM, etc.  Some of the things I've speculated
about in my last few posts could very well occur, and indeed be caused
by, ad hoc component selection and system assembly.  Obviously not in
all DIY cases, but probably many.

-- 
Stan


> One thing I've considered doing is placing a cheap disk on a speaker cone to 
> test vibration induced performance problems.  Then I can use a PC to control 
> the level of vibration in a reasonably repeatable manner.  I'd like to see 
> what the limits are for retries.
> 
> Some years ago a company I worked for had some vibration problems which 
> dropped the contiguous read speed from about 100MB/s to about 40MB/s on some 
> parts of the disk (other parts gave full performance).  That was a serious and 
> unusual problem and it only abouty halved the overall speed.

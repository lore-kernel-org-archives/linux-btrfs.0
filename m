Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:12280 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3KVIN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 03:13:26 -0500
Message-ID: <528F122C.2040202@hardwarefreak.com>
Date: Fri, 22 Nov 2013 02:13:32 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no>
In-Reply-To: <528DCD36.1060808@hesbynett.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 11/21/2013 3:07 AM, David Brown wrote:
> On 21/11/13 02:28, Stan Hoeppner wrote:
...
>> WRT rebuild times, once drives hit 20TB we're looking at 18 hours just
>> to mirror a drive at full streaming bandwidth, assuming 300MB/s
>> average--and that is probably being kind to the drive makers.  With 6 or
>> 8 of these drives, I'd guess a typical md/RAID6 rebuild will take at
>> minimum 72 hours or more, probably over 100, and probably more yet for
>> 3P.  And with larger drive count arrays the rebuild times approach a
>> week.  Whose users can go a week with degraded performance?  This is
>> simply unreasonable, at best.  I say it's completely unacceptable.
>>
>> With these gargantuan drives coming soon, the probability of multiple
>> UREs during rebuild are pretty high.  Continuing to use ever more
>> complex parity RAID schemes simply increases rebuild time further.  The
>> longer the rebuild, the more likely a subsequent drive failure due to
>> heat buildup, vibration, etc.  Thus, in our maniacal efforts to mitigate
>> one failure mode we're increasing the probability of another.  TANSTAFL.
>>  Worse yet, RAID10 isn't going to survive because UREs on a single drive
>> are increasingly likely with these larger drives, and one URE during
>> rebuild destroys the array.


> I don't think the chances of hitting an URE during rebuild is dependent
> on the rebuild time - merely on the amount of data read during rebuild.

Please read the above paragraph again, as you misread it the first time.

>  URE rates are "per byte read" rather than "per unit time", are they not?

These are specified by the drive manufacturer, and they are per *bits*
read, not "per byte read".  Current consumer drives are typically rated
at 1 URE in 10^14 bits read, enterprise are 1 in 10^15.

> I think you are overestimating the rebuild times a bit, but there is no

Which part?  A 20TB drive mirror taking 18 hours, or parity arrays
taking many times longer than 18 hours?

> arguing that rebuild on parity raids is a lot more work (for the cpu,
> the IO system, and the disks) than for mirror raids.

It's not so much a matter of work or interface bandwidth, but a matter
of serialization and rotational latency.

...
> Shouldn't we be talking about RAID 15 here, rather than RAID 51 ?  I
> interpret "RAID 15" to be like "RAID 10" - a raid5 set of raid1 mirrors,
> while "RAID 51" would be a raid1 mirror of raid5 sets.  I am certain
> that you mean a raid5 set of raid1 pairs - I just think you've got the
> name wrong.

Now that you mention it, yes, RAID 15 would fit much better with
convention.  Not sure why I thought 51.  So it's RAID 15 from here.

>> Potential Advantages:
>>
>> 1.  Only +1 disk capacity overhead vs RAID 10, regardless of drive count
> 
> +2 disks (the raid5 parity "disk" is a raid1 pair)

One drive of each mirror is already gone.  Make a RAID 5 of the
remaining disks and you lose 1 disk.  So you lose 1 additional disk vs
RAID 10, not 2.  As I stated previously, for RAID 15 you lose [1/2]+1 of
your disks to redundancy.

...
>> [1]  The RAID1/5 code would need to be patched to properly handle a URE
>> encountered by the RAID1 code during rebuild.  There are surely other
>> modifications and/or optimizations that would be needed.  For large
>> sequential reads, more deterministic read interleaving between mirror
>> pairs would be a good candidate I think.  IIUC the RAID1 driver does
>> read interleaving on a per thread basis or some such, which I don't
>> believe is going to work for this "RAID 51" scenario, at least not for
>> single streaming reads.  If this can be done well, we double the read
>> performance of RAID5, and thus we don't completely "waste" all the extra
>> disks vs big_parity schemes.
>>
>> This proposed "RAID level 51" should have drastically lower rebuild
>> times vs traditional striped parity, should not suffer read/write
>> performance degradation with most disk failure scenarios, and with a
>> read interleaving optimization may have significantly greater streaming
>> read throughput as well.
>>
>> This is far from a perfect solution and I am certainly not promoting it
>> as such.  But I think it does have some serious advantages over
>> traditional striped parity schemes, and at minimum is worth discussion
>> as a counterpoint of sorts.
> 
> I don't see that there needs to be any changes to the existing md code
> to make raid15 work - it is merely a raid 5 made from a set of raid1
> pairs.  

The sole purpose of the parity layer of the proposed RAID 15 is to
replace sectors lost due to UREs during rebuild.  AFAIK the current RAID
5 and RAID 1 drivers have no code to support each other in this manner.

> I can see that improved threading and interleaving could be a
> benefit here - but that's the case in general for md raid, and it is
> something that the developers are already working on (I haven't followed
> the details, but the topic comes up regularly on the list here).

What I'm talking about here is unrelated to the kernel thread starvation
issue, which is write centric, unrelated to reads.

What I'm suggesting is that it might be possible to improve the
concurrency of reads from the mirror disks using some form of static or
adaptive interleaving or similar.  The purpose of this would be strictly
to improve large single streaming read performance.  If this could be
achieved I do not know.

One possibility may be to count consecutive LBA sectors requested by the
filesystem stream and compare that to some value.  For example, say we
have an 18 disk RAID 15 array which gives us 8 spindles.  With a default
chunk of 512KB this gives us a stripe width of 4MB.  So lets say we
arbitrarily consider any single stream read larger than 4 stripes, 16MB,
to be a large streaming read.  So once our stream counter reaches 32,768
sectors we have the mirror code do alternating reads of 1,024 sectors,
512KB (chunk size), from each disk in the mirror.

Theoretically, this could yield large streaming read performance double
that of streaming write, and double that of the current RAID 1 read
behavior on a per mirror basis.  The trigger value could be statically
defined at array creation time by a yet to be determined formula based
on spindle count and chunk size, or it could be user configurable.

> So as far as I can see, you've got raid15 support already - if that's
> what suits your needs, use it.  Future improvements to the md code are
> only needed to make it faster.

You're too hung up on names and not getting the point.  Whether we call
it RAID 15 or Blue Cheese, if it doesn't have URE mitigation during
rebuild, it's worthless.

> Of course, there is scope for making specific raid15 support in md along
> the lines of the raid10 code - raid15,f2 would have the same speed
> advantages over "normal" raid1+5 as raid10,f2 has over raid1+0.  Whether
> it is worth the effort implementing it is a different matter.

Except the RAID10 driver suffers from the single write thread.  RAID 0
over mirrors doesn't have this problem.  Which is why, along with other
reasons, I proposed a possible RAID 15 driver using the RAID 5 and RAID
1 drivers as the base, as this won't have the single write thread problem.

> I can see plenty of reasons why raid15 might be a good idea, and even
> raid16 for 5 disk redundancy, compared to multi-parity sets.  However,
> it costs a lot in disk space.  
...

Of course it does, just as RAID 10 does.  Parity users who currently
shun RAID 10 for this reason will also shun this "RAID 15".  That's
obvious.  Potential users of RAID 15 are those who value the features of
RAID 10 other than random write performance.

-- 
Stan

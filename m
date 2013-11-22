Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:48884 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3KVNQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 08:16:04 -0500
Message-ID: <528F590D.4000601@hesbynett.no>
Date: Fri, 22 Nov 2013 14:15:57 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: stan@hardwarefreak.com, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F122C.2040202@hardwarefreak.com>
In-Reply-To: <528F122C.2040202@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/11/13 09:13, Stan Hoeppner wrote:
> Hi David,
> 
> On 11/21/2013 3:07 AM, David Brown wrote:
>> On 21/11/13 02:28, Stan Hoeppner wrote:
> ...
>>> WRT rebuild times, once drives hit 20TB we're looking at 18 hours just
>>> to mirror a drive at full streaming bandwidth, assuming 300MB/s
>>> average--and that is probably being kind to the drive makers.  With 6 or
>>> 8 of these drives, I'd guess a typical md/RAID6 rebuild will take at
>>> minimum 72 hours or more, probably over 100, and probably more yet for
>>> 3P.  And with larger drive count arrays the rebuild times approach a
>>> week.  Whose users can go a week with degraded performance?  This is
>>> simply unreasonable, at best.  I say it's completely unacceptable.
>>>
>>> With these gargantuan drives coming soon, the probability of multiple
>>> UREs during rebuild are pretty high.  Continuing to use ever more
>>> complex parity RAID schemes simply increases rebuild time further.  The
>>> longer the rebuild, the more likely a subsequent drive failure due to
>>> heat buildup, vibration, etc.  Thus, in our maniacal efforts to mitigate
>>> one failure mode we're increasing the probability of another.  TANSTAFL.
>>>  Worse yet, RAID10 isn't going to survive because UREs on a single drive
>>> are increasingly likely with these larger drives, and one URE during
>>> rebuild destroys the array.
> 
> 
>> I don't think the chances of hitting an URE during rebuild is dependent
>> on the rebuild time - merely on the amount of data read during rebuild.
> 
> Please read the above paragraph again, as you misread it the first time.

Yes, I thought you were saying that URE's were more likely during a
parity raid rebuild than during a mirror raid rebuild, because parity
rebuilds take longer.  They will be slightly more likely (due to more
mechanical stress on the drives), but only slightly.

> 
>>  URE rates are "per byte read" rather than "per unit time", are they not?
> 
> These are specified by the drive manufacturer, and they are per *bits*
> read, not "per byte read".  Current consumer drives are typically rated
> at 1 URE in 10^14 bits read, enterprise are 1 in 10^15.

"Per bit" or "per byte" makes no difference to the principle.

Just to get some numbers here, if we have a 20 TB drive (which don't yet
exist, AFAIK - 6 TB is the highest I have heard) with a URE rate of 1 in
10^14, that means an average of 1.6 errors per read of the whole disk.

Assuming bit errors are independent (an unwarranted assumption, I know -
but it makes the maths easier!), an URE of 1 in 10^14 gives a chance of
3.3 * 10^-10 of an error in a 4 KB sector - and a 83% chance of getting
at least one incorrect sector read out of 20 TB.  Even if enterprise
disks have lower URE rates, I think it is reasonable to worry about
URE's during a raid1 rebuild!

The probability of hitting URE's on two disks at the same spot is, of
course, tiny (given that you've got one URE, the chances of a URE in the
same sector on another disk is 3.3 * 10^-10) - so two disk redundancy
lets you have a disk failure and an URE safely.

In theory, mirror raids are safer here because you only need to worry
about a matching URE on /one/ disk.  If you have a parity array with 60
disks, the chances of a matching URE on one of the other disks is 2 *
10^-8 - higher than for mirror raids, but still not a big concern.  (Of
course, you have more chance of a complete disk failure provoked by
stresses during rebuilds, but that's another failure mode.)


What does all this mean?  Single disk redundancy, like 2-way raid1
mirrors, is not going to be good enough for bigger disks unless the
manufacturers can get their URE rates significantly lower.  You will
need an extra redundancy to be safe.  That means raid6 is a minimum, or
3-way mirrors, or stacked raids like raid15.  And if you want to cope
with a disk failure, a second disk failure due to the stresses of
rebuilding, /and/ and URE, then triple parity or raid15 is needed.


> 
>> I think you are overestimating the rebuild times a bit, but there is no
> 
> Which part?  A 20TB drive mirror taking 18 hours, or parity arrays
> taking many times longer than 18 hours?

The 18 hours for a 20 TB mirror sounds right - but that it takes 9 times
as long for a rebuild with a parity array sounds too much.  But I don't
have any figures as evidence.  And of course it varies depending on what
else you are doing with the array at the time - parity array rebuilds
will be affected much more by concurrent access to the array than
mirrored arrays.  It's all a balance - if you want cheaper space but
have less IO's and can tolerate slower rebuilds, then parity arrays are
good.  If you want fast access then raid 15 looks better.

> 
>> arguing that rebuild on parity raids is a lot more work (for the cpu,
>> the IO system, and the disks) than for mirror raids.
> 
> It's not so much a matter of work or interface bandwidth, but a matter
> of serialization and rotational latency.
> 
> ...
>> Shouldn't we be talking about RAID 15 here, rather than RAID 51 ?  I
>> interpret "RAID 15" to be like "RAID 10" - a raid5 set of raid1 mirrors,
>> while "RAID 51" would be a raid1 mirror of raid5 sets.  I am certain
>> that you mean a raid5 set of raid1 pairs - I just think you've got the
>> name wrong.
> 
> Now that you mention it, yes, RAID 15 would fit much better with
> convention.  Not sure why I thought 51.  So it's RAID 15 from here.

Maybe you wanted to use the power of alien technology from Area 51 :-)

But I'm glad we agree on the name.

> 
>>> Potential Advantages:
>>>
>>> 1.  Only +1 disk capacity overhead vs RAID 10, regardless of drive count
>>
>> +2 disks (the raid5 parity "disk" is a raid1 pair)
> 
> One drive of each mirror is already gone.  Make a RAID 5 of the
> remaining disks and you lose 1 disk.  So you lose 1 additional disk vs
> RAID 10, not 2.  As I stated previously, for RAID 15 you lose [1/2]+1 of
> your disks to redundancy.

Ah, you meant you lose a disk's worth of capacity in comparison to a
raid10 array with the same number of disks?  I meant you have to add 2
disks to your raid10 array in order to keep the same capacity.  Both are
correct - it's just a different way of looking at it.


Just to be clear, to store data blocks D0, D1, D2, D3 on different raids
you need:

raid0: 4 disks D0, D1, D2, D3
raid10: 8 disks D0a, D0b, D1a, D1b, D2a, D2b, D3a, D3b
raid5: 5 disks D0, D1, D2, D3, P
raid15: 10 disks D0a, D0b, D1a, D1b, D2a, D2b, D3a, D3b, Pa, Pb


> 
> ...
>>> [1]  The RAID1/5 code would need to be patched to properly handle a URE
>>> encountered by the RAID1 code during rebuild.  There are surely other
>>> modifications and/or optimizations that would be needed.  For large
>>> sequential reads, more deterministic read interleaving between mirror
>>> pairs would be a good candidate I think.  IIUC the RAID1 driver does
>>> read interleaving on a per thread basis or some such, which I don't
>>> believe is going to work for this "RAID 51" scenario, at least not for
>>> single streaming reads.  If this can be done well, we double the read
>>> performance of RAID5, and thus we don't completely "waste" all the extra
>>> disks vs big_parity schemes.
>>>
>>> This proposed "RAID level 51" should have drastically lower rebuild
>>> times vs traditional striped parity, should not suffer read/write
>>> performance degradation with most disk failure scenarios, and with a
>>> read interleaving optimization may have significantly greater streaming
>>> read throughput as well.
>>>
>>> This is far from a perfect solution and I am certainly not promoting it
>>> as such.  But I think it does have some serious advantages over
>>> traditional striped parity schemes, and at minimum is worth discussion
>>> as a counterpoint of sorts.
>>
>> I don't see that there needs to be any changes to the existing md code
>> to make raid15 work - it is merely a raid 5 made from a set of raid1
>> pairs.  
> 
> The sole purpose of the parity layer of the proposed RAID 15 is to
> replace sectors lost due to UREs during rebuild.  AFAIK the current RAID
> 5 and RAID 1 drivers have no code to support each other in this manner.

Now I've figure out what you are thinking about - if the raid1 rebuild
fails on a stripe due to an URE, then rather than just marking that
stripe as bad, it should ask the higher raid level (the raid5 here) for
the data.  I don't know if there is any such system in place at the
moment in the kernel code - maybe one of the md code experts here can
tell us.  It should be reasonably easy to implement, I think - what is
needed is for a failure on the lower level raid to trigger a scrub on
the stripe at the higher level raid.  (Of course, the problem will solve
itself next time you do a scrub on the upper raid anyway, but it would
be best to fix it quickly.)

One other optimisation that could be nice here when rebuilding one of
the mirror pairs is to mark the pair "write-mostly", and possibly even
"write-behind".  These flags are currently only valid for raid1 (AFAIK),
and can only be set when building an array.  The idea here is that you
can have a mirror between a local fast drive and a slower drive or a
networked drive - the slow drive will only be used for writes unless
there is a failure on the faster drives, and writes can be buffered
(with "write-behind") if needed.  If a rebuilding mirror pair in raid 15
could be temporarily marked as "write-mostly" and perhaps
"write-behind", then it would be free to dedicate full bandwidth to the
rebuild.  Any reads from that pair would be re-created from the parities
on the other drives.

> 
>> I can see that improved threading and interleaving could be a
>> benefit here - but that's the case in general for md raid, and it is
>> something that the developers are already working on (I haven't followed
>> the details, but the topic comes up regularly on the list here).
> 
> What I'm talking about here is unrelated to the kernel thread starvation
> issue, which is write centric, unrelated to reads.
> 
> What I'm suggesting is that it might be possible to improve the
> concurrency of reads from the mirror disks using some form of static or
> adaptive interleaving or similar.  The purpose of this would be strictly
> to improve large single streaming read performance.  If this could be
> achieved I do not know.
> 
> One possibility may be to count consecutive LBA sectors requested by the
> filesystem stream and compare that to some value.  For example, say we
> have an 18 disk RAID 15 array which gives us 8 spindles.  With a default
> chunk of 512KB this gives us a stripe width of 4MB.  So lets say we
> arbitrarily consider any single stream read larger than 4 stripes, 16MB,
> to be a large streaming read.  So once our stream counter reaches 32,768
> sectors we have the mirror code do alternating reads of 1,024 sectors,
> 512KB (chunk size), from each disk in the mirror.
> 

I see what you mean, and yes, I can see how that could speed up large
accesses.  But I think the same idea applies to a normal raid1 mirror -
a streamed read from it could use interleaved reads from the two halves
to speed up the read.  And if it worked for raid1, then it would
automatically work for raid 15.  I think :-)

Of course, you could always use raid10,f2 or raid10,o2 under raid5 to
get faster read performance (at the cost of slower writes - just like
normal raid10,f2 vs. raid1 comparisons).  Then on your 18-disk "raid105"
array your streamed reads would use 16 spindles.

> Theoretically, this could yield large streaming read performance double
> that of streaming write, and double that of the current RAID 1 read
> behavior on a per mirror basis.  The trigger value could be statically
> defined at array creation time by a yet to be determined formula based
> on spindle count and chunk size, or it could be user configurable.
> 
>> So as far as I can see, you've got raid15 support already - if that's
>> what suits your needs, use it.  Future improvements to the md code are
>> only needed to make it faster.
> 
> You're too hung up on names and not getting the point.  Whether we call
> it RAID 15 or Blue Cheese, if it doesn't have URE mitigation during
> rebuild, it's worthless.

As noted above, I think the current system would work but you need a
scrub at the raid5 level after the raid1 rebuild - and (now that I see
what you are getting at) I agree that this could be done much better
with extra kernel support.

> 
>> Of course, there is scope for making specific raid15 support in md along
>> the lines of the raid10 code - raid15,f2 would have the same speed
>> advantages over "normal" raid1+5 as raid10,f2 has over raid1+0.  Whether
>> it is worth the effort implementing it is a different matter.
> 
> Except the RAID10 driver suffers from the single write thread.  RAID 0
> over mirrors doesn't have this problem.  Which is why, along with other
> reasons, I proposed a possible RAID 15 driver using the RAID 5 and RAID
> 1 drivers as the base, as this won't have the single write thread problem.

Improving the threading of raid10 writes should be perfectly possible
technically - the only problem is someone having the time to do it.  We
are just looking at different ideas here, to gauge the pros and cons of
alternative raid structures.  Ideally we could have /all/ these ideas
implemented, but developer and tester time is the limitation rather than
the technical solution (since it looks like the technical problems of
multi-parity raid have been solved).

> 
>> I can see plenty of reasons why raid15 might be a good idea, and even
>> raid16 for 5 disk redundancy, compared to multi-parity sets.  However,
>> it costs a lot in disk space.  
> ...
> 
> Of course it does, just as RAID 10 does.  Parity users who currently
> shun RAID 10 for this reason will also shun this "RAID 15".  That's
> obvious.  Potential users of RAID 15 are those who value the features of
> RAID 10 other than random write performance.
> 

Yes, both solutions would be useful.


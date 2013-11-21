Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:42187 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KUJHH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 04:07:07 -0500
Message-ID: <528DCD36.1060808@hesbynett.no>
Date: Thu, 21 Nov 2013 10:07:02 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: stan@hardwarefreak.com, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com>
In-Reply-To: <528D61C5.70902@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/13 02:28, Stan Hoeppner wrote:
> On 11/20/2013 10:16 AM, James Plank wrote:
>> Hi all -- no real comments, except as I mentioned to Ric, my tutorial
>> in FAST last February presents Reed-Solomon coding with Cauchy
>> matrices, and then makes special note of the common pitfall of
>> assuming that you can append a Vandermonde matrix to an identity
>> matrix.  Please see
>> http://web.eecs.utk.edu/~plank/plank/papers/2013-02-11-FAST-Tutorial.pdf,
>> slides 48-52.
>>
>> Andrea, does the matrix that you included in an earlier mail (the one
>> that has Linux RAID-6 in the first two rows) have a general form, or
>> did you develop it in an ad hoc manner so that it would include Linux
>> RAID-6 in the first two rows?
> 
> Hello Jim,
> 
> It's always perilous to follow a Ph.D., so I guess I'm feeling suicidal
> today. ;)
> 
> I'm not attempting to marginalize Andrea's work here, but I can't help
> but ponder what the real value of triple parity RAID is, or quad, or
> beyond.  Some time ago parity RAID's primary mission ceased to be
> surviving single drive failure, or a 2nd failure during rebuild, and
> became mitigating UREs during a drive rebuild.  So we're now talking
> about dedicating 3 drives of capacity to avoiding disaster due to
> platter defects and secondary drive failure.  For small arrays this is
> approaching half the array capacity.  So here parity RAID has lost the
> battle with RAID10's capacity disadvantage, yet it still suffers the
> vastly inferior performance in normal read/write IO, not to mention
> rebuild times that are 3-10x longer.
> 
> WRT rebuild times, once drives hit 20TB we're looking at 18 hours just
> to mirror a drive at full streaming bandwidth, assuming 300MB/s
> average--and that is probably being kind to the drive makers.  With 6 or
> 8 of these drives, I'd guess a typical md/RAID6 rebuild will take at
> minimum 72 hours or more, probably over 100, and probably more yet for
> 3P.  And with larger drive count arrays the rebuild times approach a
> week.  Whose users can go a week with degraded performance?  This is
> simply unreasonable, at best.  I say it's completely unacceptable.
> 
> With these gargantuan drives coming soon, the probability of multiple
> UREs during rebuild are pretty high.  Continuing to use ever more
> complex parity RAID schemes simply increases rebuild time further.  The
> longer the rebuild, the more likely a subsequent drive failure due to
> heat buildup, vibration, etc.  Thus, in our maniacal efforts to mitigate
> one failure mode we're increasing the probability of another.  TANSTAFL.
>  Worse yet, RAID10 isn't going to survive because UREs on a single drive
> are increasingly likely with these larger drives, and one URE during
> rebuild destroys the array.
> 

I don't think the chances of hitting an URE during rebuild is dependent
on the rebuild time - merely on the amount of data read during rebuild.
 URE rates are "per byte read" rather than "per unit time", are they not?

I think you are overestimating the rebuild times a bit, but there is no
arguing that rebuild on parity raids is a lot more work (for the cpu,
the IO system, and the disks) than for mirror raids.

> I think people are going to have to come to grips with using more and
> more drives simply to brace the legs holding up their arrays; comes to
> grips with these insane rebuild times; or bite the bullet they so
> steadfastly avoided with RAID10.  Lots more spindles solves problems,
> but at a greater cost--again, no free lunch.
> 
> What I envision is an array type, something similar to RAID 51, i.e.
> striped parity over mirror pairs.  In the case of Linux, this would need
> to be a new distinct md/RAID level, as both the RAID5 and RAID1 code
> would need enhancement before being meshed together into this new level[1].

Shouldn't we be talking about RAID 15 here, rather than RAID 51 ?  I
interpret "RAID 15" to be like "RAID 10" - a raid5 set of raid1 mirrors,
while "RAID 51" would be a raid1 mirror of raid5 sets.  I am certain
that you mean a raid5 set of raid1 pairs - I just think you've got the
name wrong.

> 
> Potential Advantages:
> 
> 1.  Only +1 disk capacity overhead vs RAID 10, regardless of drive count

+2 disks (the raid5 parity "disk" is a raid1 pair)

> 2.  Rebuild time is the same as RAID 10, unless a mirror pair is lost
> 3.  Parity is only used during rebuild if/when a URE occurs, unless ^
> 4.  Single drive failure doesn't degrade the parity array, multiple
>     failures in different mirrors doesn't degrade the parity array
> 5.  Can sustain a minimum of 3 simultaneous drive failures--both drives
>     in one mirror and one drive in another mirror
> 6.  Can lose a maximum of 1/2 of the drives plus 1 drive--one more than
>     RAID 10.  Can lose half the drives and still not degrade parity,
>     if no two comprise one mirror
> 7.  Similar or possibly better read throughput vs triple parity RAID
> 8.  Superior write performance with drives down
> 9.  Vastly superior rebuild performance, as rebuilds will rarely, if
>     ever, involve parity
> 
> Potential Disadvantages:
> 
> 1.  +1 disk overhead vs RAID 10, many more than 2/3P w/large arrays
> 2.  Read-modify-write penalty vs RAID 10
> 3.  Slower write throughput vs triple parity RAID due to spindle deficit
> 4.  Development effort
> 5.  ??
> 
> 
> [1]  The RAID1/5 code would need to be patched to properly handle a URE
> encountered by the RAID1 code during rebuild.  There are surely other
> modifications and/or optimizations that would be needed.  For large
> sequential reads, more deterministic read interleaving between mirror
> pairs would be a good candidate I think.  IIUC the RAID1 driver does
> read interleaving on a per thread basis or some such, which I don't
> believe is going to work for this "RAID 51" scenario, at least not for
> single streaming reads.  If this can be done well, we double the read
> performance of RAID5, and thus we don't completely "waste" all the extra
> disks vs big_parity schemes.
> 
> This proposed "RAID level 51" should have drastically lower rebuild
> times vs traditional striped parity, should not suffer read/write
> performance degradation with most disk failure scenarios, and with a
> read interleaving optimization may have significantly greater streaming
> read throughput as well.
> 
> This is far from a perfect solution and I am certainly not promoting it
> as such.  But I think it does have some serious advantages over
> traditional striped parity schemes, and at minimum is worth discussion
> as a counterpoint of sorts.
> 

I don't see that there needs to be any changes to the existing md code
to make raid15 work - it is merely a raid 5 made from a set of raid1
pairs.  I can see that improved threading and interleaving could be a
benefit here - but that's the case in general for md raid, and it is
something that the developers are already working on (I haven't followed
the details, but the topic comes up regularly on the list here).

So as far as I can see, you've got raid15 support already - if that's
what suits your needs, use it.  Future improvements to the md code are
only needed to make it faster.

Of course, there is scope for making specific raid15 support in md along
the lines of the raid10 code - raid15,f2 would have the same speed
advantages over "normal" raid1+5 as raid10,f2 has over raid1+0.  Whether
it is worth the effort implementing it is a different matter.


I can see plenty of reasons why raid15 might be a good idea, and even
raid16 for 5 disk redundancy, compared to multi-parity sets.  However,
it costs a lot in disk space.  For example, with 20 disks at 1 TB each,
you can have:

raid5 = 19TB, 1 disk redundancy
raid6 = 18TB, 2 disk redundancy
raid6.3 = 17TB, 3 disk redundancy
raid6.4 = 16TB, 4 disk redundancy
raid6.5 = 15TB, 5 disk redundancy

raid10 = 10TB, 1 disk redundancy
raid15 = 8TB, 3 disk redundancy
raid16 = 6TB, 5 disk redundancy


That's a very significant difference.

Implementing 3+ parity does not stop people using raid15, or similar
schemes - it just adds more choice to let people optimise according to
their needs.





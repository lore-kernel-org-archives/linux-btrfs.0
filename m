Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:13125 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3KVAan (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 19:30:43 -0500
Message-ID: <528EA5B9.3000801@hardwarefreak.com>
Date: Thu, 21 Nov 2013 18:30:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: joystick <joystick@shiftmail.org>
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DBF85.6010303@shiftmail.org>
In-Reply-To: <528DBF85.6010303@shiftmail.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2013 2:08 AM, joystick wrote:
> On 21/11/2013 02:28, Stan Hoeppner wrote:
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
>> UREs during rebuild are pretty high.
> 
> No because if you are correct about the very high CPU overhead during

I made no such claim.

> rebuild (which I don't see so dramatic as Andrea claims 500MB/sec for
> triple-parity, probably parallelizable on multiple cores), the speed of
> rebuild decreases proportionally 

The rebuild time of a parity array normally has little to do with CPU
overhead.  The bulk of the elapsed time is due to:

1.  The serial nature of the rebuild algorithm
2.  The random IO pattern of the reads
3.  The rotational latency of the drives

#3 is typically the largest portion of the elapsed time.

> and hence the stress and heating on the
> drives proportionally reduces, approximating that of normal operation.
> And how often have you seen a drive failure in a week during normal
> operation?

This depends greatly on one's normal operation.  In general, for most
users of parity arrays, any full array operation such as a rebuild or
reshape is far more taxing on the drives, in both power draw and heat
dissipation, than 'normal' operation.

> But in reality, consider that a non-naive implementation of
> multiple-parity would probably use just the single parity during
> reconstruction if just one disk fails, using the multiple parities only
> to read the stripes which are unreadable at single parity. So the speed
> and time of reconstruction and performance penalty would be that of
> raid5 except in exceptional situations of multiple failures.

That may very well be, but it doesn't change #2,3 above.

>> What I envision is an array type, something similar to RAID 51, i.e.
>> striped parity over mirror pairs. ....
> 
> I don't like your approach of raid 51: it has the write overhead of
> raid5, with the waste of space of raid1.
> So it cannot be used as neither a performance array nor a capacity array.

I don't like it either.  It's a compromise.  But as RAID1/10 will soon
be unusable due to URE probability during rebuild, I think it's a
relatively good compromise for some users, some workloads.

> In the scope of this discussion (we are talking about very large
> arrays), 

Capacity yes, drive count, no.  Drive capacities are increasing at a
much faster rate than our need for storage space.  As we move forward
the trend will be building larger capacity arrays with fewer disks.

> the waste of space of your solution, higher than 50%, will make
> your solution costing double the price.

This is the classic mirror vs parity argument.  Using 1 more disk to add
parity to striped mirrors doesn't change it.  "Waste" is in the eye of
the beholder.  Anyone currently using RAID10 will have no problem
dedicating one more disk for uptime, protection.

> A competitor for the multiple-parity scheme might be raid65 or 66, but
> this is a so much dirtier approach than multiple parity if you think at
> the kind of rmw and overhead that will occur during normal operation.

Neither of those has any advantage over multi-parity.  I suggested this
approach because it retains all of the advantages of RAID10 but one.  We
sacrifice fast random write performance for protection against UREs, the
same reason behind 3P.  That's what the single parity is for, and that
alone.

I suggest that anyone in the future needing fast random write IOPS is
going to move those workloads to SSD, which is steadily increasing in
capacity.  And I suggest anyone building arrays with 10-20TB drives
isn't in need of fast random write IOPS.  Whether this approach is
valuable to anyone depends on whether the remaining attributes of
RAID10, with the added URE protection, are worth the drive count.
Obviously proponents of traditional parity arrays will not think so.
Users of RAID10 may.  Even if md never supports such a scheme, I bet
we'll see something similar to this in enterprise gear, where rebuilds
need to be 'fast' and performance degradation due to a downed drive is
not acceptable.

-- 
Stan

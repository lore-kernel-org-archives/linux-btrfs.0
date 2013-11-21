Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1397 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090Ab3KUIQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 03:16:26 -0500
Message-ID: <528DBF85.6010303@shiftmail.org>
Date: Thu, 21 Nov 2013 09:08:37 +0100
From: joystick <joystick@shiftmail.org>
MIME-Version: 1.0
To: stan@hardwarefreak.com
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com>
In-Reply-To: <528D61C5.70902@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/2013 02:28, Stan Hoeppner wrote:
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
> UREs during rebuild are pretty high.

No because if you are correct about the very high CPU overhead during 
rebuild (which I don't see so dramatic as Andrea claims 500MB/sec for 
triple-parity, probably parallelizable on multiple cores), the speed of 
rebuild decreases proportionally and hence the stress and heating on the 
drives proportionally reduces, approximating that of normal operation.
And how often have you seen a drive failure in a week during normal 
operation?

But in reality, consider that a non-naive implementation of 
multiple-parity would probably use just the single parity during 
reconstruction if just one disk fails, using the multiple parities only 
to read the stripes which are unreadable at single parity. So the speed 
and time of reconstruction and performance penalty would be that of 
raid5 except in exceptional situations of multiple failures.


> ...
> What I envision is an array type, something similar to RAID 51, i.e.
> striped parity over mirror pairs. ....

I don't like your approach of raid 51: it has the write overhead of 
raid5, with the waste of space of raid1.
So it cannot be used as neither a performance array nor a capacity array.
In the scope of this discussion (we are talking about very large 
arrays), the waste of space of your solution, higher than 50%, will make 
your solution costing double the price.

A competitor for the multiple-parity scheme might be raid65 or 66, but 
this is a so much dirtier approach than multiple parity if you think at 
the kind of rmw and overhead that will occur during normal operation.



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38980 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbbJEIUD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 04:20:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zj100-00080U-Or
	for linux-btrfs@vger.kernel.org; Mon, 05 Oct 2015 10:19:56 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 10:19:56 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 10:19:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as image store for KVM?
Date: Mon, 5 Oct 2015 08:19:50 +0000 (UTC)
Message-ID: <pan$5cc6d$7932715b$df64b07$b3b8edce@cox.net>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
	<pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
	<56111598.2080403@bouton.name>
	<CAGfcS_=9uf359-uBHfEXhUC3HTpkjzE7vMwG1iOR2Ld0u3nFTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sun, 04 Oct 2015 08:21:53 -0400 as excerpted:

> On Sun, Oct 4, 2015 at 8:03 AM, Lionel Bouton
> <lionel-subscription@bouton.name> wrote:
>>
>> This focus on single reader RAID1 performance surprises me.
>>
>> 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
>> you need 2 processes to read from 2 devices at once) and I've never
>> seen anyone arguing that the current md code is unstable.

I'm not a coder and could be wrong, but AFAIK, md/raid1 either works per 
thread (thus should multiplex I/O across raid1 devices in single-process-
multi-thread), or handles multiple AIO requests in parallel, if not both.

(If I'm laboring under a severe misconception, and I could be, please do 
correct me -- I'll rather be publicly corrected and have just that, my 
world-view corrected to align with reality, than be wrong, publicly or 
privately, and never know it, thus never correcting it!  =:^)

IOW, the primary case where I believe md/raid1 does single-device serial 
access, is where the single process is doing just that, serialized-single-
request-sleep-until-the-data's-ready.  Otherwise read requests are spread 
among the available spindles.  =:^)

But...

> Perhaps, but with btrfs it wouldn't be hard to get 1000 processes
> reading from a raid1 in btrfs and have every single request directed to
> the same disk with the other disk remaining completely idle.  I believe
> the algorithm is just whether the pid is even or odd, and doesn't take
> into account disk activity at all, let alone disk performance or
> anything more sophisticated than that.
> 
> I'm sure md does a better job than that.

Exactly.  Even/odd PID scheduling is great for testing, since it's simple 
enough to load either side exclusively or both sides exactly evenly, but 
it's absolutely horrible for multi-task, since worst-case single-device-
bottleneck is all too easy to achieve by accident, and even pure-random 
distribution is going to favor one side or the other to some extent, most 
of the time.

Even worse, due to the most-remaining-free-space chunk allocation 
algorithm and pair-mirroring only, no matter the number of devices, try 
to use 3+ devices of differing sizes, and until the space-available on 
the largest pair reaches that of the others, that largest pair will get 
the allocations.  Consider a bunch of quarter-TiB devices in raid1, with 
a pair of 2 TiB devices as well.  The quarter-TiB devices will remain 
idle until the pair of 2 TiB devices reach 1.75 TiB full, thus equalizing 
the space available on each compared to the other devices on the 
filesystem.  Of course, that means reads too, are going to be tied to 
only those two devices, for anything in that first 1.75 TiB of data, and 
if all those reads are from even or all from odd PIDs, it's only going to 
be ONE of... perhaps 10 devices! Possibly hundreds of read threads 
bottlenecking on a single device of ten, while the other 9/10 of the 
filesystem-array remains entirely idle! =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


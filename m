Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35763 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbcGEEg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jul 2016 00:36:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bKI5v-0006R6-TL
	for linux-btrfs@vger.kernel.org; Tue, 05 Jul 2016 06:36:25 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 06:36:23 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 06:36:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
Date: Tue, 5 Jul 2016 04:36:17 +0000 (UTC)
Message-ID: <pan$24a85$f8ea2308$7779210e$62f73b89@cox.net>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
	<CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Mon, 04 Jul 2016 23:13:52 +0200 as excerpted:

> [Tomasz Kusmierz wrote...]

>> Problem is that stuff on this filesystem moves so slowly that it's hard
>> to remember historical events ... it's like AWS glacier. What I can
>> state with 100% certainty is that:
>> - files that are affected are 2GB and over (safe to assume 4GB and
>> over)
>> - files affected were just read (and some not even read) never written
>> after putting into storage
>> - In the past I've assumed that files
>> affected are due to size, but I have quite few ISO files some backups
>> of virtual machines ... no problems there - seems like problem
>> originates in one folder & size > 2GB & extension .mkv

This reads to me like a security-video use-case, very large media files 
that are mostly WORN (write-once read-never).  These files would be time-
based and likely mostly the same size, tho compression could cause them 
to vary in size somewhat.

I see a comment that I didn't quote, to the effect that you did a balance 
a half a year ago or so.

Btrfs data chunk size is nominally 1 GiB.  However, on large enough 
btrfs, I believe sometimes dependent on striped-raid as well (the exact 
conditions aren't clear to me), chunks are some multiple of that.  With a 
6-drive btrfs raid10, which we know does two copies and stripe as wide as 
possible, so 3-device-wide stripes here with two mirrors of the stripe, 
I'd guess it's 3 GiB chunks, 1 GiB * 3-device stripe width.

Is it possible that it's 3 GiB plus files only that are affected, and 
that the culprit was a buggy balance shifting around those big chunks 
half a year or whatever ago?

As to your VM images not being affected, their usage is far different, 
unless they're simply archived images, not actually in use.  If they're 
in-use not archived VM images, they're likely either highly fragmented, 
or you managed the fragmentation with the use of the NOCOW file 
attribute.  Either way, the way the filesystem treats them as opposed to 
very large write-once files that are likely using whole data chunks is 
very different, and it could well be that difference that explains why 
the video files were affected but the VM images not.

Given the evidence, a buggy balance would indeed be my first suspect, but 
I'm not a dev, and I haven't the foggiest what sort of balance bug might 
be the trigger here, or whether it has been fixed at all, let alone when, 
if so.

But of course that does suggest a potential partial proof and a test.  
The partial proof would be that none of the files created after the 
balance should be affected.

And the test, after backing up newer video files if they're likely to be 
needed, try another balance and see if it eats them too.  If it does...

If it doesn't with a new kernel and tools, you might try yet another 
balance with the same kernel and progs you were likely using half a year 
ago when you did that balance, just to nail down for sure whether it did 
eat the files back then, so we don't have to worry about some other 
problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


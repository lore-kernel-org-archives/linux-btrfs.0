Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37099 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbACNMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 08:12:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7OV3-0002vW-Jl
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 14:12:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 14:12:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 14:12:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: I need to P. are we almost there yet?
Date: Sat, 3 Jan 2015 13:11:57 +0000 (UTC)
Message-ID: <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A7D3D1.10508@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bob Marley posted on Sat, 03 Jan 2015 12:34:41 +0100 as excerpted:

> On 29/12/2014 19:56, sys.syphus wrote:
>> specifically (P)arity. very specifically n+2. when will raid5 & raid6
>> be at least as safe to run as raid1 currently is? I don't like the idea
>> of being 2 bad drives away from total catastrophe.
>>
>> (and yes i backup, it just wouldn't be fun to go down that route.)
> 
> What about using btrfs on top of MD raid?

The problem with that is data integrity.  mdraid doesn't have it.  btrfs 
does.

If you present a single mdraid device to btrfs and run single mode on it, 
and one copy on the mdraid is corrupt, mdraid may well simply present it 
as it does no integrity checking.  btrfs will catch and reject that, but 
because it sees a single device, it'll think the entire thing is corrupt.

If you present multiple devices to btrfs and run btrfs raid1 mode, it'll 
have a second copy to check, but if a bad copy exists on each side and 
that's the copy mdraid hands btrfs, again, btrfs will reject it, having 
no idea there's actually a good copy on the mdraid underneath; the mdraid 
simply didn't happen to pick that copy to present.

And mdraid-5/6 doesn't make things any better, because unless there's a 
problem, mdraid will simply read and present the data, ignoring the 
parity with which it could probably correct the bad data (at least with 
raid6).

The only way to get truly verified data with triple-redundancy or 2X 
parity or better is when btrfs handles it, as it keeps and actually 
checks checksums to verify.

But btrfs raid56 mode should be complete with kernel 3.19 and presumably 
btrfs-progs 3.19 tho I'd give it a kernel or two to mature to be sure.
N-way-mirroring (my particular hotly awaited feature) is next up, but 
given the time raid56 took, I don't think anybody's predicting when it'll 
be actually in-tree and ready for use.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


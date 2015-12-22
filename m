Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33901 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbLVPo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 10:44:59 -0500
Received: by mail-ig0-f171.google.com with SMTP id m11so51807792igk.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 07:44:59 -0800 (PST)
Subject: Re: btrfs check inconsistency with raid1, part 1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
 <566E584B.5040104@cn.fujitsu.com>
 <CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
 <566E77FA.3050405@cn.fujitsu.com>
 <CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
 <CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
 <5677592F.5000202@cn.fujitsu.com>
 <CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
 <567762A3.9060007@cn.fujitsu.com>
 <20151222020529.1ac0c913@jupiter.sol.kaishome.de>
 <5678A5CC.7050900@cn.fujitsu.com>
 <20151222024804.5c4f7da2@jupiter.sol.kaishome.de>
 <pan$30f15$f6f8b13b$d72dd248$aaee075f@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56796FCB.5080303@gmail.com>
Date: Tue, 22 Dec 2015 10:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <pan$30f15$f6f8b13b$d72dd248$aaee075f@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-22 05:23, Duncan wrote:
> Kai Krakow posted on Tue, 22 Dec 2015 02:48:04 +0100 as excerpted:
>
>> I just wondered if btrfs allows for the case where both stripes could
>> have valid checksums despite of btrfs-RAID - just because a failure
>> occurred right on the spot.
>>
>> Is this possible? What happens then? If yes, it would mean not to
>> blindly trust the RAID without doing the homeworks.
>
> The one case where btrfs could get things wrong that I know of is as I
> discovered in my initial pre-btrfs-raid1-deployment testing...
I've had exactly one case where I got _really_ unlucky and had a bunch 
of media errors on a BTRFS raid1 setup that happened to result in 
something similar to this.  Things happened such that one copy of a 
block (we'll call this one copy 1) had correct data, and the other 
(we'll call this one copy 2) had incorrect data, except that one copy of 
the metadata had the correct checksum for copy 2, and the other metadata 
copy had a correct checksum for copy 1, but, due to a hash collision, 
the checksum for the metadata block was correct for both copies.  As a 
result of this, I ended up getting a read-error about 25% of the time 
(which then forced a re-read of the data, the correct data about 37.5% 
of the time, and incorrect data the remaining 37.5% of the time.  I 
actually ran the numbers on how likely this was to happen (more than a 
dozen errors on different disks in blocks that happened to reference 
each other, and a hash collision involving a 4 byte difference between 
two 16k blocks of data), and it's a statistical impossibility (It's more 
likely that one of Amazon or Google's data-centers goes offline due to 
hardware failures than it is that this will happen again).  Obviously it 
did happen, but I would say it's such a unrealistic edge case that you 
probably don't need to worry about it (although I learned _a lot_ about 
the internals of BTRFS in trying to figure out what was going on).
>
[...snip...]
>
>  From all I know and from everything others told me when I asked at the
> time, which copy you get then is entirely unpredictable, and worse yet,
> you might get btrfs acting on divergent metadata when writing to the
> other device.
>
This is indeed the case.  Because of how BTRFS verifies checksums, 
there's a roughly 50% chance that the first read attempt will result in 
picking a mismatched checksum and data block, which will trigger a 
re-read which has an independent 50% chance of again picking a mismatch, 
resulting in a 25% chance that any read that actually goes to the device 
returns a read error.  The remaining 75% of the time, you'll get either 
one block or the other.  These numbers of course get skewed by the VFS 
cache.  In my case above, the file that was affected was one that is 
almost never in cache when it gets accessed, so I saw numbers relatively 
close to what you would get without the cache.

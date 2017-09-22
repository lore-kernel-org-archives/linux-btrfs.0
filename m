Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36450 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdIVHdq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 03:33:46 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dvISs-0008JZ-Ho
        for linux-btrfs@vger.kernel.org; Fri, 22 Sep 2017 09:33:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Running compsize utility on btrfs compress mount point
Date: Fri, 22 Sep 2017 07:33:28 +0000 (UTC)
Message-ID: <pan$90b2f$787f80f3$ffd281f4$5a524b20@cox.net>
References: <CAP9W88hYMu5y-7MjKnSpTymo8WiBsZ1sag-NY9a_kLfqctaz5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

shally verma posted on Fri, 22 Sep 2017 12:01:32 +0530 as excerpted:

> In response to my question in another thread:
>> Is there any command that i can run to confirm file has been compressed?
> 
> I've gotten response from Duncan:
>>>There is the quite recently posted (and actively updated since then)
>>>compsize command.
> 
>>>https://github.com/kilobyte/compsize
> 
> On running compsize on btrfs mount point created, I get following:
> 
> Type       Perc     Disk Usage   Uncompressed Referenced
> Data        50%      128K         256K         256K
> zlib        50%      128K         256K         256K
> Data       100%       10G          10G          10G
> none       100%       10G          10G          10G
> 
> but then how do I interpret above information?

Hmm... Looks like you got hit by the live-repo phenomenon.  I've not
updated for a few days (reported sync time was last Sat), but was
just running it a few hours ago, and my output was a bit more
intuitively ordered.

The way it's /supposed/ to work (unless it's changing, it /is/ a rather
new tool after all), the first line (Data) should be the aggregate
total and average compression percentage of all used compression types,
with the following lines displaying values for each compression type
compsize found, on its own.

IOW, for the above I'd have expected just three lines (plus header),
something like this:

Data	100%	 10G	 10G	 10G
zlib	 50%	128K	256K	256K
none	100%	 10G	 10G	 10G

(In this case the 128K compressed is so small it's a rounding
error in the 10G full size, so the combined data line and
the none line will appear the same.)

I'd suggest trying to pull any updates and rebuilding.  If that
doesn't fix it, try checking out a specific commit, say the 160c335e7
that was HEAD last Saturday (16th) when I built, and see if the output
comes out a bit more sane.  If that works, then the problem must be in
either 94d98028b from Tuesday, or caed4fdcd, HEAD as I'm looking at it
now, from Thursday, if you pulled after it.  If the author doesn't
popup in this thread, you might bisect to the specific commit and
file a github issue on it.

If 160c335e7 doesn't give you saner output, then there's some other
difference between our systems that must account for your output
above.  FWIW, gcc 6.4.0 (gentoo) here, amd64, kernel 4.13, glibc
2.25-r5 (the -r5 indicating gentoo patch level), btrfs-progs 4.12.
I have CFLAGS available too if you need 'em. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


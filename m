Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57380 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbcCGUnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Mar 2016 15:43:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ad1zp-0005QK-6T
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 21:43:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 21:43:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 21:43:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Mon, 7 Mar 2016 20:43:06 +0000 (UTC)
Message-ID: <pan$57259$25de635e$21422ee0$36b10501@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
	<20160307084235.GB6939@torres.zugschlus.de>
	<CAJCQCtTfmh6rLfB0kg0HjAwoHsjaR3m1LygBaVTjirMyenwa8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 07 Mar 2016 12:44:20 -0700 as excerpted:

> On Mon, Mar 7, 2016 at 1:42 AM, Marc Haber <mh+linux-btrfs@zugschlus.de>
> wrote:
>> And this is really something to be proud of? I mean, this is a file
>> system that is part of the vanilla linux kernel, not marked as
>> experimental or something, and you're still concerned about file
>> systems that were made a year ago? This is a new experience for me.
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/
tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.4.4
> 
> "Btrfs is under heavy development, and is not suitable for any uses
> other than benchmarking and review. The Btrfs disk format is not yet
> finalized."
> 
> I thought the 2nd sentence was removed a long time ago but I'm seeing it
> in the current branch and 4.1.y. Is this a bug?

AFAIK, this is the still "semi-scary" wording that was left after the 
_really_ scary "eat your babies" level experimental warning was stripped, 
and it remains more or less literally the case, certainly the last 
sentence, tho I'd quibble that the "not suitable for any uses other than 
benchmarking and review" is a bit conservative, and the "disk format is 
not yet finalized" bit, while literally true, doesn't have the 
implications one might initially think, because there _is_ a commitment 
to support all disk formats available since btrfs was kernel-mainlined, 
so while the disk format can and does still occasionally have small 
changes (think features like skinny-metadata and the metadata changes 
necessary for raid56 support), these are all handled by incompatibility 
flags such that a kernel that doesn't understand them will refuse to 
mount a filesystem with them enabled, while newer kernels will still 
mount filesystems with them not enabled.

And of course rather famously, early in the second kernel series after 
mainlining, some change made it in that apparently caused some btrfs 
Linus was using _not_ to mount, and he rightly blistered the btrfs devs 
for it, because it screwed up his ability to kernel bisect over that 
period with the system he was using btrfs on.  Linus said that's not the 
way things work in mainline and he was right.  It hasn't happened again.  
And that was when btrfs still had the much more severe experimental label 
applied, so particularly now that it's gone, yes, there may be disk 
format changes, but they are covered by incompatibility flags and all 
kernels going forward from mainlining are going to support older formats 
in addition to any newer formats, because that's the way it is.

But I'd probably word the first sentence somewhat differently, saying 
that you should have backups and be prepared to use them if you're using 
btrfs, and that it's not suitable for production systems yet, but 
omitting the only suitable for benchmarking and review wording.

Regardless, I believe we've definitely established that while it's in the 
mainline kernel and is no longer experimental, there's still quite some 
warning there, contrary to Mark Habor's claim otherwise.  And indeed, if 
following that warning literally, review and benchmarking is all he'd be 
doing with it, so beyond that is certainly on the user... or distro 
making claims to the contrary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


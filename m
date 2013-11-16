Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37513 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752127Ab3KPWRm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 17:17:42 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52208 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VhoBS-003jPp-0y
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 15:17:42 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to fix/remove "csum failed ino" error
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$8e6a1$4baf8046$11437360$3e14849c@cox.net>
Date: Sat, 16 Nov 2013 15:17:27 -0700
Message-Id: <FF13FC26-BC64-4B6B-9219-7798813917A7@colorremedies.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com> <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com> <CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com> <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com> <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com> <CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com> <CAOMFOmUXKntgXnOTV=ZVPs==1Tun4KZg-_oGxaiM5Xc5NpP2zA@mail.gmail.com> <20131116122342.GT4315@carfax.org.uk> <pan$8e6a1$4baf8046$11437360$3e14849c@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 16, 2013, at 1:54 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Hugo Mills posted on Sat, 16 Nov 2013 12:23:42 +0000 as excerpted:
> 
>> On Sat, Nov 16, 2013 at 04:06:10AM -0800, Anatol Pomozov wrote:
> 
>>> Follow-up for the issue. I stuck with this "invalid csum for free space
>>> extent" error. Could anyone explain what does it mean? If this is not
>>> data and just a free space, why do we care about its checksum? And if
>>> we do really care then btrfs should have a way to fix this error. I can
>>> "fix" a file checksum error by removing the file, but how to "fix" free
>>> space extent checksum error?
>> 
>> Probably drop the free space cache and rebuild it.
> 
> If you check the thread history (well, at least based on my 
> interpretation thereof, perhaps I'm wrong), he tried that.  Apparently 
> there's a problem in the free-space cache area that appears to go away 
> when he drops cache, but the moment he lets it rebuild, the problem 
> reappears.
> 
> Almost as if there's a physical defect on the hardware itself, but the 
> usual automatic hardware sector relocate functionality isn't triggering 
> for some reason, so every time he tries to use that physical location, 
> which happens to be in the middle of where btrfs tries to put its space-
> cache, the csum errors trigger.

Bad sectors should show up very clearly in dmesg, so maybe we need a full dmesg from the OP. Any case of a write failure is grounds for tossing that device as completely and immutably broken.


> I guess btrfs doesn't (yet?) work with badblocks output as ext* (and 
> reiserfs, which I'm personally more familiar with) does?  I don't see 
> anything listed in the btrfs or mkfs.btrfs manpages for it, at least.

I wouldn't expect a modern file system to track bad sectors. This is firmware domain these days. All available data indicates when drives start to develop many bad sectors, especially the case where write failures occur means all reserve sectors are unavailable, that the drive is self-destructing with material either damaging the head or peripheral areas of the drive (surface coating detachment). I think it's a waste of resources to support this brick, the drive should just be replaced.


Chris Murphy


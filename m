Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab3KPUyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 15:54:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vhmsv-0005wL-PR
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 21:54:29 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 21:54:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 21:54:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to fix/remove "csum failed ino" error
Date: Sat, 16 Nov 2013 20:54:09 +0000 (UTC)
Message-ID: <pan$8e6a1$4baf8046$11437360$3e14849c@cox.net>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
	<CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
	<CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
	<CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
	<CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
	<CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com>
	<CAOMFOmUXKntgXnOTV=ZVPs==1Tun4KZg-_oGxaiM5Xc5NpP2zA@mail.gmail.com>
	<20131116122342.GT4315@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 16 Nov 2013 12:23:42 +0000 as excerpted:

> On Sat, Nov 16, 2013 at 04:06:10AM -0800, Anatol Pomozov wrote:

>> Follow-up for the issue. I stuck with this "invalid csum for free space
>> extent" error. Could anyone explain what does it mean? If this is not
>> data and just a free space, why do we care about its checksum? And if
>> we do really care then btrfs should have a way to fix this error. I can
>> "fix" a file checksum error by removing the file, but how to "fix" free
>> space extent checksum error?
> 
> Probably drop the free space cache and rebuild it.

If you check the thread history (well, at least based on my 
interpretation thereof, perhaps I'm wrong), he tried that.  Apparently 
there's a problem in the free-space cache area that appears to go away 
when he drops cache, but the moment he lets it rebuild, the problem 
reappears.

Almost as if there's a physical defect on the hardware itself, but the 
usual automatic hardware sector relocate functionality isn't triggering 
for some reason, so every time he tries to use that physical location, 
which happens to be in the middle of where btrfs tries to put its space-
cache, the csum errors trigger.

I guess btrfs doesn't (yet?) work with badblocks output as ext* (and 
reiserfs, which I'm personally more familiar with) does?  I don't see 
anything listed in the btrfs or mkfs.btrfs manpages for it, at least.

Is such support planned?  One would expect it given that btrfs appears to 
be the assumed successor to ext* series' default Linux filesystem title.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


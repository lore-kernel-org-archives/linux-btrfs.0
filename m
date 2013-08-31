Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44803 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab3HaLli (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 07:41:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VFjYf-0006b6-3T
	for linux-btrfs@vger.kernel.org; Sat, 31 Aug 2013 13:41:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 13:41:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 13:41:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Device delete returns "unable to go below four devices on
 raid10" on 5 drive setup
Date: Sat, 31 Aug 2013 11:41:17 +0000 (UTC)
Message-ID: <pan$a32ff$228f75f0$a509de6b$7bb8cf73@cox.net>
References: <1377943975.5426.17.camel@pc-steven.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steven Post posted on Sat, 31 Aug 2013 12:12:55 +0200 as excerpted:

> Btrfs Btrfs v0.19

> The system is running Debian Wheezy (kernel 3.2.0-4-amd64 #1 SMP Debian
> 3.2.46-1 x86_64).
> 
> Is this something known (and possibly resolved in a later version), or
> should I open a bug report about it? Could it be that the device removal
> was completed, but still shows as part of the array for some reason?

As a sysadmin running btrfs not a dev, I don't know about your specific 
issue, but in general, be aware that btrfs (both the kernelspace 
filesystem and the userspace btrfs-tools) is still experimental and under 
heavy development.  As such, it's strongly recommended to run the latest 
stable series kernel at the oldest, if not the rcs (here, I run a git 
kernel, but don't normally update to the new development series until rc2 
or 3, which will hopefully avoid any serious data-destroying bugs, but of 
course on a development filesystem backups are even more important than 
normal in any case, so...), unless you have a specific known problem 
preventing you from doing so.

That would be 3.10.x, with 3.11 late soon to be out now.  Some people do 
run one behind that, so the 3.9 series, but older than that and trying 
something that isn't as ancient as the hills is generally a strong first 
recommendation, both because many known bugs have been fixed so you're 
actually taking a bigger risk with older, and because the bug reports 
simply aren't as useful that far back.

Similarly, the git master branch of btrfs-tools is deliberately kept 
stable and usable -- development happens on other branches and is merged 
-- so a live-git build not older than a couple months (that being about 
the length of a kernel cycle so they'll be of similar age) is 
recommended.  0.19 is a very old release tho it's the latest actual 
release, but there's a much newer 0.20-rc1 tagged if you still don't feel 
comfortable with a live-git build.

All this and more is covered on the btrfs wiki, found at

https://btrfs.wiki.kernel.org/

If you wish to continue testing btrfs I'd suggest you read up a bit 
there, as if you didn't know the above, there's surely a lot else covered 
there that you're not aware of -- and on a development filesystem that 
lack of knowledge could well bite you!

Alternatively, testing a development filesystem certainly isn't for 
everybody, and the fact that you're running an old 3.2 kernel could be a 
hint that you're looking for something a bit more conservative and stable 
than a development filesystem, making it a poor fit for your needs at 
best.  But that's for you to decide.  If you're happy being a tester and 
either have your data well backed up or otherwise consider it losable in 
testing if things go wrong, go for it, but do it right, with current 
kernel and tools so your tests at least have some value if things /do/ go 
wrong! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


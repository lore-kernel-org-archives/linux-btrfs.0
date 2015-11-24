Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55434 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbbKXGqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 01:46:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a17Ms-0004a0-Qv
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 07:46:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:46:22 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:46:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: shall distros run btrfsck on boot?
Date: Tue, 24 Nov 2015 06:46:18 +0000 (UTC)
Message-ID: <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
References: <1448337754.14125.33.camel@scientia.net>
	<pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
	<1448340211.14125.44.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 24 Nov 2015 05:43:31 +0100 as
excerpted:

[Duncan wrote...]
>> The btrfs kernel code itself detects and often
>> corrects many problems, and btrfs check is simply not recommended for
>> automatic at-boot scheduling -- if the kernel code can't fix it without
>> intervention, then the problem is too serious to be fixed without
>> intervention by some scheduled btrfs check run, as well.

> I once had an issue with a btrfs, where the kernel didn't show anything
> but btrfsck did...(not the one Qu's currently looking into).


That wouldn't be entirely uncommon, because as Eric mentions, btrfs check 
is intended to be thorough, where the kernel mount-time check is intended 
to be fast.

But of course, as Eric also mentions, that's yet another reason you don't 
want btrfs check running at boot... it's *SSLLLOOWWWWW*, because it's 
being thorough.

There are times you'd want to run btrfs check, the reason it's even there 
as a subcommand, but that would be when the filesystem either fails to 
mount, or when it exhibits other serious symptoms of problems... send and 
balance fails, remount-readonlys, nasty messages in the kernel log, etc.  

Careful admins may want to run btrfs check periodically in any case, but 
because it /is/ slow, and because it /isn't/ supposed to be needed for 
routine issues, they probably don't want to be doing it at boot when 
everything else is waiting on it.

Because you don't want your boot taking hours...  And in many cases, if a 
check /is/ going to take hours and even then not guarantee that the 
filesystem is workable, admins may want to simply blow away the 
filesystem, recreate it, and copy everything back to it from backups, 
rather than spending that much time on something that still has a good 
chance of being broken afterward.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36296 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3HYK3o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 06:29:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VDXZn-0005hE-8I
	for linux-btrfs@vger.kernel.org; Sun, 25 Aug 2013 12:29:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Aug 2013 12:29:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Aug 2013 12:29:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: default mount options 3.10
Date: Sun, 25 Aug 2013 10:29:25 +0000 (UTC)
Message-ID: <pan$1a1a3$f154c1a1$c83dacd2$30613a32@cox.net>
References: <52172DB0.1000701@gmail.com> <20130823122942.18548b21@
	xavier-ThinkPad-T60p.lan> <4901822.EYC3h3vBSD@merkaba> <
	pan$348ab$94e882cf$7b189911$f0786ffb@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sat, 24 Aug 2013 12:23:18 +0000 as excerpted:

> Martin Steigerwald posted on Fri, 23 Aug 2013 14:58:07 +0200 as
> excerpted:
> 
>> Am Freitag, 23. August 2013, 12:29:42 schrieb Xavier Bassery:
>>> On Fri, 23 Aug 2013 11:38:56 +0200
>>> 
>>> David Kofler <dkofler92@googlemail.com> wrote:

[mount-option discussion]

One that I omitted in my previous discussion because it's not btrfs 
specific, but that makes a rather larger difference than normal on btrfs, 
especially with lots of snapshots, is noatime.  Unfortunately, for legacy 
reasons, that can't be the default, but unless you're running mutt (which 
needs atime to track read messages except with mbox) or something 
similar, there really are very few even half-modern apps that require 
atime, and it really is best to run with noatime, saving the constant 
access-time update writes.

The general kernel default is now relatime, which is a compromise that 
works reasonably well on most filesystems, but even that tends to trigger 
way more atime updates and thus de-dupped metadata when dealing with 
btrfs snapshots than would be optimal.

Similarly, limited-write-cycle SSDs will do best with noatime.  If you 
happen to be running btrfs on ssd as I am, well...

So just run with noatime unless you are running something (like mutt) 
that is known to need atimes, and then, preferably limit it to a 
particular dedicated filesystem, perhaps choosing a filesystem other than 
btrfs or at least a limited-snapshot btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


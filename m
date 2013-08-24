Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50168 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab3HXMXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 08:23:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VDCsT-0002TL-CV
	for linux-btrfs@vger.kernel.org; Sat, 24 Aug 2013 14:23:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 14:23:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 14:23:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: default mount options 3.10
Date: Sat, 24 Aug 2013 12:23:18 +0000 (UTC)
Message-ID: <pan$348ab$94e882cf$7b189911$f0786ffb@cox.net>
References: <52172DB0.1000701@gmail.com> <20130823122942.18548b21@
	xavier-ThinkPad-T60p.lan> <4901822.EYC3h3vBSD@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Fri, 23 Aug 2013 14:58:07 +0200 as excerpted:

> Am Freitag, 23. August 2013, 12:29:42 schrieb Xavier Bassery:
>> On Fri, 23 Aug 2013 11:38:56 +0200
>> 
>> David Kofler <dkofler92@googlemail.com> wrote:
>> > Hi,
>> > can someone tell me which mount options are included in "defaults"
>> > mount option? Couldn't find this in BTRFS Wiki. I'm using Debian
>> > Wheezy 7.1 and Linux kernel 3.10.6.
>> > Thanks in advance.
>> 
>> Hi,
>> you've looked at the wrong place.
>> From mount man page:
>> 
>> FILESYSTEM INDEPENDENT MOUNT OPTIONS defaults : Use default options:
>> rw, suid, dev, exec, auto, nouser, async
> 
> That are just VFS options, no BTRFS specific ones.
> 
> A good way is to look at output of "mount" and "cat /proc/mounts". It
> can differ from situation as well, for example SSD or not.
> 
> But some hints at BTRFS default options are also on (search for
> "default"):
> 
> https://btrfs.wiki.kernel.org/index.php/Mount_options

FWIW, space_cache seems to be the default now, and for ssds (detected if 
sysfs has a device rotation value of zero), ssd.  There's some others 
that are the normal default now, but aren't listed (flushoncommit is 
one), as running with those features disabled can increase performance 
but also dramatically increases chance of data loss, so it's not 
recommended.

Compression options are the big ones you may want to add, but they aren't 
default as usage is too varied for them to be a sane default.  And of 
course ssd if it applies and isn't detected, and possibly ssd_spread.

I recommend autodefrag for general use, as well, but you'll want to have 
it enabled when you first start copying data to the filesystem, and some 
distros don't enable it by default and setup a system on btrfs, which 
means there's fragmentation to begin with, and performance will probably 
be bad for awhile (even on newly setup systems!) when the option is first 
enabled as a result.  You can readup on defrag on the wiki for a defrag 
command that should fix the problem, but unfortunately the command isn't 
as straightforward as one might expect.  (Also note that if compression 
is enabled, a compressed file over a certain size, 128 MiB IIRC, but I'm 
not sure if that's compressed or uncompressed size, will appear 
fragmented to filefrag no matter what.  That's an artifact of the way 
btrfs handles compression.)

Inode_cache LOOKS good, but beware; people have reported problems with it 
and unsafe shutdowns or the like.  So it's probably best to avoid it 
unless you really need it for your workload and judge it to be worth the 
risk.  That's why it's not the default, yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


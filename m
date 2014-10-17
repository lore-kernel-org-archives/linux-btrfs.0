Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46224 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaJQLie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 07:38:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xf5rd-0007C3-C3
	for linux-btrfs@vger.kernel.org; Fri, 17 Oct 2014 13:38:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 13:38:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 13:38:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unexplainable corruptions 3.17.0
Date: Fri, 17 Oct 2014 11:38:22 +0000 (UTC)
Message-ID: <pan$6eb1$c20caee6$477f612f$2b524b4d@cox.net>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
	<20141017080202.GA3604@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo posted on Fri, 17 Oct 2014 16:02:03 +0800 as excerpted:

> On Thu, Oct 16, 2014 at 11:17:26AM +0200, Tomasz Torcz wrote:
>> Hi,
>> 
>>   Recently I've observed some corruptions to systemd's journal
>> files which are somewhat puzzling. This is especially worrying as this
>> is btrfs raid1 setup and I expected auto-healing.
>> 
>>   System details: 3.17.0-301.fc21.x86_64
>> btrfs: raid1 over 2x dm-crypted 6TB HDDs.
>> mount opts: rw,relatime,seclabel,compress=lzo,space_cache
>> 
>>   Broken files are in /var/log/journal directory. This directory
>> is set NOCOW with chattr, all the files within too.
> 
> Does scrub work for you?

NOCOW implies no checksum, so scrub shouldn't be able to help.

Some time back people were reporting problems with corrupted journald 
journal files, but I've seen no such reports in a long time.

This isn't likely much help for your (OP's) use-case, but FWIW, here's 
what I did with journald.

When I switched to systemd here, I set it to volatile storage only, and 
kept syslog-ng setup for longer term storage.  I arranged things so 
journald's volatile logs had enough room to grow for a normal single 
session in the /run/log tmpfs.  That gives me the nice journald systemd 
integration, systemctl status reporting the last few log entries for a 
specific service, etc.

But everything still gets passed to syslog-ng (which being on gentoo, I 
set the systemd USE flag for, so it integrates nicely) as well, and that 
spits out my normal text logs just as I had it setup to do long before 
systemd ever came along.  It's those that I keep on non-volatile storage 
so they stick around thru a reboot, and they play nicely with btrfs so 
I've not had to worry about what journald's binary files might do.

Btw, unless you have a need for relatime, noatime is strongly recommended 
for btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


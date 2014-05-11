Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52567 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbaEKCv7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 22:51:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WjJrq-0002o6-2D
	for linux-btrfs@vger.kernel.org; Sun, 11 May 2014 04:51:58 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 04:51:58 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 04:51:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to mount filesystem
Date: Sun, 11 May 2014 02:51:46 +0000 (UTC)
Message-ID: <pan$9ae5$6b264925$51c778dc$642cda8e@cox.net>
References: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
	<230A0896-9CCD-4B48-A0D2-4BB5932BDEAB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 10 May 2014 10:49:07 -0600 as excerpted:

> On May 8, 2014, at 7:06 AM, Chris Korent <ckorent@gmail.com> wrote:
> 
>> Linux sysresccd 3.10.35-std420-amd64 #2 SMP Wed Apr 2 18:31:51 UTC
>> 
>> btrfs --version Btrfs v3.14.1
> 
> I'm uncertain if this is an OK combination. I'm under the impression
> that the kernel should be the same or newer version than progs. Also
> kernel 3.10 is old in Btrfs terms. Before altering the file system
> further, I'd try a normal mount with the newest kernel you can get your
> hands on.

In theory it's OK as the progs are supposed to be backward compatible at 
least some way (I wouldn't try anything pre-2.6.32 for sure as that was 
the last big format change, IIRC, and anything pre-3.5 or so may work but 
I'd not suggest it), but... there are of course bugs, and btrfs is still 
under intense enough development that there are bugs being fixed every 
kernel...

So while yes, in theory the above version spread should work, the 
recommendation to try the latest stable-kernel from the latest stable 
series 3.14.x is an absolutely solid one, and in fact we're late enough 
in the 3.15-rc cycle now that trying with that is ultimately the best bet.

In fact, as the output from mkfs.btrfs suggests, running the latest 
stable at the oldest really is recommended, and kernel is a bit more 
critical in that regard than btrfs-progs, since the kernel is what 
actually handles the filesystem and thus running an old kernel really is 
basically uselessly risking your btrfs and the data on it to known and 
now fixed bugs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


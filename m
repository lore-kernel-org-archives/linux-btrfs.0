Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60617 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaAZSsg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 13:48:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W7Ul0-0004wv-Gc
	for linux-btrfs@vger.kernel.org; Sun, 26 Jan 2014 19:48:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 19:48:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 19:48:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: bad block and io errors
Date: Sun, 26 Jan 2014 18:48:11 +0000 (UTC)
Message-ID: <pan$52d14$c15afa2b$4b64e8fe$6dff9d36@cox.net>
References: <CANjusZfFXaNZcMew+6tWfKVdoKuVv+cSCWefvzCr0nMMJJk2sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G. Michael Carter posted on Sun, 26 Jan 2014 10:11:08 -0500 as excerpted:

> I've basically got four questions:
> 
> 1.  How do I repair, or drop block 35435896033280?
> 
> 2.  How do I identify which drive out of 5 this block is on?
> 
> 3.  How do I detect which drive is causing the errno=-5 IO failure
> 
> 4.  How do I identify what files I'm going to loose by this block
> problem?

As a simple btrfs user myself (not a dev, tho hopefully they'll get you a 
better answer later), I can't answer most of these.  But #4...

btrfs scrub will normally report (in dmesg, not in the command output) 
what file is associated with a checksum failure if it can't fix it from a 
second copy if available.

That does assume that the failure is in a data block, not metadata, but 
since metadata defaults to raid1 mode (if multi-device, dup mode if 
single device) anyway, you'll likely have a second copy to fix from, in 
that case, unless of course you configured single or raid0 metadata, in 
which case you're likely but predictably screwed as you're deliberately 
configuring less reliability when you chose those modes for metadata, and 
I'd suggest mkfs and restore from backup.

With the file information, you can delete the file, and hopefully when 
the block is rewritten at some point in the future, the drive will 
automatically mark it bad and rotate in one of its spares.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


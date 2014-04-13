Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58790 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaDMECt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 00:02:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZBd2-0007kK-65
	for linux-btrfs@vger.kernel.org; Sun, 13 Apr 2014 06:02:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 06:02:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 06:02:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: very slow btrfs filesystem: any data needed before I wipe it?
Date: Sun, 13 Apr 2014 04:02:36 +0000 (UTC)
Message-ID: <pan$618bb$88ff516$fa62072a$7143669d@cox.net>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com>
	<20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com>
	<20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org>
	<20140325014956.GG11533@merlins.org> <20140412202542.GW7322@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 12 Apr 2014 13:25:42 -0700 as excerpted:

> If I mount with ro,recovery, then it's actually normal speed to copy
> data off it, quite weird. It seems like btrfs' background processes are
> grinding the FS down to a halt, and I didn't turn on autodefrag.

What happens if you simply mount it ro, without the recovery option?  Is 
it still normal-speed or is that slow as a rw mount?

Speed hasn't been an issue here, but FWIW I normally keep my rootfs ro 
mounted as I decided that's lower risk in the event of a system crash or 
power outage and I don't actually /need/ it rw most of the time (I have a 
dedicated /var/log, /home on an entirely separate btrfs, and the bits of 
/var that need to be writable in normal operation symlinked into
/home/var/), only mounting the rootfs rw to update or do other system 
maintenance.

If a ro filesystem is normal speed but rw slow, the problem must be in 
the write path, which is what I suspect.  If a ro filesystem is slow and 
only a recover,ro filesystem is fast, then there's something strange 
going on with btrfs internals that recovery obviously bypasses.  Knowing 
one way or the other should definitely help to pin things down.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


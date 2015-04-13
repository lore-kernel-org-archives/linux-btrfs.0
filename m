Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbbDMEM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 00:12:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YhVjw-0000mj-6c
	for linux-btrfs@vger.kernel.org; Mon, 13 Apr 2015 06:12:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 06:12:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 06:12:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mlocate/updatedb and btrfs subvolume mounts
Date: Mon, 13 Apr 2015 04:12:41 +0000 (UTC)
Message-ID: <pan$3396c$51a072b0$71501292$8af8c3ee@cox.net>
References: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
	<20150412201107.GA4711@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Sun, 12 Apr 2015 16:11:07 -0400 as excerpted:

> Since these are simple binds (not rbinds), they don't see any other
> filesystems, period.  They do see btrfs subvolumes, though.

Tho... for systemd users...

Do note that systemd plays with the kernel's shared-subtree "private" 
default, switching it to shared for /.  The idea is that this makes 
containers "just work", since mounts on / get propagated into containers 
as well.  Unfortunately, the kernel default is private because that's the 
way the kernel behaved before the shared-subtree feature was introduced, 
and systemd changed that, breaking a lot of assumptions and scripts, 
including my backup script, along the way.

I don't use subvolumes, but do use a mount --bind of / elsewhere, so I 
can backup /, ALL of / (including subtrees hidden on the primary mount by 
overmounts), without any danger of crossing mount-points, since the bind-
mount was always private.  I've been doing this since well before I 
switched to either btrfs or systemd, and probably since before the kernel 
and mount introduced the shared-subtree feature, and it has worked very 
well.

But then systemd came around and decided that the "private" default-mount 
wasn't good enough for systemd, and that it was now going to default to 
shared.  Of course that broke existing solutions all over the place, but 
as we know, care to keep from breaking existing solutions isn't a 
priority, to say the least, with systemd, so...

So I had to add "private" to my / mount options, so mounting the backup 
partition on /mnt/bk wouldn't cause it to mount on the already bind-
mounted /mnt/rootbind that I was trying to backup, as well.

Link to a systemd-devel thread describing the change (with a link to the 
commit) and the systemd-ish way to undo it using a unit file (as opposed 
to the option I added to the fstab / entry instead).

http://lists.freedesktop.org/archives/systemd-devel/2013-
February/008558.html

Also see the mount(8) manpage under shared subtree operations, and the 
kernel documentation file in Documentation/filesystems/sharedsubtree.txt.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


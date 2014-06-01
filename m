Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58256 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaFAJHY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jun 2014 05:07:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wr1jc-0007X0-Ml
	for linux-btrfs@vger.kernel.org; Sun, 01 Jun 2014 11:07:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 11:07:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 11:07:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: superblock corruption, cannot obtain data
Date: Sun, 1 Jun 2014 09:07:10 +0000 (UTC)
Message-ID: <pan$50e07$24b3b8c1$19fb9330$61d7b351@cox.net>
References: <CADVynFArng7kg9vgaeus_FbsQXXVUZa6kcNBYHxLER2RSbfPbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shaun Reich posted on Sat, 31 May 2014 23:51:26 -0400 as excerpted:

> at some point, my /home randomly(?) went into -ro as i noticed writes
> were not working. Checked dmesg which had some backtraces which i
> ignored. So I simply rebooted, only to find out it wouldn't come back.
> 
> so now my /home is stuck on here, I was literally going to do my round
> of backups tonight. It's not extremely critical..but to reproduce my
> data it'll still be several hours of lost time..and the annoyances of
> redoing it.
> 
> mounting results in this, as below. mounting recovery doesn't help.
> mounting ro recovery doesn't help. btrfs fsck basically reaffirms what I
> know so far, that I'm screwed because my superblock is bad.
> 
> show super: http://pastie.org/private/b1k2famcfmtquaqgpyfozg mount
> dmesg: http://pastie.org/private/8zsczfustrmeg6a2bbfxag
> 
> btrfs-find-root: http://bpaste.net/show/326346

Hi, Shaun.  KDE user here, gentoo, USE=-semantic-desktop, active on the
kde general and linux lists (as well as here and the gentoo lists).  =:^)

How do you know it's a bad superblock?  While I'm not a dev just a list
regular, show-super looks reasonable from here, and find-root does find
what appears to be a good root.  From here the problem seems to be a bad
ctree (of several), not a bad superblock.

First thing to try is mounting with nospace_cache.  If that works, try
mounting with clear_cache and letting it work for a bit to rebuild.

If that doesn't work, it may simply be the log tree.  btrfs-zero-log is
used to fix that, but before you try that, read this entry in the FAQ and
follow the instructions for making a filesystem image to turn in to the
devs to help them fix such problems, and consider making a backup of the
damaged filesystem using dd/ddrescue, since the warning about making it
possibly more difficult to recover if this is NOT the problem applies:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21

With luck one of those options will help.  I know I had a space_cache
issue here myself, some time ago.  I've not had to run zero-log, but
I've seen a number of posters who found it helped.

Another thing to try is mounting recovery,ro.  A number of people have
reported that would work when simple recovery wouldn't, because when
it was writable btrfs would immediately try to fix the problem and
immediately fail.

Beyond that, you'll need more expert help.  But most of the time one
of those three works, so with luck...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


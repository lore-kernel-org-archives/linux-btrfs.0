Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab3JFKLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Oct 2013 06:11:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSlIm-0002XX-TU
	for linux-btrfs@vger.kernel.org; Sun, 06 Oct 2013 12:11:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Oct 2013 12:11:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Oct 2013 12:11:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
Date: Sun, 6 Oct 2013 10:10:44 +0000 (UTC)
Message-ID: <pan$7e4a4$8b6e0db$cfbe49bd$cf267e4@cox.net>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
	<pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
	<CAOMFOmWuEhqg4L18h+0BXo-=T7ur2dJF--FU8-=O6-zWAeDXhA@mail.gmail.com>
	<pan$2eb11$bbed6571$fb7d3108$4fff2a35@cox.net>
	<CAOMFOmVvhqGHxoqx1rGF-6cokhPLrP21AfwJ29prNhX1FR_cfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anatol Pomozov posted on Sat, 05 Oct 2013 22:14:25 -0700 as excerpted:

> Actually I remembered that I set "chattr +C" on /var/log/journal
> recursively (even for non-empty files) about a week ago, it might be
> related to the crash. When I mount "-orw" and try to remove
> /var/log/journal system hangs in btrfs-transacti thread.

Based on what I've seen in other threads and how nocow works, you really 
need to either set it (on the dir) before the files are created, or touch 
them so they're zero size and set it then.  You did say you set it on the 
dir, recursively, but existing files would then have been COW for awhile, 
and that might be related to your problem now, particularly with the just 
freshly patched systemd-journal-file-triggered-bug I mentioned.

Of course as you likely know but others googling this or otherwise 
reading it may not, btrfs is still labeled experimental, and while it 
does work pretty well for the general case, it's exactly the slightly or 
very oddball cases such as allocate-and-write-into technique that isn't 
quite so common, that can still be buggy.  In addition to a few loose-end 
features still being wrapped up, it's finding and fixing stuff like this 
that's the biggest thing still left before btrfs can be labeled stable 
and fully ready for normal and production use.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


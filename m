Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55193 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBXFvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 00:51:03 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WHoRT-0004o8-7c
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Feb 2014 21:51:03 -0800
Date: Sun, 23 Feb 2014 21:51:03 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs userland interface isn't 32/64bit clean (breaks lsattr and btrfs send)
Message-ID: <20140224055103.GA15937@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was trying to make sense out of this:
gargamel:~# lsattr
lsattr: Inappropriate ioctl for device While reading flags on ./satapmtool
lsattr: Inappropriate ioctl for device While reading flags on ./usbreset


As well as the btrfs send issue I reported:
gargamel:/mnt/btrfs_pool1# btrfs send media_ro.20140222_11:12:53 | less
At subvol media_ro.20140222_11:12:53
ERROR: send ioctl failed with -25: Inappropriate ioctl for device

I was trying to figure out why it was failing on one system while it was working 
on my other ones with the same kernel.

In the end I pinned it down to this:
3.13.5's kernel/userland interface fails if my kernel is 64bit and my
userland 32bit.

lsattr and btrfs send, and maybe more things fail, but they started working
the moment I updated my kernel to 32bit

Is this difficult to fix?
Do I need to file bugs with some folks, or this mail is enough?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

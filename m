Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49667 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaBHXka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 18:40:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCHVc-0006p8-4M
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 00:40:28 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:40:28 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:40:28 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 09 Feb 2014 00:27:20 +0100
Message-ID: <o3risa-vkc.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de> <20140209041050.529ff6f9@natsu> <CAE5mzviJK7NA_bT2ccVKwbo4FfjhZNykSw6jm0j=CpwC5Lk+=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cwillu <cwillu@cwillu.com> schrieb:

> Everyone who has actually looked at what the statfs syscall returns
> and how df (and everyone else) uses it, keep talking.  Everyone else,
> go read that source code first.
> 
> There is _no_ combination of values you can return in statfs which
> will not be grossly misleading in some common scenario that someone
> cares about.

Thanks man! statfs returns free blocks. So let's stick with that. The df 
command, as people try to understand it, is broken by design on btrfs. One 
has to live with that. The df command as it works since 1970 returns free 
blocks - and it does that perfectly fine on btrfs without that proposed 
"fix".

User space should not try to be smart about how many blocks are written to 
the filesystem if it writes xyz bytes to the filesystem. It has been that 
way since 1970 (or whatever), and it will be that way in the future. And a 
good file copying GUI should give you the choice of "I know better, copy 
anyways" (like every other unix utility).

Your pointer is everything to say about it.

-- 
Replies to list only preferred.


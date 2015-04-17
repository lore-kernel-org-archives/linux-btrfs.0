Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39977 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbbDQBJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 21:09:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YiumP-0004e0-VM
	for linux-btrfs@vger.kernel.org; Fri, 17 Apr 2015 03:09:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 03:09:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 03:09:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: have restore set atime/mtime
Date: Fri, 17 Apr 2015 01:09:06 +0000 (UTC)
Message-ID: <pan$9774f$be540432$25bcbd9d$e84db021@cox.net>
References: <553046DA.7090809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Merillat posted on Thu, 16 Apr 2015 19:33:46 -0400 as excerpted:

> The inode is already found, use the data and make restore friendlier.

Unless things have changed recently, restore doesn't even restore user/
group ownership, let alone permissions.  IOW, atime/mtime are the least 
of the problem (particularly if people are running noatime as is 
recommended, unless you really need it for some reason).

It simply creates the files it restores as the owner/group it is run as 
(normally root), using standard umask rules, I believe.

So if you're going to have it start restoring metadata at all, might as 
well have it do ownership/perms too, if it can.  Otherwise atime/mtime 
are hardly worth bothering with.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


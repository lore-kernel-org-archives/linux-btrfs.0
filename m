Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56451 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3HWJIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:08:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCnMG-0004nn-1c
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 11:08:40 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 11:08:40 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 11:08:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Date: Fri, 23 Aug 2013 09:08:21 +0000 (UTC)
Message-ID: <pan$e0fe5$102b89f1$6420a15b$7c2eaf18@cox.net>
References: <kv74sk$bg9$1@ger.gmane.org> <CE3CD861.3C3F5%mark@backupsystems.
	co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Ridley posted on Fri, 23 Aug 2013 09:20:04 +0100 as excerpted:

> I don't want to try nodatacow (which would probably fix the issue), but
> you lose compression on the whole filesystem, autodefrag doesn't fix it
> either.

I don't do servantware (in the context of my sig) and thus don't do samba 
here, so I'll just black-box that side of things entirely.

But from the btrfs side, are you considering nodatacow at the filesystem 
or individual file level?  It seems doing it at the individual file level 
might be what you need.

Note that nodatacow must be set on the file at creation in ordered to 
work, which is impractical to do directly.  However, if you can arrange 
for the files in question to appear in a particular directory, you can 
set the nodatacow attribute on the directory, and files created within it 
will inherit that.

It seems to me that should do what you need, PROVIDED that you can 
arrange for the files to appear in a particular dir/dir-tree, not more or 
less randomly written throughout the entire (btrfs) filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


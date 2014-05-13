Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34946 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaEMEzq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 00:55:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wk4kj-00071M-Je
	for linux-btrfs@vger.kernel.org; Tue, 13 May 2014 06:55:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 06:55:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 06:55:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
Date: Tue, 13 May 2014 04:55:32 +0000 (UTC)
Message-ID: <pan$32b2f$6c928539$a433bdd$26be4562@cox.net>
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
	<CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
	<20140509145118.GD5988@twin.jikos.cz> <536D1AA6.7050407@libero.it>
	<20140512143946.GD6917@suse.cz> <5371105C.5030306@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 12 May 2014 20:18:04 +0200 as
excerpted:

> Finally I have a question: it is possible to disable inode_cache ? what
> means the flag "noinode_cache" ? It means disable the inode cache at
> all, or only avoid to store on disk the inode cache ?

Unlike space_cache, which is enabled by default these days, inode_cache 
must be specifically enabled every time it is to be used.  So simply not 
including the inode_cache mount option when doing the original mount 
means it's disabled.

Meanwhile, the noinode_cache flag is simply one of the mount-option 
negators, to allow turning off a mount option on an existing mount when 
it is remounted, to avoid having to fully umount and do a fresh mount, to 
deactivate the option.

So simply don't include inode_cache when doing the original mount to 
disable it, or if for whatever reason it's enabled and you want to 
disable it on a remount, use -o remount,noinode_cache for the remount, 
and it'll disable inode_cache if the filesystem was already mounted with 
it enabled.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


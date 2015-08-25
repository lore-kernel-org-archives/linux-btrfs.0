Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50022 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbbHYIh4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 04:37:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZU9js-0006PN-1a
	for linux-btrfs@vger.kernel.org; Tue, 25 Aug 2015 10:37:52 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:37:52 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:37:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Date: Tue, 25 Aug 2015 08:37:46 +0000 (UTC)
Message-ID: <pan$d4557$9c42de4e$12e74017$2f692aea@cox.net>
References: <2017000.AEG9PyVY17@zafu>
	<pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net> <4755396.RFUxGNmK6p@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Tue, 25 Aug 2015 10:18:26 +0200 as excerpted:

> Le vendredi 21 août 2015 11:23:19 Duncan a écrit :
>> So I'd suggest running btrfs check, without --repair, first, and see
>> what it says.  If the only reported problems have to do with inode
>> refcounts, then (assuming your backups are current, just in case,
>> admin's rule of backups, if you don't have them, you don't care about
>> losing the data) I'd then go ahead and run it with --repair.
> 
> Hi Duncan,
> 
> Here's what I get using "btrfs check" on said device. Do you think that
> running it with "--repair" would be beneficial, or risky ?
> 
> root@partedmagic:~# btrfs check /dev/VGZ/LINUX
> Checking filesystem on /dev/VGZ/LINUX
> UUID: 13c87f57-3a85-4daf-a4bf-ba777407c169
> checking extents
> checking free space cache
> checking fs roots
> root 267 inode 297 errors 200, dir isize wrong
> root 267 inode 3341 errors 200, dir isize wrong
> root 267 inode 324547 errors 200, dir isize wrong

[and many more errors 200, dir isize wrong, errors flagged, with no other 
errors listed]

While cautioning that I'm not a dev, just a btrfs user and list 
regular... and I haven't had that particular problem and thus no directly 
apropos personal experience here...

The errors 200 flags are reasonably common, and I believe
btrfs check --repair handles them well.  I already stressed the admin 
rule that no backups means you don't care if it's lost, so with that in 
mind, I'd say go ahead with the --repair... as, based on the information 
I have, I would were I to see that here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


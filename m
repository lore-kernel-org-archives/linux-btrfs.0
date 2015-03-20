Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41216 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbbCTESp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 00:18:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YYoOS-00064n-0t
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 05:18:44 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 05:18:43 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 05:18:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: syntax for deleting subvolumes?
Date: Fri, 20 Mar 2015 04:18:38 +0000 (UTC)
Message-ID: <pan$e3d8c$58030454$dbd36547$e1e1c7cd@cox.net>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
	<550A08AC.7070506@graphitesystems.com>
	<CAJCQCtSrR7tOQMkbKdk5y2FJ7J2nYNAAjowRnic2O13wa3d1PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 19 Mar 2015 13:09:06 -0600 as excerpted:

> Erkki's cp --reflink idea is a good one. I've often wondered if it's a
> good idea, and possible, to eventually make --reflink the default
> behavior with Btrfs copies (I think some things probably first need
> enhancement like the cross subvolume stuff, because otherwise cp could
> fail inexplicably).

If cp --reflink=auto was the default, it'd "just work", making a reflink 
where possible, falling back to a normal copy where not possible to 
reflink.

However, I'd be wary of such a change, because admins are used to cp 
creating a separate copy which may well be intended as a backup, guarding 
against I/O errors on the original.  Btrfs does do checksum checking to 
ensure validity, but if that fails, do you really want it failing for 
BOTH copies, including the one the admin made specifically to AVOID such 
a problem, because he knows the file is likely to be open at the time of 
a crash or some such and did a cp to have a backup, just in case?  I know 
as an admin, *I* wouldn't like such behavior.  Far better to simply have 
the option there should I deliberately invoke it, but not invoke it by 
default, in ordered to avoid unhappy surprises!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


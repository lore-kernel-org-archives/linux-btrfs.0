Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48334 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbcEMGhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 02:37:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b16iX-0001r7-Tc
	for linux-btrfs@vger.kernel.org; Fri, 13 May 2016 08:36:58 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 08:36:57 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 08:36:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fsck: to repair or not to repair
Date: Fri, 13 May 2016 06:36:45 +0000 (UTC)
Message-ID: <pan$14f07$a448b38$b8e37f4a$116d54ce@cox.net>
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Thu, 12 May 2016 19:02:56 +0200 as excerpted:

>  Maybe you first want to test it on an overlay
> of the device or copy the whole fs with dd.

WARNING!

Because btrfs can be multi-device, it needs some way to track which 
devices belong to each filesystem, and it uses filesystem UUID for this 
purpose.

If you clone a filesystem (for instance using dd or lvm snapshotting, 
doesn't matter how) and then trigger a btrfs device scan, say by plugging 
in some other device with btrfs on it so udev triggers a scan, and the 
kernel sees multiple devices with the same filesystem UUID as a result, 
and one of those happens to be mounted, you can corrupt both copies as 
the kernel btrfs won't be able to tell them apart and may write updates 
to the wrong one.

Prevention:

Don't let btrfs see both copies at the same time.  If you need to clone 
the filesystem, ideally make sure it's unmounted at the time, and detach 
either the original device or the clone immediately upon finishing the 
clone operation (before doing anything that might trigger a btrfs device 
scan, including device plugging that would trigger udev to trigger such a 
scan).  Then simply keep them separate, only attaching one at a time and 
DEFINITELY never mounting the filesystem with both the clone and the 
original devices attached, so the kernel can't get confused and write to 
the wrong one because the other one is never there at the same time to 
provide the opportunity.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


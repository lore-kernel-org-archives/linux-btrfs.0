Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46521 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbbBEEDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 23:03:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJDet-0006JC-6Y
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 05:03:15 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 05:03:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 05:03:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deadlock on 3.18.5
Date: Thu, 5 Feb 2015 04:03:09 +0000 (UTC)
Message-ID: <pan$749cc$d161b717$4f6b3401$e3f1a958@cox.net>
References: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juergen Fitschen posted on Thu, 05 Feb 2015 00:05:33 +0100 as excerpted:

> I just got a deadlock on Linux 3.18.5. [...]
> I am using a freshly installed Ubuntu 14.04 in a virtual machine. The
> block device used for btrfs is a LVM volume offered by the KVM
> hypervisor.
> Unfortunately I was using an old version of my user space tools (Version
> 3.12-1), so it might be related to that?

I know little to nothing about the complexities of btrfs in a VM so won't 
attempt an answer there.  But about userspace specifically I can say 
this...

For normal operation, btrfs userspace doesn't matter so much.  It's the 
kernel that's vital as userspace mostly simply tells the kernel what to 
do at a relatively high level (mount/umount/snapshot/delete-snapshot/etc) 
and the kernel code handles pretty much everything at the more critical 
lower levels.  OTOH, if there are problems and you are trying to fix them 
using userspace tools such as btrfs check, restore, etc, /that/ is when 
the /userspace/ version needs to be current, as it's then userspace doing 
the low-level stuff as well.

Since it was during normal operations that this deadlock occurred, it's 
almost certainly a kernel problem (unless the problem is ultimately 
traced to a bug in the original mkfs.btrfs that created the filesystem, 
or the like), and that was current, so it's it's a current problem. =:^(

Hopefully a dev or other regular with more VM experience will be along to 
help you further, but I could deal with this much, so I did. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


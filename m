Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49589 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbbELFoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 01:44:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ys2zI-0006kJ-Q2
	for linux-btrfs@vger.kernel.org; Tue, 12 May 2015 07:44:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 07:44:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 07:44:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Aborted transaction on invalid snapshot -i
Date: Tue, 12 May 2015 05:44:11 +0000 (UTC)
Message-ID: <pan$f1070$5570a4a4$d8b35b99$7056b478@cox.net>
References: <55502A8A.4000707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remi Rampin posted on Mon, 11 May 2015 00:05:30 -0400 as excerpted:

> Basically, "btrfs subvolume snapshot -i 0/100 /mnt/root /mnt/snap" is
> causing the error (I meant to type 1/100).
> 
> Attached is a simple session reproducing the crash (every time on my
> machine), with output from btrfs commands and dmesg.
> 
> Regards
> 
> 
> ----- session -----
> 
> remram@missy:~$ uname -a
> Linux missy 3.16.0-4-amd64 #1 SMP Debian
> 3.16.7-ckt9-3~deb8u1 (2015-04-24) x86_64 GNU/Linux
> remram@missy:~$
> /sbin/btrfs --version Btrfs v3.17

No comment on the root bug, but in general...

Kernel v3.16.x, userspace v3.17... is a bit old for this kind of 
testing.  Bugs are still actively being fixed, and before reporting a bug 
of this sort, updating to see if it's still happening in current 
(currently v4.0.x kernels and userspace, or even v4.1-rcX kernels and 
integration-branch userspace), is generally a good idea.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


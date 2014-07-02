Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51994 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaGBI2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 04:28:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X2Fu8-0002kL-TI
	for linux-btrfs@vger.kernel.org; Wed, 02 Jul 2014 10:28:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:28:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:28:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
Date: Wed, 2 Jul 2014 08:28:25 +0000 (UTC)
Message-ID: <pan$2524d$7b2eaf89$ca7921b9$ca1c4172@cox.net>
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20140701153240.GL1553@twin.jikos.cz> <53B2E371.6030504@fb.com>
	<53B3BBD3.4070004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Harald Hoyer posted on Wed, 02 Jul 2014 09:59:15 +0200 as excerpted:

> Pull it out, if the patch causes problems, but _please_ think about the
> problem and come up with a solution, so that "mount -a" works with a
> normal fstab.

FWIW, systemd makes it a LOT easier to manage multi-stage mounts with 
fstab automounts because with its mount-dependencies, in most cases it 
"just works".

My previous solution, gentoo so sysvinit with openrc mounting, required 
multiple mount stage scripts and painstaking dependency editing.  It 
worked, but it was a pain!

Finding out it pretty much "just worked" on systemd (tho I did have to 
manually add a single mount-dependency line to a single service unit, due 
to a cross-mount-point symlink that systemd didn't consider, but 
documentation was easy to find and the line did exactly what the 
documentation said it would do) was my most pleasant surprise of the 
switch! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


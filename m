Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49894 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3KPS6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 13:58:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vhl4q-0006vy-6Y
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 19:58:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 19:58:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 19:58:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Subvolume creation returns file exists
Date: Sat, 16 Nov 2013 18:57:53 +0000 (UTC)
Message-ID: <pan$e2b20$cd0040f6$ff39147c$2c522512@cox.net>
References: <528630D6.5090103@elastichosts.com>
	<pan$8331$e81056a3$92e0314$93218fd5@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Fri, 15 Nov 2013 16:07:22 +0000 as excerpted:

> FWIW, here's the version string from my btrfs-progs, updated a couple
> days ago (tho there's one known bug in it, related to doing a mkfs.btrfs
> on a sub-GiB filesystem, patch posted to list but as I've not updated in
> a couple days I don't know whether it's in master yet).
> 
> Btrfs v0.20-rc1-591-gc652e4e

FWIW, that patch is in now.

Btrfs v0.20-rc1-596-ge9ac73b

commit e9ac73b441b1b05b57ce99be1aff02eac6929448
Author: Anand Jain <Anand.Jain@oracle.com>
Date:   Fri Nov 15 19:11:09 2013 +0800

    btrfs-progs: for mixed group check opt before default raid profile is 
enforced

    This fixes the regression introduced with the patch

        btrfs-progs: avoid write to the disk before sure to create fs

    what happened with this patch is it missed the check to see if the
    user has the option set before pushing the defaults.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


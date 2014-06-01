Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaFACAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 22:00:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wqv48-0004J2-GF
	for linux-btrfs@vger.kernel.org; Sun, 01 Jun 2014 04:00:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 04:00:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 04:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: All free space eaten during defragmenting (3.14)
Date: Sun, 1 Jun 2014 01:56:55 +0000 (UTC)
Message-ID: <pan$26939$a2addb4c$9febc316$74bf1551@cox.net>
References: <1703083.hLnNuPsKpY@linux-suse.hu>
	<pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sun, 01 Jun 2014 00:56:09 +0000 as excerpted:

> As for reclaiming the space...

One more option there I forgot to mention... There are various dedup 
tools out there.  See the wiki ( https://btrfs.wiki.kernel.org ) and the 
list archive for more as I've not used any of them myself, but in theory 
at least, the dedup tools should help you recover the space, and I /
think/ they'll do so without forcing either snapshot deletion or a fresh 
mkfs.btrfs and restore from backup, too, those being the other options I 
mentioned.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


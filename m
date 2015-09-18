Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49116 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbIRCA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 22:00:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZckyN-0006Mg-8J
	for linux-btrfs@vger.kernel.org; Fri, 18 Sep 2015 04:00:23 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 04:00:23 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 04:00:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as image store for KVM?
Date: Fri, 18 Sep 2015 02:00:15 +0000 (UTC)
Message-ID: <pan$270e2$4b4f9ec6$a323af50$ada695ce@cox.net>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
	<CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 17 Sep 2015 12:35:41 -0600 as excerpted:

> You'd use Btrfs snapshots to create a subvolume for doing backups of
> the images, and then get rid of the Btrfs snapshot.

The caveat here is that if the VM/DB is active during the backups (btrfs 
send/receive or other), it'll still COW1 any writes during the existence 
of the btrfs snapshot.  If the backup can be scheduled during VM/DB 
downtime or at least when activity is very low, the relatively short COW1 
time should avoid serious fragmentation, but if not, even only relatively 
temporary snapshots are likely to trigger noticeable cow1 fragmentation 
issues eventually.

Some users have ameliorated that by scheduling weekly or monthly btrfs 
defrag, reporting that cow1 issues with temporary snapshots build up slow 
enough that the scheduled defrag effectively eliminates the otherwise 
growing problem, but it's still an additional complication to have to 
configure and administer, longer term.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


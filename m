Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36982 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDUFVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 01:21:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wc6fS-0000mh-Tn
	for linux-btrfs@vger.kernel.org; Mon, 21 Apr 2014 07:21:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 07:21:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 07:21:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Planning for subvolumes of subvolumes and btrfs send/receive
Date: Mon, 21 Apr 2014 05:21:08 +0000 (UTC)
Message-ID: <pan$dba25$fcce76df$e65f293a$ec25f425@cox.net>
References: <20140420194627.GO7884@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 20 Apr 2014 12:46:27 -0700 as excerpted:

> Long story short, I'm wondering if I can use btrfs send to copy sub
> subvolumes (by snapshotting a parent subvolume, and hopefully getting
> all the children underneath). My reading so far, says no.

I don't do much with subvolumes and absolutely nothing with send/receive 
myself, but from what I've read, no, for the simple case (but see below) 
that cannot work.

The reason is that snapshots (including the read-only snapshot done for a 
send) stop at subvolume borders.

In the large-internal-write-NOCOW-file dedicated subvolume case, that's a 
positive, since the dedicated subvolume can be used to avoid snapshotting 
the nocow stuff on the subvolume when snapshotting a parent, but in this 
case the same subvolume property is a negative.


Now somebody *DID* mention multi-subvolume sends, and indeed, checking 
the manpage, there appears to be allowance for that by naming multiple 
subvolumes (and multiple clone-sources when doing the incremental), 
*BUT*, there appears to be no corresponding allowance for multiple 
subvolume snapshotting, so your script would need a "for subvol in 
$subvols" type construct at least for the snapshotting, and once you do 
that, you might as well do multiple sends as well, as that's likely to be 
more robust than a the larger all-in-one send, if one of the subvolume 
sends/receives fails for some reason.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


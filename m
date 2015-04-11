Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52765 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbbDKCOz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 22:14:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ygkwf-0002jB-Bb
	for linux-btrfs@vger.kernel.org; Sat, 11 Apr 2015 04:14:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 04:14:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 04:14:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance {,meta}data to raid5 not working?
Date: Sat, 11 Apr 2015 02:14:44 +0000 (UTC)
Message-ID: <pan$577b$aa7780a2$54c1424a$5329065c@cox.net>
References: <20150410221049.GE9470@wloczykij>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Piotr Szymaniak posted on Sat, 11 Apr 2015 00:10:49 +0200 as excerpted:

> Hi,
> 
> I tried today to balance two drive btrfs raid1 to two drive btrfs raid5
> without luck: [snipped]

> Linux 3.19.3
> btrfs-progs v3.19.1

Two points:

1) There is (was?) a known bug with balance-conversion in (near-)current 
btrfs.  It was broken for a time, and I'm not sure it is fixed yet.  I'm 
also not sure whether it was a user-side or kernel-side issue, tho I 
believe the culprit commit has been traced and posted, so the answer 
should be on the back-list if nobody else replies here with more specific 
info.

Which presents a problem, since fully working raid5 support is so new.  
But for conversion, I /think/ you can use somewhat older versions and do 
the conversion, then use current versions that better handle problems for 
actual operation.  If I only knew which part, userspace or kernelspace, 
you have to use an old version of...

But you could try the latest 4.0-rc7+ kernel and see if it works with 
that, yet.

2) You specify two drives[1] and an intended conversion to raid5.  
Normally/traditionally, raid5 needs three devices to function undegraded, 
altho technically, two-device raid5 is possible; it's just effectively a 
slow raid1.  There has been some discussion around whether btrfs should 
enable two-device raid5 or not, but regardless of whether it's actually
/possible/, why would you /want/ it?

2a) If your intention is to keep it two devices, just continue using 
raid1, particularly with btrfs where raid1 mode is MUCH more mature and 
tested than raid5 mode.

2b) If instead your intention was to convert it to raid5 before upgrading 
it to three devices, just add the third device first, then do the balance-
conversion.  It'll save quite some time over effectively doing the 
balance-conversion twice.

---
[1] Disks/drives/devices.  In a modern world of SSDs and virtual devices, 
a block device may well be neither a disk nor an actual drive. (Does SSD 
refer to a solid state /device/, or a solid state /drive/; it's certainly 
not a /disk/?  Either way, a virtual device may not in fact be a drive of 
any sort at all, while still being a device.)  I guess I'm not alone 
among experienced users and sysadmins of an earlier era, who find 
themselves now trying to retrain themselves to use the more accurate 
generic term in most contexts...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


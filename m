Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34655 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab3KFMhz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 07:37:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ve2Mr-0002Ek-CI
	for linux-btrfs@vger.kernel.org; Wed, 06 Nov 2013 13:37:53 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 13:37:53 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 13:37:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.11.5 kernel infinite loop
Date: Wed, 6 Nov 2013 12:37:32 +0000 (UTC)
Message-ID: <pan$70f09$474e61ed$c27deec7$82b1529a@cox.net>
References: <201311061252.39398.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Wed, 06 Nov 2013 12:52:38 +1100 as excerpted:

> I have a system running the Debian package of 3.11.5 with an Amd Opteron
> 1212 processor (2*64bit cores), 8G of RAM, and an Intel 120G SSD for the
> root and home subvols.  It has a RAID-1 array of 2*3TB disks for bulk
> storage (movies etc) but that probably isn't relevant to this problem.
> 
> On the root filesystem I have cron jobs making daily snapshots of / and
> /home and additional snapshots of /home every 15 minutes.  At midnight a
> cron job removes older snapshots.  For the last 8 days the system has
> been reliably hanging at about 5 minutes after midnight and the subvol
> removal cron job is the only thing that has happened then.

I believe there's a btrfs-critical stable-series patch in 3.11.6, that 
you're probably missing with 3.11.5.  (There were unfortunately some 
crossed signals and the patch was skipped for a couple weeks after it 
should have gone in, but it's in now.)

Yes... Just checked the 3.11.6 changelog:

Josef Bacik (1):
      Btrfs: use right root when checking for hash collision


Note that there's another critical patch in-flight, patching a bug 
triggered by btrfs balance on filesystems with pre-allocated files (like 
systemd does with its journal and various torrent clients do with their 
downloads).  But this one is currently being held up because stable rules 
require it to be in current mainline first, and 3.12 is out, but the two-
week 3.13 commit window that would normally be open now is suspended for 
a week, as Linux is traveling without a reliable net connection.  So the 
patch can't hit mainline, and thus won't hit stable unless an exception 
is made, until after Linus' vacation, when the commit window opens and 
the patch is accepted.

See previous discussion here on this list for it, or simply don't do any 
balances if you're running systemd or with any other pre-allocated-file 
apps such as torrent clients running, until after you get that patch.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


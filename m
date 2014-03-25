Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbaCYUZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 16:25:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSXuv-0004BZ-Ub
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 21:25:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 21:25:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 21:25:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug in profile balance not present in normal balance
Date: Tue, 25 Mar 2014 20:25:24 +0000 (UTC)
Message-ID: <pan$930e5$479ced6d$2ea1e491$5cdb108a@cox.net>
References: <CAJtFHUQCJhkDJiUgkrtoPJ=pN3+ngvAD_yhwb=_Kh1kQP+4xKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

E V posted on Tue, 25 Mar 2014 15:47:45 -0400 as excerpted:

> System, single: total=4.00MiB, used=0.00

BTW, that and the corresponding Metadata, single: entries, both 
used=0.00, are artifacts of the original mkfs.btrfs, and can be safely 
removed via balance.  I've started doing that here right after first 
mount of the filesystem, before I stick anything on it, but they can be 
removed later as well.

btrfs balance start -m,convert=raid1,soft <mountpoint>

... should do it.  The soft avoids the already raid1 metadata, and 
metadata normally implies system as well.  That does it for me, tho one 
person said in ordered to get the single system chunk gone he had to use 
-s,convert=raid1,soft -f (force) as well.  (I suspect that might be 
because he did system first, separately, and force is needed as 
confirmation for that, but not for doing metadata, which implies system 
as well.  Force would also be necessary going the other way, 
convert=single, since that reduces metadata/system redundancy.)

It just bothers me to see those separate extra and unused entries every 
time I do a btrfs filesystem df, and that gets rid of them, so I do it, 
and after that my btrfs filesystem df's  are nice and tidy like the 
should be! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


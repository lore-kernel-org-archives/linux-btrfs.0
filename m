Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51639 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbbDMIHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 04:07:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YhZOi-0001Ak-Tj
	for linux-btrfs@vger.kernel.org; Mon, 13 Apr 2015 10:07:12 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 10:07:12 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 10:07:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Big disk space usage difference, even after defrag, on
 identical data
Date: Mon, 13 Apr 2015 08:07:04 +0000 (UTC)
Message-ID: <pan$d15c8$d36a323f$6d766df$721d5a29@cox.net>
References: <55297D36.8090808@sjeng.org>
	<20150413040436.GB4711@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Mon, 13 Apr 2015 00:04:36 -0400 as excerpted:

> A database ends up maxing out at about a factor of two space usage
> because it tends to write short uniform-sized bursts of pages randomly,
> so we get a pattern a bit like bricks in a wall:
> 
>         0 MB AA BB CC DD EE FF GG HH II JJ KK 1 MB half the extents 0 MB
>          LL MM NN OO PP QQ RR SS TT UU V 1 MB the other half
> 
>         0 MB ALLBMMCNNDOOEPPFQQGRRHSSITTJUUKV 1 MB what the file looks
>         like
> 
> Fixing this is non-trivial (it may require an incompatible disk format
> change).  Until this is fixed, the most space-efficient approach seems
> to be to force compression (so the maximum extent is 128K instead of
> 1GB) and never defragment database files ever.

... Or set the database file nocow at creation, and don't snapshot it, so 
overwrites are always in-place.  (Btrfs compression and checksumming get 
turned off with nocow, but as we've seen, compression isn't all that 
effective on random-rewrite-pattern files anyway, and databases generally 
have their own data integrity handling, so neither one is a huge loss, 
and the in-place rewrite makes for better performance and a more 
predictable steady-state.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


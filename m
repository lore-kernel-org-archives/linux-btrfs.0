Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46929 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbbL0HKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 02:10:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aD5Sx-0005Au-Lv
	for linux-btrfs@vger.kernel.org; Sun, 27 Dec 2015 08:10:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 08:10:07 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 08:10:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] improve documentation of snapshot unaware defrag
Date: Sun, 27 Dec 2015 07:09:41 +0000 (UTC)
Message-ID: <pan$3bca9$74a60ba5$bf56792f$3c0040ca@cox.net>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
	<1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 27 Dec 2015 04:03:27 +0100 as
excerpted:

[Rewrapped here but all added lines.]

> +WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2
> as well as 
> +with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or ≥
> 3.13.4 will break up 
> +the ref-links of CoW data (for example files copied with 
> `cp --reflink`,
> +snapshots or de-duplicated data).
> +This may cause considerable increase of space usage depending on the
> broken up +ref-links.

Thanks.  I had looked at that a few times and thought it needed updated, 
but I think it hadn't reached my pain threshold yet[1], so I hadn't yet 
posted about it.

Glad it reached someone's pain threshold. =:^)

---
[1] Pain threshold:  Or more like, I was always doing something else at 
the time, which is probably everybody else's excuse too.  But by contrast 
it can be noted that I posted right away when I noticed the mkfs.btrfs 
manpage totally lost raid1 mode with one update, because I use it, 
regardless of what else I was doing.  I guess that must have hit my pain 
threshold...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47959 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbaAAKGd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 05:06:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VyIh5-0003gl-Vj
	for linux-btrfs@vger.kernel.org; Wed, 01 Jan 2014 11:06:31 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 11:06:31 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 11:06:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Migrate to bcache: A few questions
Date: Wed, 1 Jan 2014 10:06:07 +0000 (UTC)
Message-ID: <pan$5d9a6$76e24cb6$d9958291$8c757ede@cox.net>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
	<52C1990D.9060704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 30 Dec 2013 11:02:21 -0500 as
excerpted:

> I've actually tried a simmilar configuration myself a couple of times
> (also using Gentoo in-fact), and I can tell you from experience that
> unless things have changed greatly since kernel 3.12.1, it really isn't
> worth the headaches.

Basically what I posted, but "now with added real experience!" (TM) =:^)

> As an alternative to using bcache, you might try something simmilar to
> the following:
>     64G SSD with /boot, /, and /usr Other HDD with /var, /usr/portage,
>     /usr/src, and /home tmpfs or ramdisk for /tmp and /var/tmp
> This is essentially what I use now, and I have found that it
> significantly improves system performance.

Again, very similar to my own recommendation.  Nice to see others saying 
the same thing. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


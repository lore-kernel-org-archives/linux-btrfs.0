Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43599 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbALFX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 00:23:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YAXTK-0003uP-Nh
	for linux-btrfs@vger.kernel.org; Mon, 12 Jan 2015 06:23:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 06:23:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 06:23:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What about storing more crc32 in the unused csum size for
 metadata?
Date: Mon, 12 Jan 2015 05:23:16 +0000 (UTC)
Message-ID: <pan$279da$6f12814e$e8e5572b$d2a90667@cox.net>
References: <54B3323E.3090100@cn.fujitsu.com>
	<pan$8d162$d4e83036$79c5caa1$f18c808@cox.net>
	<54B353EE.6090605@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 12 Jan 2015 12:56:14 +0800 as excerpted:

> Oh, my fault, sector 1 should contains csum for the second eighth of the
> leaf/node...
> Since the first eighth csum can be calculated  vice verse.
> 
> Thanks,

Thanks indeed.

/Now/ it makes sense.  Skip the one and reverse-calculate it.  (Which you 
had actually implied and I guess it doesn't matter which one as long as 
it's /only/ one, but given my general unfamiliarity with crc at a 
practical level and impaired logic state, and your hiding it in the ... 
gap, I needed a bit more help to make the leap. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


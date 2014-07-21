Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49563 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaGUCtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 22:49:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X93ev-0008MS-Ja
	for linux-btrfs@vger.kernel.org; Mon, 21 Jul 2014 04:49:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 04:49:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 04:49:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Mon, 21 Jul 2014 02:48:46 +0000 (UTC)
Message-ID: <pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net>
References: <loom.20140720T102642-239@post.gmane.org>
	<53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu>
	<37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ashford posted on Sun, 20 Jul 2014 12:59:21 -0700 as excerpted:

> If you assume a 12ms average seek time (normal for 7200RPM SATA drives),
> an 8.3ms rotational latency (half a rotation), an average 64kb write and
> a 100MB/S streaming write speed, each write comes in at ~21ms, which
> gives us ~47 IOPS.  With the 64KB write size, this comes out to ~3MB/S,
> DISK LIMITED.

> The 5MB/S that TM is seeing is fine, considering the small files he says
> he has.

Thanks for the additional numbers supporting my point. =:^)

I had run some of the numbers but not to the extent you just did, so I 
didn't know where 5 MiB/s fit in, only that it wasn't entirely out of the 
range of expectation for spinning rust, given the current state of 
optimization... or more accurately the lack thereof, due to the focus 
still being on features.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


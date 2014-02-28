Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33585 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaB1GzA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 01:55:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WJHLW-0005GG-4o
	for linux-btrfs@vger.kernel.org; Fri, 28 Feb 2014 07:54:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 07:54:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 07:54:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental backup over writable snapshot
Date: Fri, 28 Feb 2014 06:54:33 +0000 (UTC)
Message-ID: <pan$6232e$ae4efbf2$d6f88699$c5eb2079@cox.net>
References: <17860756.QfG9CfNMqv@linuxpc> <1682169.l7oZKuLmJy@linuxpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GEO posted on Thu, 27 Feb 2014 14:10:25 +0100 as excerpted:

> Does anyone have a technical info regarding the reliability of the
> incremental backup process using the said method?

Stepping back from your specific method for a moment...

You're using btrfs send/receive, which I wouldn't exactly call entirely 
reliable ATM -- just look at all patches going by on the list to fix it 
up ATM.  In theory it should /get/ there, but it's very much in flux at 
this moment; certainly nothing I'd personally rely on here.  Btrfs itself 
is still only semi-stable, and that's one of the more advanced and 
currently least likely to work without errors features.  (Tho raid5/6 
mode is worse, since from all I've read send/receive should at least fail 
up-front if it's going to fail, while raid5/6 will currently look like 
it's working... until you actually need the raid5/6 redundancy and btrfs 
data integrity mode aspects!)

>From what I've read, *IF* the send/receive process completes without 
errors it should make a reasonably reliable backup.  The problem is that 
there's a lot of error-triggering corner-cases ATM, and given your 
definitely non-standard use-case, I expect your chances of running into 
such errors is higher than normal.  But if send/receive /does/ complete 
without errors, AFAIK it should be a reliable replication.

Meanwhile, over time those corner-cases should be worked out, and I've 
seen nothing in your use-case that says it /shouldn't/ work, once send/
receive itself is working reliably.  Your use-case may be an odd corner-
case, but it should either work or not, and once btrfs send/receive is 
working reliably, based on all I've read both from you and on the list in 
general, your case too should work reliably. =:^)

But for the moment, unless you're aim is to be a guinea pig working 
closely with the devs to test an interesting corner-case and report 
problems so they can be traced and fixed, I'd suggest using some other 
method.  Give btrfs send/receive, and the filesystem as a whole, another 
six months or a year to mature and stabilize, and AFAIK your suggested 
method might not be the most efficient or recommended way to do things 
for the reasons others have given, but it should none-the-less work.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


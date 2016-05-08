Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48623 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbcEHViK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 May 2016 17:38:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azWOq-0004kh-Ud
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 23:38:05 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 23:38:04 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 23:38:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-tools: missing device delete/remove cancel option on disk
 failure
Date: Sun, 8 May 2016 21:37:59 +0000 (UTC)
Message-ID: <pan$43d44$2d1fc8ff$93e7f634$4b47af35@cox.net>
References: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
	<ngm2ou$he4$1@ger.gmane.org>
	<fb65d9d2-3ac9-a155-af13-62fe8d41a49b@chefmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

g6094199 posted on Sun, 08 May 2016 13:53:41 +0200 as excerpted:

> now i need some advice what to do next....best practice wise? try to
> mount degraded and copy off all data? then i will net at least 9TB of
> new storage... :-(

Well, even in general, regardless of the filesystem or what it's stored 
on, the sysadmin's rule of backups, in simple form, says if it's not 
backed up to at least one level, you are by your lack of backup defining 
the data as worth less than the time, trouble and resources necessary to 
do that backup.

And btrfs, being still stabilizing, not yet fully stable, reinforces that 
rule.  I know nobody around here that would recommend usage of btrfs in 
any mode without backups, unless the data on it is truly of trivial 
value, testing only and not worth backing up.

And btrfs parity-raid, raid56 mode, which you're using as you reported 
raid5 (I'm assuming btrfs raid5 here), is new and not yet as stable as 
btrfs is in general, with at least two known bugs related to recovery 
from loss of device, making it for purposes of recovery planning raid0.  
Nobody I know is even recommending that for production use even with 
backups at this point.  It's recommended only for testing, not for in-use 
deployment unless you really /are/ prepared to be scrapping it and 
starting over more or less constantly.

And of course the only way you couldn't know that before starting is if 
you didn't care enough about the stability of your data to do your 
research on the filesystem you were choosing in the first place, which 
would again point to the data simply not being worth enough to care about.


Which means if that data wasn't already backed up, you were already 
defining it as trivial testing data, and the only reason you may have for 
trying to recover it is to test the recovery procedures.  Otherwise, 
consider it a loss and blow it away with a new badblocks or mkfs, ready 
for a new test, as you were already declaring the data as testing data, 
not worth trying to recover, by storing it on btrfs parity raid, which is 
known to be recommended only for testing with already backed up or 
trivial value data you plan on losing, at this point.


So you don't need 9 TB of new storage, because either you already have it 
available and are using it for the backup you already have, or you had 
already demonstrated in multiple different ways that the data was really 
of only trivial value to you, so you can simply blow away the existing 
broken filesystem and simply start over with a new test.  Words can claim 
otherwise, but actions don't lie.  8^0

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


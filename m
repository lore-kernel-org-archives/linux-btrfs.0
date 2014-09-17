Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56358 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbaIQUWb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 16:22:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XULkD-0001he-K0
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 22:22:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 22:22:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 22:22:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problem with unmountable filesystem.
Date: Wed, 17 Sep 2014 20:22:17 +0000 (UTC)
Message-ID: <pan$529ae$2bc50fa8$5e7f68de$70f24efb@cox.net>
References: <54184BD2.7000300@gmail.com>
	<2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
	<54196F42.4030101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 17 Sep 2014 07:23:46 -0400 as
excerpted:

> I've also discovered, when trying to use btrfs restore to copy out the
> data to a different system, that 3.14.1 restore apparently chokes on
> filesystem that have lzo compression turned on.  It's reporting errors
> trying to inflate compressed files, and I know for a fact that none of
> those files were even open, let alone being written to, when the system
> crashed.  I don't know if this is a known bug or even if it is still the
> case with btrfs-progs 3.16, but I figured I'd comment about it because I
> haven't seen anything about it anywhere.

FWIW that's a known and recently patched issue.  If you're still seeing 
issues with it with btrfs-progs 3.16, report it, but 3.14.1 almost 
certainly wouldn't have had the fix.  (This is one related patch turned 
up by a quick search; there may be others.)

* commit 93ebec96f2ae1d3276ebe89e2d6188f9b46692fb
| Author: Vincent Stehlé <vincent.stehle@laposte.net>
| Date:   Wed Jun 18 18:51:19 2014 +0200
|
|     btrfs-progs: restore: check lzo compress length
|
|     When things go wrong for lzo-compressed btrfs, feeding
|     lzo1x_decompress_safe() with corrupt data during restore
|     can lead to crashes. Reduce the risk by adding
|     a check on the input length.
|
|     Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
|     Signed-off-by: David Sterba <dsterba@suse.cz>
|
|  cmds-restore.c | 6 ++++++
|  1 file changed, 6 insertions(+)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


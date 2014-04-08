Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33529 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbaDHMZx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 08:25:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXV66-0008Nu-TE
	for linux-btrfs@vger.kernel.org; Tue, 08 Apr 2014 14:25:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 14:25:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 14:25:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: btrfs-progs v3.14: btrfs manpage missing property, more
Date: Tue, 8 Apr 2014 12:25:39 +0000 (UTC)
Message-ID: <pan$d9ecf$f2506c41$c1689c48$a3f9a46a@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs v3.14 from git.

Apparently btrfs property was added with command-line help only.  The 
btrfs manpage doesn't have the word "property" at all.


Additionally, could we get a btrfs-mountopts manpage, until the normal 
mount manpage covers it anyway?  Yes, the information is in $KERNDIR/
Documentation/filesystems/btrfs.txt and on the wiki, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


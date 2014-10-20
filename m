Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58341 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJTEWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 00:22:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xg4Ua-0006Vw-6M
	for linux-btrfs@vger.kernel.org; Mon, 20 Oct 2014 06:22:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 06:22:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 06:22:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.16.3..3.17.1 hang in renameat2()
Date: Mon, 20 Oct 2014 04:22:34 +0000 (UTC)
Message-ID: <pan$9faea$426c6538$a1667c8d$b8fd7fa4@cox.net>
References: <20141019192525.GA29401@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Sun, 19 Oct 2014 15:25:26 -0400 as excerpted:

> It is the rename (mv) that is getting stuck.  It seems to hold a lock
> that prevents any process from later traversing d/e with find or ls, but
> does not prevent a stat on the path 'd/e/f' (which reports that d/e/f is
> now a hard link to a/b/c).

Just a btrfs user and list regular here, but this bit sounds very much 
like the symptoms from another current thread, except if a rename got 
stuck, he apparently never noticed.

Try looking up the "strange 3.16.3 problem" thread, OP Russell Coker, 
Sat, 18 Oct 2014 14:54:19 +1100, Message-ID: 
<201410181454.19375.russell@coker.com.au>

Here's the gmane link to the first post; you can follow the link from 
there to get the thread.

<http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39515>

Symptoms:

# find . -name "*546"
./1412233213.M638209P10546
# ls -l ./1412233213.M638209P10546
ls: cannot access ./1412233213.M638209P10546: No such file or directory


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


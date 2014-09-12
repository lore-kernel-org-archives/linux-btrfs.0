Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42211 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaILFdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 01:33:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSJUF-0000NV-L9
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 07:33:35 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:33:35 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:33:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should "btrfs device delete missing ..."  take?
Date: Fri, 12 Sep 2014 05:33:24 +0000 (UTC)
Message-ID: <pan$b7fb5$54761055$d1c71fc7$558839ed@cox.net>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
	<pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
	<4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com>
	<pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
	<6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
	<1efa888d-1695-4ad0-8e04-f6b2fe87314e@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Fri, 12 Sep 2014 15:19:04 +1000 as excerpted:

> It would be nice if a file system mounted ro counted as ro snapshots for
> btrfs send.
> 
> When a file system is so messed up it can't be mounted rw it should be
> regarded as ro for all operations.

Indeed, and that has been suggested before, but unfortunately it's not 
current behavior.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


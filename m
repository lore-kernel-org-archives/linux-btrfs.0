Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55519 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbaGDWOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 18:14:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X3Bk1-0000C2-2T
	for linux-btrfs@vger.kernel.org; Sat, 05 Jul 2014 00:14:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jul 2014 00:14:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jul 2014 00:14:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Date: Fri, 4 Jul 2014 22:13:48 +0000 (UTC)
Message-ID: <pan$949f5$8b3f51a1$835d96eb$bb9ec3bc@cox.net>
References: <20140704011938.GO11539@merlins.org> <1937402.nCIA16QR35@xev>
	<53B6486D.9010006@jp.fujitsu.com> <20140704142416.GI26932@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 04 Jul 2014 07:24:16 -0700 as excerpted:

> So, should I understand that 1) I have enough RAM in my system but all
> of it disappears, apparently
>    claimed by the kernel and not released
> 
> 2) this could be a kernel memory leak in btrfs or somewhere else, there
>    is no good way to know
>

Generally speaking if you're running out of RAM and swap is unused, it's 
because something is leaking memory that cannot be swapped.  The kernel 
is the most likely suspect as kernel memory doesn't swap, especially so 
if the OOM-killer kills everything it can and the problem is still there.

So it's almost certainly the kernel, and btrfs is a good candidate, but 
I'm not a dev, and at least from that vantage point I didn't see enough 
information to conclusively pin it on btrfs.  If the devs can't either, 
then either turning on additional debugging options or further debugging 
patches would seem to be in order.

So the above seems correct from here, yes.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


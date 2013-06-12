Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46511 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab3FLIin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 04:38:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UmgZl-0006Y4-Ao
	for linux-btrfs@vger.kernel.org; Wed, 12 Jun 2013 10:38:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 10:38:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 10:38:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BUG
Date: Wed, 12 Jun 2013 08:38:25 +0000 (UTC)
Message-ID: <pan$39a9c$ad4b23f0$bdccf0e6$84b2e405@cox.net>
References: <51B73E1D.9080902@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Murawski posted on Tue, 11 Jun 2013 11:11:25 -0400 as excerpted:

> Jun 10 05:24:57 localhost kernel: BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000090

I'll let someone else handle the real technical stuff, but I distinctly 
recall reading that a number of null-pointer bugs had been fixed for 
3.10, and you're running 3.9, so I could suggest trying the latest Linus-
tree rc (3.10.0-rc5 just came out a couple days ago) or live-git HEAD.

I've been running 3.10-pre here with a (new) dual-SSD raid-1 data/
metadata both set of btrfs filesystems (I partition mine down, less eggs 
in one filesystem basket), without issue so far.

Might nor might not be the same bug; as I said I don't get that deep into 
the technical stuff, but it's worth a try.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


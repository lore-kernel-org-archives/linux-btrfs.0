Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43590 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab3HaWBy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 18:01:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VFtEv-0008GZ-BF
	for linux-btrfs@vger.kernel.org; Sun, 01 Sep 2013 00:01:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 00:01:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 00:01:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable BTRFS with parent transid verify failed
Date: Sat, 31 Aug 2013 22:01:35 +0000 (UTC)
Message-ID: <pan$4b543$3168e754$1bbb4d2b$27429757@cox.net>
References: <CAN05THSnkRsRytfPZcn8eBqD_Y4BgjQTmJ9CsZC6h03xHzXJLA@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ronnie sahlberg posted on Sat, 31 Aug 2013 14:50:36 -0700 as excerpted:

> And while btrfsck eventually does complete  the filesystem remains
> unmountable.
> 
> Any advice ?

This isn't specific to your question, but in general...

In the "Question: How can I recover this partition? (unable to find 
logical $hugenum len 4096)" thread about a week ago, there's a post from 
Hugo Mills, listing the general troubleshooting steps he recommends and 
in what order.  I'd try that.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

(I have it marked to possibly add the info to the wiki as I don't 
remember seeing such a concise list there, but I haven't gotten around to 
it yet.)

Wiki: https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


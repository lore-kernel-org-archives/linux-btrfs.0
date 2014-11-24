Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34026 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaKXElA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 23:41:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XslSM-0007zx-84
	for linux-btrfs@vger.kernel.org; Mon, 24 Nov 2014 05:40:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:40:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:40:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Mon, 24 Nov 2014 04:40:44 +0000 (UTC)
Message-ID: <pan$82068$d0cc4786$993a408a$1e0e7a67@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<20141123211650.GU8916@merlins.org>
	<pan.2014.11.23.22.49.01@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Sun, 23 Nov 2014 22:49:01 +0000 as excerpted:

> On Sun, 23 Nov 2014 13:16:50 -0800, Marc MERLIN wrote:
> 
> (snip)
> 
>> That makes sense. I'll try to synthetize all this and rewrite my blog
>> post and the wiki to make this clearer.
> 
> Maybe also add that as of 3.18 empty block groups are automatically
> collected, so balancing to prevent ENOSPC-by-empty-chunks is no longer
> necessary. This works pretty well; I haven't run balance in weeks, and
> my total-vs.-used overhead has always been <10 GB.

For those of us who have been around btrfs for awhile, this still sounds 
like the stuff if science fiction, perhaps possible sometime in the 
future, but definitely not something we're yet used to having actually 
automatically handled for us.

=:^)

So I think we're all glad it's here now, but kind of holding our breath 
waiting for that bug due to this that stops everything cold.  I think the 
feeling is, OK, but let's not rock the boat too much in our haste to 
celebrate, or we might find ourselves unexpectedly in the water once 
again.  Let's just go on teaching people to swim, assuming they'll need 
to know how, and if they never do, well then that's a bonus! =:^)

But I think once we get into the 3.19 development cycle, if there's no 
critical bugs with this 3.18 feature yet, then and only then are we 
likely to start really talking about it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


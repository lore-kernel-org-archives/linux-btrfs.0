Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40621 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaGTM7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 08:59:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8qhy-0002UK-B9
	for linux-btrfs@vger.kernel.org; Sun, 20 Jul 2014 14:59:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 14:59:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 14:59:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during balance
Date: Sun, 20 Jul 2014 12:59:06 +0000 (UTC)
Message-ID: <pan$5b352$6e6542cd$e89d31d4$5e60498b@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Sun, 20 Jul 2014 12:22:33 +0200 as excerpted:

> On the other hand, the wiki [0] says that defragmentation (and
> balancing) is optional, and the only reason stated for doing either is
> because they "will have impact on performance".

Yes.  That's what threw off the other guy as well.  He decided to skip it 
for the same reason.

If I had a wiki account I'd change it, but for whatever reason I tend to 
be far more comfortable writing list replies, sometimes repeatedly, than 
writing anything on the web, which I tend to treat as read-only.  So I've 
never gotten a wiki account and thus haven't changed it, and apparently 
the other guy with the problem and anyone else that knows hasn't changed 
it either, so the conversion page still continues to underemphasize the 
importance of completing the conversion steps, including the defrag, in 
proper order.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


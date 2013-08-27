Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46990 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3H0G3z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 02:29:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VECmo-0005G2-1Z
	for linux-btrfs@vger.kernel.org; Tue, 27 Aug 2013 08:29:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 08:29:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 08:29:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: snapshot space available
Date: Tue, 27 Aug 2013 06:29:30 +0000 (UTC)
Message-ID: <pan$add47$4ad22f14$35690eac$3b7c510f@cox.net>
References: <201308262335.25871.russell@coker.com.au> <
	6FCC5036-CC36-4DA3-8594-1FA23F3BB256@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 26 Aug 2013 09:15:46 -0600 as excerpted:

> I'm uncertain if autodefrag avoids this problem. It does seem like in
> certain instances, like this, the file system needs to be able to prune
> itself somehow, like a partial balance to consolidate data chunks and
> then release their space so they can become metadata chunks.

Intriguing question re defrag.  I hadn't thought of the possibility until 
you suggested it, but indeed, tracking hundreds of extents instead of one 
or a dozen, does sound like it could reduce metadata usage, reducing the 
chance of running into the issue in the first place as well as lessening 
the chance of a "simple" delete temporarily requiring significant new 
metadata resources in ordered to track all those extent frees before the 
final atomic root entry update.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


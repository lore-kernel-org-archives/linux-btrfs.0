Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41757 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaADUJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 15:09:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzXX6-0007EI-4x
	for linux-btrfs@vger.kernel.org; Sat, 04 Jan 2014 21:09:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 21:09:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 21:09:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 4 Jan 2014 20:08:54 +0000 (UTC)
Message-ID: <pan$a3e91$3573a989$f0de8522$780fffaf@cox.net>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>
	<52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>
	<52C74415.3020407@jrs-s.net>
	<7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
	<pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
	<1388847120.23513.21.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Sat, 04 Jan 2014 14:51:23 +0000 as excerpted:

> It'll pick the latest generation number and use that one as the one true
> source.  For the others you'll get crc errors which make it fall back to
> the latest one.  If the two have exactly the same generation number,
> we'll have a hard time picking the best one.
> 
> Ilya has a series of changes from this year's GSOC that we need to clean
> up and integrate.  It detects offline devices and brings them up to date
> automatically.
> 
> He targeted the pull-one-drive use case explicitly.

Thanks for the explanation and bits to look forward to.

I'll be looking forward to seeing that GSOC stuff then, as having 
dropouts and re-adds auto-handled would be a sweet feature to add to the 
raid featureset, improving things from a sysadmin's prepared-to-deal-with-
recovery perspective quite a bit. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


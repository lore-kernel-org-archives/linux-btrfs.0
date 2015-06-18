Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46901 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbbFREiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 00:38:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5Raj-0006Dp-Hi
	for linux-btrfs@vger.kernel.org; Thu, 18 Jun 2015 06:38:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 06:38:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 06:38:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 Balancing Request for Comments and Advices
Date: Thu, 18 Jun 2015 04:37:54 +0000 (UTC)
Message-ID: <pan$36ab7$1065ac1$398f382$7ec3408d@cox.net>
References: <1434456557.89597618@apps.rackspace.com>
	<20150616122545.GI9850@carfax.org.uk>
	<61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
	<pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
	<CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com>
	<80BA2964-3B67-430B-99BE-62A348C5DBED@up4.com>
	<20150617132736.GT9850@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 17 Jun 2015 13:27:36 +0000 as excerpted:

>> Yes, on this 80% full 6x4TB RAID10 -dusage=15 took 2 seconds and
>> relocated "0 out of 3026 chunks”.
>> 
>> Out of curiosity, I had to use -dusage=90 to have it relocate only 1
>> chunk and it took les than 30 seconds.
>> 
>> So I put a -dusage=25 in the weekly cron just before the scrub.
> 
> In most cases, all you need to do is clean up one data chunk to
> give the metadata enough space to work in. Instead of manually iterating
> through several values of usage= until you get a useful response, you
> can use limit=<n> to stop after <n> successful block group relocations.

Thanks, Hugo.  It wasn't previously clear to me what the practical usage 
for the (relatively new) limit= filter was.  Very useful explanation. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


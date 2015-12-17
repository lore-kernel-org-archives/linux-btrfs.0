Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40426 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966210AbbLQBJf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 20:09:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9N4W-0002I6-Dx
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 02:09:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 02:09:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 02:09:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree
 log replay
Date: Thu, 17 Dec 2015 01:09:21 +0000 (UTC)
Message-ID: <pan$5604e$2cc633fa$ad91aa30$7832938f@cox.net>
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20151214173200.GO4227@twin.jikos.cz> <5670C017.5010104@cn.fujitsu.com>
	<pan$ecec5$9f9ca76c$f1c4eebd$1e31c111@cox.net>
	<1450266300.6259.2.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 12:45:00 +0100 as
excerpted:

> On Wed, 2015-12-16 at 11:10 +0000, Duncan wrote:
>> And noload doesn't have the namespace collision problem norecovery does
>> on btrfs, so I'd strongly suggest using it, at least as an alias for
>> whatever other btrfs-specific name we might choose.
> 
> but noload is, AFAIU, not what's desired here, is it?
> Per manpage it's "Don't load the journal on mounting",... not only
> wouldn't that fit for btrfs, it's also not what's really desired, i.e.
> an option that implies everything necessary to not modify the device.

Well, "don't load the journal on mounting" is exactly what the option 
would do.  The journal (aka log) of course has a slightly different 
meaning, it's only the fsync log, but loading it is exactly what the 
option would prevent, here.

Of course that isn't to say there shouldn't be another option, call it 
nomodify, for argument, that includes this and perhaps other options that 
would otherwise trigger filesystem level changes on a normal read-only 
mount.

Too bad we can't simply rename the recovery mount option so norecovery 
could be used as well, but I guess that could potentially break too many 
existing deployments. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


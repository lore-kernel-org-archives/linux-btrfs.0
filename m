Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbbL3VFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 16:05:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aENvc-0001PQ-Nb
	for linux-btrfs@vger.kernel.org; Wed, 30 Dec 2015 22:05:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 22:05:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 22:05:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Date: Wed, 30 Dec 2015 21:02:04 +0000 (UTC)
Message-ID: <pan$d7d3b$324f2b4f$8fb81773$4447b8c2@cox.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net> <20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net> <20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net> <20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
	<20151229180643.GD4227@twin.jikos.cz>
	<1451505611.6350.20.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 30 Dec 2015 21:00:11 +0100 as
excerpted:

> On Tue, 2015-12-29 at 19:06 +0100, David Sterba wrote:
>> > Both open of course many questions (how to deal with crashes,
>> > etc.)...
>> > maybe having a look at how mdadm handles similar problems could be
>> > worth.
>> 
>> The crash consistency should remain, other than that we'd have to
>> enhance the balance filters to process only the unconverted chunks to
>> continue.
> 
> What about nodatacow'ed files? I'd expect that in case of a crash during
> reshaping, these files are (likely) garbage then right?
> Not particularly desirable...

For something like that, it'd pretty much /have/ to be done as COW, at 
least at the chunk level, tho the address from the outside may stay the 
same.  That's what balance already does, after all.




-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


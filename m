Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaANJai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 04:30:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W30KS-0005sC-Rp
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 10:30:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 10:30:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 10:30:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck does not fix
Date: Tue, 14 Jan 2014 09:30:14 +0000 (UTC)
Message-ID: <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net>
References: <52C7127F.3060902@friedels.name>
	<6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
	<52C87B67.1040503@friedels.name>
	<F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
	<52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name>
	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
	<52D317CF.2070007@friedels.name>
	<EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
	<pan$e93a4$196236e0$f9702991$6860b33e@cox.net>
	<4A0D47A5-0FBC-488E-83E9-311FE89DBB03@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 14 Jan 2014 00:49:13 -0700 as excerpted:

> On Jan 13, 2014, at 11:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Chris Murphy posted on Mon, 13 Jan 2014 17:40:33 -0700 as excerpted:
>> 
>>> btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>
>>> 
>>> You can keep it handy in case a dev asks for it or you can attach it
>>> to a kernel.org bug report.
>> 
>> How big are they?  manpage says it's metadata only (data is zeroed),
>> so I'd guess one could expect it to be about metadata size as reported
>> by btrfs fi df?
> 
> # btrfs fi df /mnt/isos
> Metadata, DUP: total=1.00GiB, used=289.53MiB
> 
> 193M -rw-r--r--. 1 root root 193M Jan 14 00:44 sdb.img
> 
> Guess that's too big to attach to a bugzilla bug.

~ 290 MiB metadata, ~ 190 MiB btrfs-image.  So roughly 2/3 the size of 
metadata.  Metadata minus file tails (which are actually data, thus 
should be zeroed)?

Thanks.

I wonder if it compresses?

But yeah, without checking bugzie filesize caps, that eyeballs as a bit 
big.  It could be kept to be private-mailed on request, and/or stuck on a 
pastebin somewhere, however.

As long as the reporter isn't stuck on mobile with a gig-a-month data cap 
or dialup or some such...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


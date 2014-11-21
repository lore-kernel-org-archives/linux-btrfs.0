Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaKULzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 06:55:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xrmnl-0005WB-GY
	for linux-btrfs@vger.kernel.org; Fri, 21 Nov 2014 12:55:01 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 12:55:01 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 12:55:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Fri, 21 Nov 2014 11:54:50 +0000 (UTC)
Message-ID: <pan$29f5b$f7fefd1b$7cfb47$d35d0e97@cox.net>
References: <54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
	<546F2369.8090605@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Fri, 21 Nov 2014 03:35:05 -0800 as excerpted:

> On 11/20/2014 10:22 PM, Duncan wrote:
>> But while other filesystems might allow un-UUIDs (heh, UUUIDs or U3IDs
>> =:^), because they're no longer unique, requiring them to be unique
>> just as the label says cannot be considered a bug.  It's simply
>> stricter enforcement of the rules, which are, after all, plainly stated
>> in the descriptive name.
> 
> You take "U"s away, not add them
> 
> UID = unique ID GUID = globally unique ID UUID = universally unique ID

I was making a joke, as I happened to notice un-UUID =3 U-s just as I was 
writing that.  Universally unique ID = UUID, un-UUID (not universally 
unique ID) = UUUID = U^3ID. =:^)

Of course formally it'd be NUID (not/non- unique) or some such, but un-
UUID served my purpose well enough, including the joke once I noticed it, 
so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


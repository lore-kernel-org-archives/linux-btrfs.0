Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39230 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbbBSVHL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 16:07:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YOYJF-0003vg-Nt
	for linux-btrfs@vger.kernel.org; Thu, 19 Feb 2015 22:06:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 22:06:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 22:06:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS hot relocation not merged
Date: Thu, 19 Feb 2015 21:06:37 +0000 (UTC)
Message-ID: <pan$e6dc2$a63e8c87$78de93c6$7e62ee60@cox.net>
References: <54E5CDD1.9040909@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Max Schettler posted on Thu, 19 Feb 2015 12:49:37 +0100 as excerpted:

> I recently was looking for the status of hot relocation on btrfs.
> There seemed to be some activity on the mailinglist around 5/2013
> regarding patches that should provide the functionality.
> However they have not been merged yet and there hasn`t been further
> discussion about them (to my knowledge).
> What is the status of hot relocation?

The current suggestion is to use something like bcache or dmcache in 
tandem with btrfs.  I'm not sure of dmcache/btrfs status, but there are 
people actually using bcache/btrfs here on this list, with the reports 
I've read generally very positive.

Longer term, the feature in various forms remains on the wiki's project 
ideas page, here:

https://btrfs.wiki.kernel.org/index.php/Project_ideas

However, as can be seen on that page, btrfs is definitely not lacking in 
ideas for future development, rather the reverse, and unfortunately btrfs 
in general has a history of wildly optimistic feature ETAs, tho they do 
eventually come online, with raid56 mode being the most recent example.

That being the case and with none of the variants of the suggestion 
already formally claimed and in-progress, I'd suggest checking back in 
3-5 years...  unless of course this is a feeler and you're proposing to 
claim and implement it yourself. =:^)

There's also this rather vague comment on the wiki, on the main page, 
under Features, additional features in development or planned (so closer 
to News, then scroll up a bit)...

* Hot data tracking and moving to faster devices (currently being pushed 
as a generic feature available through VFS)

https://btrfs.wiki.kernel.org/index.php/Main_Page#News

(and scroll up a bit)

I'm not sure if that refers to bcache and similar, or something else, tho 
I didn't check the talk and history pages, which may have a hint...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


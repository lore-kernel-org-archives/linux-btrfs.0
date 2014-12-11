Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46032 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbaLKJDA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 04:03:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyzeE-0005qI-NA
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 10:02:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 10:02:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 10:02:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Thu, 11 Dec 2014 09:02:45 +0000 (UTC)
Message-ID: <pan$8d72b$85886201$85dadc22$ec8b492@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
	<CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>
	<548958FE.7090607@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Thu, 11 Dec 2014 00:42:38 -0800 as excerpted:

> TRUTH BE TOLD :: After two very "eventful" conversions not too long ago
> I just don't do those any more. The total amount of time I "saved" by
> not copying the files was in the negative numbers before I just copied
> the files onto an external media and reformatted and restored.

While I was running reiserfs and thus wasn't a conversion candidate, I 
have basically the same opinion of the ext* -> btrfs conversion tool.  
It's for people who don't have the extra space resources necessary to do 
a full backup, wipe clean and set it up the way you like, then restore.

That said, the conversion and subsequent btrfs troubleshooting has 
certainly been a "real world" learning experience for you (Patrik, not 
Robert as quoted above), and while I'd certainly start clean when I was 
really going to do it, for initially playing around, learning the tools, 
some troubleshooting, etc, and just to be able to say I've tried the 
conversion, I could easily see myself spending some time doing what you 
did, just learning the ropes, etc.  When I was done playing and ready to 
do it for real, I'd wipe the playground and start clean, more confident 
in my setup and management since I had spent some time playing with it 
and familiarizing myself with how it worked and what might work best in 
terms of my own setup.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


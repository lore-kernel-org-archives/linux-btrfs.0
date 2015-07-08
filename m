Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52808 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbbGHXdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jul 2015 19:33:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCypo-00070m-Td
	for linux-btrfs@vger.kernel.org; Thu, 09 Jul 2015 01:33:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 01:33:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 01:33:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Error while balance after convert from ext4
Date: Wed, 8 Jul 2015 23:32:55 +0000 (UTC)
Message-ID: <pan$cc970$278beac6$e66cdc18$1262676c@cox.net>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
	<CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
	<CAFdkf7PPbH0mw1KW2TkkF5bm=cjN2iJEOzZwVAxh0f1xzjDWuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Николай Овчинников posted
on Wed, 08 Jul 2015 22:38:20 +0300 as excerpted:

[Rearranged to standard quote, reply-in-context, format.  It makes 
replying and following replies on mailing lists FAR easier.]

> 2015-07-08 16:56 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>> I've reproduced this bug with a brand new ext4 system, converted with
>> btrfs-progs 4.1 and a 4.1 kernel. The conversion is OK. And btrfs check
>> is ok after conversion, after removing the ext2_saved snapshot, and
>> after defrag. The implosion happens on balance and the fs goes read
>> only.

> What about btrfsck and btrfs-image errors?

C Murphy mentioned btrfs check (saying it was fine after conversion).  
Btrfsck is now the check subcommand under the primary btrfs tool, with 
the standalone btrfsck deprecated and to be removed after a few 
transition releases.

But he didn't cover btrfs-image.  Valid point/question there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


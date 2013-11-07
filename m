Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KGOEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 09:04:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VeQCP-0006si-LK
	for linux-btrfs@vger.kernel.org; Thu, 07 Nov 2013 15:04:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 15:04:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 15:04:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10 to
 3.12
Date: Thu, 7 Nov 2013 14:04:20 +0000 (UTC)
Message-ID: <pan$c4dc0$c3d4cfda$6d328ddf$2900aea8@cox.net>
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
	<CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
	<527B541D.5000101@giantdisaster.de>
	<CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com>
	<CAMajw1O4-zrfxYgxeZaTNwtgY-_zTUpBbiLSExkcmwuyU5x+mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bartosz Kulicki posted on Thu, 07 Nov 2013 11:43:15 +0000 as excerpted:

> FWIW - just before nuking the fs I have added a 3GB loopback device to
> btrfs.
> 
> This restored ability to delete the files but I could not remove the
> loopback after deleting some large files (if I remember correctly error
> I got was "block device required")

Having read the wiki and the list but not having (yet) gotten into that 
sort of situation myself, I'm following this with some interest, and
was just about to ask if you'd tried that.

OK, so you added the loop device and were then able to do deletes but 
afterward could not delete the device...

The device thus obviously added some room for the filesystem to work, so 
you could delete files.  After that file-delete, did you then try a 
balance again?

Because as documented, and as demonstrated by the initial now allowed 
file-delete, that should have given you just enough extra metadata space 
to get you out of the jam, allowing a balance to finish, which in theory 
at least would have freed up enough space due to the compaction of the 
balance, to then finally do a proper btrfs device delete on the temporary 
loop device.

But without that last balance attempt after the loop add and successful 
file delete, we'll never know if the temporary loop device could have 
then been successfully btrfs device deleted or not.

Which is a bit frustrating here, since that's exactly the bit omitted 
from your posting what you tried, but what I'm counting on to get me out 
of a similar jam, should I ever get in it...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


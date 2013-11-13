Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44601 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab3KMMUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 07:20:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgZRE-0003QZ-Dm
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 13:20:52 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:20:52 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:20:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck errors is it save to fix?
Date: Wed, 13 Nov 2013 12:20:32 +0000 (UTC)
Message-ID: <pan$51c39$fb46cbde$f4d41682$79fffe0c@cox.net>
References: <52742B59.3060405@friedels.name>
	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>
	<5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name>
	<CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>
	<5279E581.4000700@friedels.name> <527BE712.40304@friedels.name>
	<pan$2f107$ddc92f2a$30381770$58497a03@cox.net>
	<527DF34B.2030309@friedels.name> <52812AAA.1080106@friedels.name>
	<3j78la-3nn.ln1@hurikhan77.spdns.de>
	<pan$9db1e$bf9333c2$543d2730$1c706b4d@cox.net>
	<llcala-j7c.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 12 Nov 2013 20:37:57 +0100 as excerpted:

>>> BTW, my first impression was that "errors 400" means something like
>>> "400 errors" - but that is just a hex bitmask which shows what errors
>>> have been found. So "errors 100" is just _one_ bit set, thus only
>>> _one_
>>> error.
>> 
>> Same impression here, tho I did wonder at the conveniently even number
>> of errors...  Perhaps "errors" should be retermed "error-mask" or some
>> such,
>> to make the meaning clearer?
> 
> Of course the numbers are even because they are powers of two:

That's what I meant:  Once I read that they were bit-flags and thus 
powers of two represented in octal or hex, it made sense.  Before that, I 
had idly/sub-consciously wondered why errors "coincidentally" seemed to 
always occur in nice round batches of X-hundred, etc, but it hadn't yet 
risen to a level of consciousness where I was even aware what it was that 
seemed odd about it -- that only happened in hindsight once I read the 
bitflags explanation and realized what had been subconsciously bothering 
me about the "too round" numbers I was interpreting them as, before.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


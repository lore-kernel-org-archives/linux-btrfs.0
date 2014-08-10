Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54497 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaHJHVR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 03:21:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGNRJ-0001RO-6V
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 09:21:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 09:21:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 09:21:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 07:21:00 +0000 (UTC)
Message-ID: <pan$a14cb$6b16719$a10ca09f$c467c2d8@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<pan$b3507$daae2ab8$2945c916$3e96ccb9@cox.net>
	<CAKcLGm8u_oGqwnCNQsazhVcY2ZC2-kAzATbLA9k+_OUGDVYSHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder posted on Sat, 09 Aug 2014 23:57:19 -0500 as excerpted:

> On Sat, Aug 9, 2014 at 11:21 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> So by the time of actual .0 release, [the kernel] really is quite
>> stable, and no longer development kernel.
>>
> I can't say I've observed that to be the case with Btrfs.  I know there
> is a core group of developers working very hard on testing the Btrfs
> updates in the _rc kernels, but once that .0 kernel hits the streets,
> the extra exposure to all the various combinations of hardware and
> options has been know to discover new issues.  I think this is nearly
> unavoidable given the pace of Btrfs development.

That's because, despite the (IMO premature) recent removal of all the 
warnings to the contrary, btrfs itself isn't stable yet.  I'd argue that 
a 3.x.0 kernel is in general more stable than any btrfs to date, tho in 
both cases there's certainly corner-cases that are markedly more unstable 
(if they run at all) than the general case.

Which means at this point it's a rather dramatic stability inversion to 
be afraid of 3.x.0 kernels while all the while running btrfs on the same 
systems.

(It is worth noting, however, that say a temperature sensor driver or a 
camera driver could get away with the level of working-for-most-people-
most-of-the-time level of stability that is btrfs at this point, and be 
considered reasonably stable.  But people tend to be rather more 
conservative when it's their data, not just a temperature sample or a 
camera shot here or there, going missing, and filesystems therefore have 
a rather higher threshold definition to hit for really being stable.  And 
that's as it /should/ be, because it /is/ people's data in the balance.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


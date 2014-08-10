Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47711 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHJEVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 00:21:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGKdh-0007xg-Hd
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 06:21:49 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 06:21:49 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 06:21:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 04:21:36 +0000 (UTC)
Message-ID: <pan$b3507$daae2ab8$2945c916$3e96ccb9@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jose Ildefonso Camargo Tolosa posted on Sat, 09 Aug 2014 13:38:46 -0500 as
excerpted:

> On Sat, Aug 9, 2014 at 12:01 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Jose Ildefonso Camargo Tolosa posted on Sat, 09 Aug 2014 11:06:37 -0500
>> as excerpted:
>>
>>> 3.16 (still in development)
>>
>> ??
>>
>> 3.16 has been out for nearly a week now and we're nearing half-way thru
>> the 3.17 commit-window.  Based on the kernel git I have here, Linus'
>> commit officially changing the makefile entry to 3.16 was on Sunday,
>> Aug 3, at 15:25:02 -0700.
>>
>> The last pre-3.16 commit was a merge of two timer-related fixes from
>> the tip-tree at 9:58:20 -0700 that morning.
>>
>> So where does your "still in development" come from?
>>
>>
> Well, maybe not the right word, but here is what kernel.org says about
> mainline kernels:
> 
> "Mainline tree is maintained by Linus Torvalds. It's the tree where all
> new features are introduced and where all the exciting new development
> happens. New mainline kernels are released every 2-3 months."
> 
> So, there you go: all new features are introduced, and where all the
> exciting new development happens.
> 
> So... development is quite active on mainline kernels.

But 3.16.0 is out, and the real active development is in the commit 
window pre-rc1, tho a kernel doesn't really /start/ settling down until 
rc3 or so, and isn't reasonably stable until rc5 or so (tho rc5 is a 
little late to start testing and reporting bugs to have fixed by release, 
it's really best to start testing around rc3 or so, at which point any 
real bad data-eating-risk bugs should be either fixed or at least 
published, so the risk is dramatically lower than it would be during the 
commit window itself, for instance).  But from rc5 on thru rc7 or 8 and 
release, unless you're one of the ones still waiting on a bug found 
earlier to be fixed, it's generally quite stable and boring.

So by the time of actual .0 release, it really is quite stable, and no 
longer development kernel.  Sure, Greg KH's stable series kernel releases 
stabilize it further, but that's exactly what they are, stable series, 
not development series, and there's really no development going into it 
generally from rc1 on, tho occasionally something that needs to come 
after everything else is slipped in in the first couple days after rc1, 
but still well before rc2, and the .0 release signifies the end of the 
post development stabilization period such that .0 really is no longer a 
development kernel at all, even if there are a few more weekly stable-
series updates (about 10, 3.15.10 was announced to be the last one for 
3.15, with the Friday-released 3.15.9) before support ceases if it's not 
a long-term-stable candidate.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3GBNAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 09:00:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uu0CL-0003jx-CM
	for linux-btrfs@vger.kernel.org; Tue, 02 Jul 2013 15:00:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jul 2013 15:00:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jul 2013 15:00:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unclean shutdown and space cache rebuild
Date: Tue, 2 Jul 2013 13:00:29 +0000 (UTC)
Message-ID: <pan$57f3a$a89b75ab$e2d2d0f4$5964d331@cox.net>
References: <11441914.sRzrmH57Vq@bheem> <2982023.ALTX9LRhaY@bheem>
	<pan$d6b02$c375f8e3$e64c63ed$cc12d244@cox.net> <1792894.GCCHX1XfTr@bheem>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shridhar Daithankar posted on Mon, 01 Jul 2013 21:49:16 +0530 as
excerpted:

> On Monday, July 01, 2013 09:10:41 AM Duncan wrote:
>> 
>>> mouting with autodefrag is a serious degradation..
>> 
>> It is?  AFAIK, all the autodefrag mount option does is scan files for
>> fragmentation as they are written and queue any fragmentation-detected
>> files for background defrag by the defrag thread.
>> 
>> I had expected, particularly on spinning rust, that the benefits of
>> autodefrag to far exceed the costs, so your performance drag claim is
>> interesting to me indeed.  If my expectation is wrong, which it could
>> be, I'd love to know why, and see some numbers.
> 
> while I don't have numbers, I enabled autodefrag on all the partitions
> and rebooted(twice, just to confirm) and its slow..
> 
> everything has a 10 second tail of disk activity and has quite some
> visible latency. Moving mouse, switching windows, starting new programs,
> everything has visible latency thats unusable.
> 
> It seems autodefrag is being too aggressive for its own good..

Just to be clear, your system, your call.  I'd never /dream/ of 
interfering with that due to the implications for my own system (which is 
certainly highly customized even matched against a peer-group of other 
gentoo installs =:^).  That said...

I'm guessing what you experiences with the autodefrag mount option was 
because you were not in stable-state yet.  The original btrfs filesystem 
setup and fill was very likely without the flag on[2], so there's quite a 
lot of existing fragmentation what would have to be worked thru before 
the filesystem gets defragged and you reach stable-state, at which I'd 
expect the autodefrag mount option to have little overhead.

Tho if what you're saying is correct[1] then it may be that the 
background defrag thread isn't (io-)niced as I would have expected it to 
be.

But I'd still expect there to be some better performance steady state 
after a few mounts gets the basic filesystem defragged.  Tho if the 
fileystem is heavily fragmented[2], in practice it may well be easier to 
backup the filesystem content, do a clean mkfs and mount with autodefrag 
and restore from backup, thus ensuring autodefrag is on while filling the 
filesystem in the first place, than to wait for autodefrag to reach a 
stable system state in normal operation over many mounts.

All that stated, you've definitely demonstrated that I hadn't put enough 
thought into my initial general-case assumptions, which now come with far 
more qualifiers than they did before this subthread.  Thanks. =:^)

[1] I simply don't know from personal experience as I (1) ensured I 
enabled autodefrag on the empty filesystem before I started filling it, 
and (2) I'm on fast ssd, an entirely different world from spinning rust.

[2] Various comments I've read seem to hint that, surprisingly, certain 
distro installers leave a brand new install in a heavily fragmented 
state, as they apparently install without autodefrag on during the 
install and also apparently do heavy rewriting into existing files 
thereby triggering heavy fragmentation without the flag during that 
install.  No, I've not bothered to track which distros, I simply ensured 
autodefrag was on, here, before filling my filesystems in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


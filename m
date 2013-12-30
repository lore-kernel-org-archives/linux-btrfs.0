Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55173 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3L3IH6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:07:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxXtC-0006Qx-Ms
	for linux-btrfs@vger.kernel.org; Mon, 30 Dec 2013 09:07:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 09:07:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 09:07:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: systemd-journal, nodatacow, was: Is anyone using btrfs
 send/receive for backups instead of rsync?
Date: Mon, 30 Dec 2013 08:07:32 +0000 (UTC)
Message-ID: <pan$7390$f7d51524$89f82dd$32a90317@cox.net>
References: <20131228171943.GE19863@merlins.org>
	<20131228173730.GA7234@carfax.org.uk>
	<CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
	<CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
	<CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
	<CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
	<EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
	<pan$ac557$b59f1c0a$eeb339c8$e2df444@cox.net>
	<9B8C24F7-2F6C-4879-9A21-6A6D940BE4C1@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 29 Dec 2013 17:38:23 -0700 as excerpted:

>> And I'm predicting that since btrfs is the assumed successor to the
>> ext*
>> series as the Linux default filesystem, and systemd is targeting Linux
>> default initsystem status as well, it's only logical that at some point
>> systemd will detect what filesystem it's logging to, and will
>> automatically set NOCOW on the journal file when that filesystem is
>> btrfs.
> 
> Is this something that should be brought up on the systemd-devel@ list?
> Or maybe file it as an RFE against systemd at freedesktop.org?

I don't know.

While I don't (yet?) run systemd personally, I'd have almost thought it'd 
be done by now (tho obviously it's not, at least in distro-current 
versions), but perhaps they've been waiting on word that btrfs or some API 
they plan to use for it is stabilizing before doing it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


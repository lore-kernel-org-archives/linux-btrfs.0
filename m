Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbbF2KZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 06:25:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z9WFv-0007Hn-Kk
	for linux-btrfs@vger.kernel.org; Mon, 29 Jun 2015 12:25:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 12:25:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 12:25:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub errors but no errors ?!?
Date: Mon, 29 Jun 2015 10:25:31 +0000 (UTC)
Message-ID: <pan$f19c8$49dbc00a$e7c9c955$478b9691@cox.net>
References: <3095967.p5MQJjsH62@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Mon, 29 Jun 2015 10:42:14 +0200 as excerpted:

> Using kernel 3.19 on Ubuntu 15.04
> 
> I have a BTRFS Raid-1 FS made from 2 Luks-encrypted devices, each one
> built atop a bcache device.
> 
> The machine runs smoothly from this setup.
> 
> When I scrub said FS, it ends by spitting a message on console stating
> that "Scrub found errors but corrected them"
> 
> However if I then type :
> 
> # btrfs scrub stat /
> scrub status for 53a35066-1a7b-4fe1-9f94-a923a7f9e3af
>         scrub started at Sun Jun 28 11:17:50 2015 and finished after
>         30657 seconds
>         total bytes scrubbed: 3.01TiB with 0 errors


FWIW, I've seeing (and wondering) the same thing, tho with newer kernel 
(v4.1.0) and userspace (also v4.1)

I'm running pair-device raid1 mode (both data/metadata) but one of the 
two devices is slowly relocating sectors, so I thought it /might/ be 
btrfs detecting some oddness due to that.

But if you're seeing it too, that's unlikely.  So indeed, what's this 
found errors and corrected them bit, with no errors shown as found?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41626 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaEAGBt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 02:01:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wfk43-0004AU-HL
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 08:01:47 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 08:01:47 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 08:01:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to rebuild a 3 drive raid1 - blocked for more than 120
 seconds.
Date: Thu, 1 May 2014 06:01:34 +0000 (UTC)
Message-ID: <pan$30fe3$a9a78108$41476c4c$c7949e11@cox.net>
References: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saran Neti posted on Thu, 01 May 2014 00:48:22 -0400 as excerpted:

> I had 3 x 3 TB drives [...] Then one of the drives got busted.
> Mounting the fs in degraded mode and adding a new fresh drive to
> rebuild raid1, generated several "...blocked
> for more than 120 seconds." messages.

> Described in
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30017.html
> are two possible causes, fragmentation due to COW and hardlinks, both of
> which I think are unlikely in this case. I can mount in degraded mode
> and read files, but that's about it. Is there something I'm missing? Any
> debugging tips would be appreciated.

Just a btrfs user and list regular here, not a dev, but...

You're to be commended for all that useful information you posted.  Way 
more helpful than most manage in their first round. =:^)  But it's enough 
to see I can't be of much help but for the below, so it's mostly snipped 
here as unnecessary for this reply...

I've several times seen the devs request a magic-sysrq-w dump for cases 
like this.  That should be alt-srq-w on x86 hardware, or
echo w > /proc/sysrq-trigger (should work in a VM also).

That dumps IO-blocked tasks, letting the devs see where things are 
screwing up.

(If magic-srq is new to you, there's more about it in
$KERNDIR/Documentation/sysrq.txt.  Last I looked a google returned some 
pretty good hits discussing it, too.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


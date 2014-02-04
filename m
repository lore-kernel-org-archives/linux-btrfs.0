Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47990 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaBDGVf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 01:21:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WAZO1-0002Bb-UV
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 07:21:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 07:21:33 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 07:21:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: hitting BUG_ON on troublesome FS
Date: Tue, 4 Feb 2014 06:21:11 +0000 (UTC)
Message-ID: <pan$e1dcf$78ef7ada$46bc0f01$840ccb1c@cox.net>
References: <CCAC08D7-4639-40F4-85DD-459E6D795DAD@yerf-it.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remco Hosman - Yerf-it.com posted on Mon, 03 Feb 2014 21:51:26 +0100 as
excerpted:

> Anything i can do to resolve / debug the issue?

I see from the trace you're running kernel 3.13.0.  (FWIW 3.13.1 is out, 
but there weren't any btrfs commits therein, as they weren't upstream in 
3.14-pre yet at that time.)

You might try kernel 3.14-rc1 now that it's out.  There's a big btrfs git 
pull in that, including a number of btrfs send/receive fixes.  FWIW, 
btrfs send/receive seems to be a big focus right now, and I see a lot of 
patches floating by on the list even after that pull, so there's more 
where those came from.

I'm not a dev (just another btrfs user and list regular for several 
kernel cycles now) and haven't followed the patches closely enough to 
know if your particular balance problem is covered in one of them, but as 
I said, since 3.14-rc1 is out now, you might as well try it...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


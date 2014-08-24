Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaHXA5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 20:57:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLM79-0003eo-5z
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 02:56:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 02:56:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 02:56:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Sun, 24 Aug 2014 00:56:47 +0000 (UTC)
Message-ID: <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
References: <53F7BD8E.10308@floga.de>
	<pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de>
	<pan$16219$d960b649$52ed1e6$33540704@cox.net>
	<20140823163803.GA9149@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Sat, 23 Aug 2014 12:38:05 -0400 as excerpted:

> Consumer SD cards are /terrible/ storage devices.  Always back up all
> data written to an SD card as soon as possible after writing it, and
> develop a process to restore the backup to a new SD card conveniently
> when--not if--the card fails.
> 
> Over the years I've burned my way through dozens of SD cards in Pis,
> Beagles, x86 laptops, USB SD card readers, cameras and cell phones.
> I have more bad or failed cards than good ones in my collection, but no
> more than three of any specific model.  Brand, price, and specs don't
> correlate to success or failure.  Even the good cards wear out after
> heavy use.  The bad ones fail much faster, and are more likely to give
> you garbage data instead of properly formed I/O errors as they fail.

I had read that it was bad, but I didn't know it was /that/ bad.  The 
ones I've used have tended to be write-once, read for quite some time, 
often lose (or throw away as obsolete due to tiny size) before I write 
them again, or at least before I write them half a dozen times, and I've 
generally not has problems with them doing that, but I wouldn't tend to 
know about routine rewrite behavior.  Sounds like it's much worse than I 
might have thought.

Thanks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


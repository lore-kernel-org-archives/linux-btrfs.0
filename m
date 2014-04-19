Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37247 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaDSE7y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 00:59:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WbNNX-0001pv-OE
	for linux-btrfs@vger.kernel.org; Sat, 19 Apr 2014 06:59:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 06:59:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 06:59:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: SSD TRIM on balance
Date: Sat, 19 Apr 2014 04:59:40 +0000 (UTC)
Message-ID: <pan$d3f18$ce6243a7$353dc24b$c2a46503@cox.net>
References: <53515BB4.7070700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sergey E. Kolesnikov posted on Fri, 18 Apr 2014 21:07:00 +0400 as
excerpted:

> I've recently rebalanced my btrfs (kernel 3.13) running on two SSD
> drives (raid-0) and a question arose.
> Does btrfs perform TRIM on SSD balance? Fs is mounted with 'ssd' option,
> but not 'discard'.
> 
> It seems fstrim only trims free chunks in allocated space, so we
> possibly having a "trim leak" if no special treatment is taken on blocks
> reallocated during balance operation.

As a user and list-regular, I don't know the answer to your question as 
I've not seen it come up before and don't recall seeing it covered on the 
wiki or the like either, but you have a very good point... and question.

FWIW I'm on dual-physical-device-SSDs here too (tho on btrfs raid1 mainly 
because I like having a second copy of everything to restore from in case 
the one copy goes bad and fails checksum) and also don't use the discard 
option.  While I'm currently running nearly 50% overprovisioned and thus 
the FTL has plenty of space to do its thing regardless of what I do with 
trim on the actually partitioned space, you raise a very good question 
indeed, one I wish I had thought to ask myself, and now that you have, 
one I'd very much like an answer to as well.

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43362 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaAaF6z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 00:58:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W977u-0006f3-3c
	for linux-btrfs@vger.kernel.org; Fri, 31 Jan 2014 06:58:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 06:58:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 06:58:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lost with degraded RAID1
Date: Fri, 31 Jan 2014 05:58:27 +0000 (UTC)
Message-ID: <pan$7d02a$d46a4ede$2832dda8$da2d2ddd@cox.net>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
	<CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
	<pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net>
	<8FF7CD63-3B07-42CB-88C3-E88D39280892@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 30 Jan 2014 20:00:39 -0700 as excerpted:

> Another question for Johann is what exact balance command was to go back
> to single? Was there -dconvert and -mconvert? Both are required to go
> from raid1/raid to single/DUP or single/single, and actually get rid of
> the 2nd device. And looking at the man page, I'm not sure how we do that
> conversion and specify which multiple device we're dropping:
> 
> [filesystem] balance start [options] <path>
> 
> With a missing device, presumably this is obvious, but…

Of course the normal no-missing-device usage of a balance converting back 
to single would be one of:

1) Multi-device raidN converting back to single with all devices present, 
presumably either to get more space (from raid1/5/6/10), or to get back 
/some/ device-loss tolerance when converting back from raid0 (presumably 
a data-only conversion in that case, with metadata kept as the default 
multi-device raid1).

2) Single-device, converting metadata-only to single from dup, either for 
space reasons, or because the physical device is SSD (in which case 
single-device metadata default is used due to some devices doing hardware/
firmware dedup with the effect of dup metadata on such a device thus not 
entirely predictable anyway), possibly an ssd that does deduping in 
hardware, so dup mode's not particularly useful and is somewhat 
unpredictable in any case.

IOW, just because it's a conversion to single mode doesn't mean we're 
dropping a device, and a rebalance to single mode wasn't in fact designed 
to drop a device (that's what device delete is for), so it doesn't really 
need a way to specify a device to drop.  If one is missing, a rebalance 
will obviously rebalance to existing devices, that's obvious, but 
otherwise, balance isn't the command for that, device delete is.

But your question to Johann remains valid, since we don't know for sure 
that he was doing the "correct" full balance -dconvert -mconvert, and so 
far I've simply assumed he was.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


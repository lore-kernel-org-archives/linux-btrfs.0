Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36535 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbbKADW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 23:22:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZsjEM-0006G6-FU
	for linux-btrfs@vger.kernel.org; Sun, 01 Nov 2015 04:22:54 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 04:22:54 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 04:22:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
Date: Sun, 1 Nov 2015 03:22:40 +0000 (UTC)
Message-ID: <pan$a7ff8$b9ccf1a9$e2bf7f07$68b37eec@cox.net>
References: <n0bqib$2om$1@ger.gmane.org> <5635140F.7040206@googlemail.com>
	<5635508A.4080401@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philip Seeger posted on Sun, 01 Nov 2015 00:36:42 +0100 as excerpted:

> On 10/31/2015 08:18 PM, Philip Seeger wrote:

>> But it looks like there are still some "invisible" errors on this (now
>> empty) filesystem; after rebooting and mounting it, this one error is
>> logged:
>> BTRFS: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 199313, gen 0
> 
> However, this "invisible" error shows up even with this kernel version.
> 
> So I'm still wondering why this error is happening even after a 
> successful scrub.

That's NOTABUG and not an error, functioning as designed.

Btrfs device error counts are retained until manually reset, and do not 
restart at zero at reboot or with a umount/mount or btrfs module remove/
insert cycle.  This highlights problem devices over time as their error 
counts increase.

So what btrfs is logging to dmesg on mount here, are the historical error 
counts, in this case expected as they were deliberate during your test, 
nearly 200K of them, not one or more new errors.

To have btrfs report these at the CLI, use btrfs device stats.  To zero 
them out, use its -z option.  Then mounting should again report 0 corrupt 
in dmesg once again... until some other error happens, of course. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


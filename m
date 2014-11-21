Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:60185 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbaKUNQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 08:16:24 -0500
Received: from mdfmta010.tbr.inty.net (unknown [127.0.0.1])
	by mdfmta010.tbr.inty.net (Postfix) with ESMTP id 2D9596F9D40
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 13:10:51 +0000 (GMT)
Received: from mdfmta010.tbr.inty.net (unknown [127.0.0.1])
	by mdfmta010.tbr.inty.net (Postfix) with ESMTP id 094706F9654
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 13:10:51 +0000 (GMT)
Received: from iarmst.demon.co.uk (unknown [62.49.16.35])
	by mdfmta010.tbr.inty.net (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 13:10:50 +0000 (GMT)
Date: Fri, 21 Nov 2014 12:55:48 +0000
From: Ian Armstrong <btrfs@iarmst.co.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141121125548.4ed20963@spike.private.network>
In-Reply-To: <546EE43C.7020900@swiftspirit.co.za>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
 <546AF572.2020101@swiftspirit.co.za>
 <20141121045801.GS17395@hungrycats.org>
 <546EE43C.7020900@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Nov 2014 09:05:32 +0200, Brendan Hide wrote:

> On 2014/11/21 06:58, Zygo Blaxell wrote:

> > I also notice you are not running regular SMART self-tests (e.g.
> > by smartctl -t long) and the last (and first, and only!) self-test
> > the drive ran was ~12000 hours ago.  That means most of your SMART
> > data is about 18 months old.  The drive won't know about sectors
> > that went bad in the last year and a half unless the host happens
> > to stumble across them during a read.
> >
> > The drive is over five years old in operating hours alone.  It is
> > probably so fragile now that it will break if you try to move it.

> All interesting points. Do you schedule SMART self-tests on your own 
> systems? I have smartd running. In theory it tracks changes and sends 
> alerts if it figures a drive is going to fail. But, based on what
> you've indicated, that isn't good enough.

Simply monitoring the smart status without a self-test isn't really that
great. I'm not sure on the default config, but smartd can be made to
initiate a smart self-test at regular intervals. Depending on the test
type (short, long, etc) it could include a full surface scan. This can
reveal things like bad sectors before you ever hit them during normal
system usage.

> 
> > WARNING: errors detected during scrubbing, corrected.
> > [snip]
> > scrub device /dev/sdb2 (id 2) done
> > 	scrub started at Tue Nov 18 03:22:58 2014 and finished
> > after 2682 seconds total bytes scrubbed: 189.49GiB with 5420 errors
> > 	error details: read=5 csum=5415
> > 	corrected errors: 5420, uncorrectable errors: 0, unverified
> > errors: 164 That seems a little off.  If there were 5 read errors,
> > I'd expect the drive to have errors in the SMART error log.
> >
> > Checksum errors could just as easily be a btrfs bug or a RAM/CPU
> > problem. There have been a number of fixes to csums in btrfs pulled
> > into the kernel recently, and I've retired two five-year-old
> > computers this summer due to RAM/CPU failures.

> The difference here is that the issue only affects the one drive.
> This leaves the probable cause at:
> - the drive itself
> - the cable/ports
> 
> with a negligibly-possible cause at the motherboard chipset.

This is the same problem that I'm currently trying to resolve. I have
one drive in a raid1 setup which shows no issues in smart status but
often has checksum errors.

In my situation what I've found is that if I scrub & let it fix the
errors then a second pass immediately after will show no errors. If I
then leave it a few days & try again there will be errors, even in
old files which have not been accessed for months.

If I do a read-only scrub to get a list of errors, a second scrub
immediately after will show exactly the same errors.

Apart from the scrub errors the system logs shows no issues with that
particular drive.

My next step is to disable autodefrag & see if the problem persists.
(I'm not suggesting a problem with autodefrag, I just want to remove it
from the equation & ensure that outside of normal file access, data
isn't being rewritten between scrubs)

-- 
Ian

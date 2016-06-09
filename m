Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbcFIGQK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 02:16:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bAtGA-0004pq-Lh
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 08:16:06 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 08:16:06 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 08:16:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommended why to use btrfs for production?
Date: Thu, 9 Jun 2016 06:16:01 +0000 (UTC)
Message-ID: <pan$f0f75$1ba12fd1$de89e173$5dda67a@cox.net>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
	<dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 03 Jun 2016 10:21:12 -0400 as
excerpted:

> As far as BTRFS raid10 mode in general, there are a few things that are 
> important to remember about it:
> 1. It stores exactly two copies of everything, any extra disks just add 
> to the stripe length on each copy.

I'll add one more, potentially very important, related to this one:

Btrfs raid mode (any of them) works in relation to individual chunks, 
*NOT* individual devices.

What that means for btrfs raid10 in combination with the above exactly 
two copies rule, is that it works rather differently than a standard 
raid10, which can tolerate loss of two devices as long as they're from 
the same mirror set, as the other mirror set will then still be whole.  
Because with btrfs raid10 the mirror sets are dynamic per-chunk, loss of 
a second device close to assures loss of data, because the very likely 
true assumption is that both mirror sets will be affected for some 
chunks, but not others.

By using a layered approach, btrfs raid1 on top (for its error correction 
from the other copy feature) of a pair of mdraid0s, you force one of the 
btrfs raid1 copies to each of the mdraid0s, thus making allocation more 
deterministic than btrfs raid10, and can thus again tolerate loss of two 
devices, as long as they're from the same underlying mdraid0.

(Traditionally, raid1 on top of raid0 is called raid01, and is 
discouraged compared to raid10, raid0 on top of raid1, because device 
failure and replacement with the latter triggers a much more localized 
rebuild than the former, across the pair of devices in the raid1 when 
it's closest to the physical devices, across the whole array, one raid0 
to the other, when the raid1 is on top.  However, btrfs raid1's data 
integrity and error repair from the good mirror feature is generally 
considered to be useful enough to be worth the rebuild-inefficiency of 
the raid01 design.)

So in regard to failure tolerance, btrfs raid10 is far closer to 
traditional raid5, loss of a single device is tolerated, loss of a second 
before a repair is complete generally means data loss -- there's not the 
chance of it being on the same mirror set to save you that traditional 
raid10 has.

Similarly, btrfs raid10 doesn't have the cleanly separate pair of mirrors 
on raid0 arrays that traditional raid10 does, thus doesn't have the fault 
tolerance of losing say the connection or power to one entire device 
bank, as long as it's all one mirror set, that traditional raid10 has.

And again, doing the layered thing with btrfs raid1 on top and mdraid0 
(or whatever else) underneath gets that back for you, if you set it up 
that way, of course.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


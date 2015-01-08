Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54518 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbAHGcS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 01:32:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y96dT-0006uJ-An
	for linux-btrfs@vger.kernel.org; Thu, 08 Jan 2015 07:31:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 07:31:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 07:31:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: price to pay for nocow file bit?
Date: Thu, 8 Jan 2015 06:30:59 +0000 (UTC)
Message-ID: <pan$2625$dcbfe450$9a65d855$d7e62f1e@cox.net>
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik posted on Wed, 07 Jan 2015 15:10:06 -0500 as excerpted:

>> Does this have any effect on functionality? As I understood snapshots
>> still work fine for files marked like that, and so do reflinks. Any
>> drawback functionality-wise? Apparently file compression support is
>> lost if the bit is set? (which I can live with too, journal files are
>> internally compressed anyway)
>>
>>
> Yeah no compression, no checksums.  If you do reflink then you'll COW
> once and then the new COW will be nocow so it'll be fine.  Same goes for
> snapshots.  So you'll likely incur some fragmentation but less than
> before, but I'd measure to just make sure if it's that big of a deal.
> 
>> What about performance? Do any operations get substantially slower by
>> setting this bit? For example, what happens if I take a snapshot of
>> files with this bit set and then modify the file, does this result in a
>> full (and hence slow) copy of the file on that occasion?
>>
>>
> Performance is the same.

The otherwise nocow on-snapshot "cow1" is per-block (4096-byte AFAIK), so 
some fragmentation, but slower.

The "perfect storm" situation is people doing automated per-minute 
snapshots or similar (some people go to extremes with snapper or the 
like...), in which case setting nocow often doesn't help a whole lot, 
depending on how active the file-writing is, of course.

But for something like append-plus-pointer-update-pattern log files with 
something like per-day snapshotting, nocow should at least in theory help 
quite a bit, since the write-frequency and thus the prevented cows should 
be MUCH higher than the daily snapshot and thus the forced-block-cow1s.

-

FWIW, I'm systemd on btrfs here, but I use syslog-ng for my non-volatile 
logs and have Storage=volatile in journald.conf, using journald only for 
current-session, where unit status including last-10-messages makes 
troubleshooting /so/ much easier. =:^)  Once past current-session, text 
logs are more useful to me, which is where syslog-ng comes in.  Each to 
its strength, and keeping the journals from wearing the SSDs[1] is a very 
nice bonus. =:^)

---
[1] I can and do filter what syslog-ng writes, but couldn't find a way to 
filter journald's writes, only  queries/reads.  That alone saves writes 
for repeated noise I'm filtering out with syslog before it's ever 
written, that journald would still be writing if I let it write non-
volatile.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


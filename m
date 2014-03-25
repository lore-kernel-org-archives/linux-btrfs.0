Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54217 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaCYT2f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 15:28:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSX1V-0007hq-Gt
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 20:28:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 20:28:33 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 20:28:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug in profile balance not present in normal balance
Date: Tue, 25 Mar 2014 19:28:03 +0000 (UTC)
Message-ID: <pan$1d0b0$f63ec67e$fc4fd448$85dcb7ed@cox.net>
References: <CAJtFHUQsQLD-vK-hy+HPfex_5RpxdoyOcu-9v20DbaXVHGRx+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

E V posted on Tue, 25 Mar 2014 14:56:08 -0400 as excerpted:

> Plenty of meta data space and such:
> Metadata, RAID1: total=134.00GiB, used=87.27GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
>  just seems to be some blocks that the profile covert fails on that a
> regular balance process fine. This is using kernel 3.13.7 and
> btrfs-progs 3.12. Any suggestions would be great, thanks,

What about unallocated space, that is, the difference between total space 
and used space, per device, as reported by btrfs filesystem show?

That's what btrfs balance uses, the unallocated space.  Balance works on 
data, metadata or system chunks, but uses unallocated space to create the 
new chunks it then copies the data/metadata to from the old chunks, 
before freeing them.  So if unallocated space drops too low, balance will 
fail with enospace errors.

But you didn't post the unallocated space, you posted metadata space, 
which should stay just as it is (tho I guess some pointers will need 
rewritten as the data chunk they point to is rewritten), because you 
specified a -d/data balance, not metadata.

That said, profile=raid0,convert=single, failing where a standard balance 
without the profile convert succeeds, is a bit strange.  raid0-to-single 
conversion should use the same amount of space but be less picky about 
where it's located, so why it would enospace, where a standard balance 
(which should be more picky than conversion to single about where the new 
chunks get written, when it's replacing raid0 with raid0 without the 
conversion to single) succeeds, remains a good question indeed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


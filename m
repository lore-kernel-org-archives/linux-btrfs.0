Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50701 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3JVN2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 09:28:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VYc0D-0003ZC-Bj
	for linux-btrfs@vger.kernel.org; Tue, 22 Oct 2013 15:28:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 15:28:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 15:28:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid5
Date: Tue, 22 Oct 2013 13:27:44 +0000 (UTC)
Message-ID: <pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

lilofile posted on Mon, 21 Oct 2013 23:45:58 +0800 as excerpted:

> hi:
>     since RAID 5/6 code merged into Btrfs from  2013.2, no update and
>     bug are found in maillist? is any development plan with btrfs raid5?
>     such as adjusting stripe width、 reconstruction？
>   compared to md raid5  what is advantage in btrfs raid5 ?

AFAIK, btrfs raid5/6 modes are still not considered ready for deployed 
use, only for testing (tho with each new kernel cycle I wonder if that 
has changed, but no word on it changing yet).  This is because there's a 
hole in the recovery process in case of a lost device, making it 
dangerous to use except for the pure test-case.

Yes, flushing out the features a bit is planned, tho I've not tracked 
specifics.  (My primary interest and use-case is the N-way-mirroring 
raid1 case, which is roadmapped for merging after raid5/6 stabilize; 
current "raid1" case is limited to 2-way-mirroring.  So mostly I'm simply 
tracking raid5/6 progress in relation to that, not for its own merits, 
thus I'm not personally tracking the specifics too closely.)

The advantage in btrfs raid5/6 is that unlike md/raid, btrfs knows what 
blocks are actually used by data/metadata, and can use that information 
in a rebuild/recovery situation to only sync/rebuild the actually used 
blocks on a re-added or replacement device, skipping blocks that were 
entirely unused/empty in the first place.

md/raid can't do that, because it tries to be a filesystem agnostic layer 
that doesn't know nor care what blocks on the layers above it were 
actually used or empty.  For it to try to track that would be a layering 
violation and would seriously complicate the code and/or limit usage to 
only those filesystems or other layers above that it supported/understood/
could-properly-track.

A comparable relationship exists between a ramdisk (comparable to md/
raid) and tmpfs (comparable to btrfs) -- the first is transparent and 
allows the flexibility of putting whatever filesystem or other upper 
layer on top, while the latter is the filesystem layer itself, allowing 
nothing else above it.  But the ramdisk/tmpfs case deals with memory 
emulating block device storage, while the mdraid/btrfs case deals with 
multiple block devices emulating a single device.  In both cases each has 
its purpose, with the strengths of one being the limitations of the 
other, and you choose the one that best matches your use case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


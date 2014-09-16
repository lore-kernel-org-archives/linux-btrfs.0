Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41872 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbaIPAIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 20:08:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XTgK5-0007s4-Gm
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 02:08:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 02:08:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 02:08:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance enospc
Date: Tue, 16 Sep 2014 00:08:31 +0000 (UTC)
Message-ID: <pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune>
	<541723EA.6010608@intellasoft.net>
	<657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 15 Sep 2014 14:54:57 -0600 as excerpted:

>> I still get enospc after a balance with a filter, and then a regular
>> balance:
>> 
>> cartman {~} root# btrfs balance start /
>> ERROR: error during balancing '/' - No space left on device
> 
> Maybe try mount option enospc_debug and retry, see if you get more
> information in dmesg.
> 
> I'm not sure if a balance in this case wants to create a new data and
> metadata chunk (on each device), or if it can start without creating any
> chunks. If it wants to create new chunks, it's 1GiB for data, and 256MiB
> for metadata. That's 1.256GiB but you only have 1.25GiB unallocated on
> each device: size 9.31GiB minus used 8.06GiB.

Another possibility that has hit a few people:

Did you (MM/OP not CM) convert that filesystem from ext* to btrfs?  If 
so, read on.  If not, this doesn't apply so you may skip it.

Assuming such a conversion, did you delete the subvolume containing the 
original ext* yet, or not?  If not, that may be the problem, because that 
subvolume must be left intact in ordered to allow rollback to ext* if 
desired.  If you know you won't be rolling back, delete the ext* reserved 
subvolume as described on the wiki.

Meanwhile, after deleting that subvolume, be sure to complete the defrag 
and balance as suggested on the wiki, because failing to do so can lead 
to other problems later.  Basically, the biggest extent size supported by 
btrfs is 1 GiB, the size of a btrfs data chunk, while ext* supports 
larger (unlimited size?) extents.  Failing to complete the defrag in 
particular as suggested can mean large files with extents > 1 GiB in 
size, which gives btrfs balance indigestion since it expects to see only 
1 GiB or smaller extents.  Several folks who converted from ext3/4 have 
reported failed balances due to these too large extents, and fixing the 
problem later can require manually moving one-by-one all files large 
enough to be candidates for the problem (thus files > 1 GiB) out of btrfs 
and back in, thus resulting in properly chunk-split extents when the file 
is moved back to btrfs.  Everyone who has reported this problem so far, 
has also reported that the move out and back in process solved the 
problem for them, but if there's lots of such files it can be a pain, and 
doing the defrag on the formerly ext* files before starting to use the 
now btrfs for other things, ESPECIALLY before trying to snapshot affected 
subvolumes since that locks the problem in place until those snapshots 
are deleted, is definitely preferred. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


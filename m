Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaGVUVf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 16:21:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9gZ0-0007J1-HM
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 22:21:30 +0200
Received: from athedsl-370925.home.otenet.gr ([79.131.0.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 22:21:30 +0200
Received: from tmjuju by athedsl-370925.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 22:21:30 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Tue, 22 Jul 2014 20:21:16 +0000 (UTC)
Message-ID: <loom.20140722T221814-497@post.gmane.org>
References: <loom.20140720T102642-239@post.gmane.org> <53CC6B39.1060705@cn.fujitsu.com> <loom.20140721T155907-291@post.gmane.org> <53CDBBC7.6000609@cn.fujitsu.com> <loom.20140722T164042-111@post.gmane.org> <53CE8394.9010903@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Behrens <sbehrens <at> giantdisaster.de> writes:


> TM, Just read the man-page. You could have used the replace tool after
> physically removing the failing device.
> 
> Quoting the man page:
> "If the source device is not available anymore, or if the -r option is
> set, the data is built only using the RAID redundancy mechanisms.
> 
> Options
> -r   only read from <srcdev> if no other zero-defect mirror
>      exists (enable this if your drive has lots of read errors,
>      the access would be very slow)"
> 
> Concerning the rebuild performance, the access to the disk is linear for
> both reading and writing, I measured above 75 MByte/s at that time with
> regular 7200 RPM disks, which would be less than 10 hours to replace a
> 3TB disk (in worst case, if it is completely filled up).
> Unused/unallocated areas are skipped and additionally improve the
> rebuild speed.
> 
> For missing disks, unfortunately the command invocation is not using the
> term "missing" but the numerical device-id instead of the device name.
> "missing" _is_ implemented in the kernel part of the replace code, but
> was simply forgotten in the user mode part, at least it was forgotten in
> the man page.
> 

Hi Stefan,
thank you very much, for the comprehensive info, I will opt to use replace
next time.

Breaking news :-) 
from Jul 19 14:41:36 microserver kernel: [ 1134.244007] btrfs: relocating
block group 8974430633984 flags 68
to  Jul 22 16:54:54 microserver kernel: [268419.463433] btrfs: relocating
block group 2991474081792 flags 65

Rebuild ended before counting down to 00000000
So flight time was 3 days, and I see no more messages or btrfs processes
utilizing cpu. So rebuild seams ready.
Just a few hours ago another disk showed some earlly touble accumulating
Current_Pending_Sector but no Reallocated_Sector_Ct yet.


TM


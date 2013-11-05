Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58496 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3KEQMS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 11:12:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VdjEl-0003iW-K6
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 17:12:16 +0100
Received: from 63-245-179-205.ip.mtelco.net ([63-245-179-205.ip.mtelco.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 17:12:15 +0100
Received: from jgoerzen by 63-245-179-205.ip.mtelco.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 17:12:15 +0100
To: linux-btrfs@vger.kernel.org
From: John Goerzen <jgoerzen@complete.org>
Subject: Re: umount waiting for 12 hours and still running
Date: Tue, 5 Nov 2013 16:11:56 +0000 (UTC)
Message-ID: <loom.20131105T170351-783@post.gmane.org>
References: <5278F5AA.60108@complete.org> <pan$70ff2$6c271d88$3a2794d1$837be634@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> John Goerzen posted on Tue, 05 Nov 2013 07:42:02 -0600 as excerpted:
> 
> > The filesystem in question involves two 2TB USB hard drives.  It is 49%
> > full.  Data is RAID0, metadata is RAID1.  The files stored on it are for
> > BackupPC, meaning there are many, many directories and hardlinks.  I
> > would estimate 30 million inodes in use and many of them have dozens of
> > hardlinks to them.
> 
> That's a bit of a problem for btrfs at this point, as you rightly mention.

Hi Duncan,

Thank you very much for taking the time to reply.

Can you clarify a bit about what sort of problems I might expect to
encounter with this sort of setup on btrfs?

> 
> > I thought perhaps converting metadata to raid0 would help.  So I
> > started a btrfs balance start -mconver=raid0 on it.
> 
> > Kernel 3.10 from Debian wheezy backports on i386.
> 
> There's a known bug with balance on current kernels related to pre-
> allocated space (as with the systemd journal or torrent files with some 
> clients).

[snip ]

> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/287

I'm almost completely sure that this bug wasn't being hit.  The files were
streamed back by restore(8), and a few written by BackupPC.  I checked the
source to both just to make sure, and neither have a call to fallocate.  I
do not believe there were sparse files on the disk either.   I also haven't
experienced the csum errors mentioned in the post.   

Thanks again,

-- John



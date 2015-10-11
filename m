Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36548 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbbJKXAN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 19:00:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZlPb3-0000Ql-2y
	for linux-btrfs@vger.kernel.org; Mon, 12 Oct 2015 01:00:05 +0200
Received: from 14-203-97-18.static.tpgi.com.au ([14.203.97.18])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 01:00:05 +0200
Received: from kristan by 14-203-97-18.static.tpgi.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 01:00:05 +0200
To: linux-btrfs@vger.kernel.org
From: Kristan <kristan@bekus.id.au>
Subject: Re: BTRFS with 8TB SMR drives
Date: Sun, 11 Oct 2015 22:53:45 +0000 (UTC)
Message-ID: <loom.20151012T004428-772@post.gmane.org>
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Warren Hughes <wsh <at> warrenhughes.net> writes:

> 
> Hi guys, just added a new Seagate Archive 8TB drive to my BTRFS volume
> and I'm getting a tonne of errors when balancing or scrubbing.
> 
> A short smartctl test reports fine, running a long one now. Will also
> run seatools from a bootable DOS USB while at work today.
> 
> Running latest firmware on my 9240-8i which explicitly supports this 
drive.
> 
> I'm finding it very hard to tell if SMR drives are OK with BTRFS
> currently - anyone chime in?
> 
> Thanks, Warren
> 
> [wsh <at> cloud storcli]$ uname -a
> Linux cloud.warrenhughes.net 4.1.10-2-lts #1 SMP Wed Oct 7 21:57:44
> CEST 2015 x86_64 GNU/Linux
> 
> [wsh <at> cloud storcli]$ sudo btrfs version
> btrfs-progs v4.2.1
> 
> [wsh <at> cloud ~]$ sudo btrfs scrub status /mnt/media
> scrub status for 643c3145-8371-4011-8c34-20240e1bbaff
>         scrub started at Sun Oct 11 20:37:38 2015 and was aborted 
after 10:35:47
>         total bytes scrubbed: 8.15TiB with 104218141 errors
>         error details: read=98736175 csum=5481966
>         corrected errors: 5484382, uncorrectable errors: 98733759,
> unverified errors: 0
> 
> [/dev/sdo].write_io_errs   100154203
> [/dev/sdo].read_io_errs    98735251
> [/dev/sdo].flush_io_errs   634
> [/dev/sdo].corruption_errs 5481966
> [/dev/sdo].generation_errs 0
> 

hi Warren,

I recently (last week) built a 3 disk RAID 5 array using the same 8TB 
drives which worked fine holding ~12TB then added a 4th disk using a 
JMicron PCI SATA controller. I then ran a balance which failed after 
just over 1TB written to the 4th disk. This caused the entire array to 
fail but the main difference to your scenario was that the 4th disk also 
wasn't reporting to SMART properly. 
I then moved all 4 disks onto the motherboard based SATA controller, 
built the array fresh and have copied ~18TB onto it and it seems to be 
working fine. Perhaps I should try a scrub and see :)

I'm using Centos 7.1 but kernel 4.2.1-ml and btrfs-progs 4.2.2
Kristan


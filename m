Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33393 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaLJNLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:11:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xyh2v-0007y6-VY
	for linux-btrfs@vger.kernel.org; Wed, 10 Dec 2014 14:11:14 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 14:11:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 14:11:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Wed, 10 Dec 2014 13:11:03 +0000 (UTC)
Message-ID: <pan$adbdd$de0c5a95$a95c46aa$74eda7e0@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 10 Dec 2014 04:17:50 -0800 as excerpted:

>> BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
>> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
>> BTRFS: space_info 1 has 4773171200 free, is not full BTRFS: space_info
>> total=1494648619008, used=1489775505408, pinned=0, reserved=99700736,
>> may_use=2102390784, readonly=241664
> 
> So it was looking for a single chunk 2013265920 bytes long and it
> couldn't find one because all the spaces were smaller and there was no
> room to make a new suitable space.
> 
> The problem is that it wanted 2013265920 bytes and while the system as a
> whole had no way to satisfy that desire. It asked for something just shy
> of two gigs as a single extent. That's a tough order on a full platter.
> 
> Since your entire free size is 2102390784 that is an attempt to allocate
> about 80% of your free space as one contiguous block. That's never going
> to happen. 8-)
> 
> I don't even know if 2GiB is normally a legal size for an extent. My
> understanding is that data is allocated in 1G chunks, so I'd expect all
> extents to be smaller than 1G.

On native btrfs, an extent must fit within the 1 GiB data chunk size, 
with extents inherited from an ext* conversion being an obvious non-
native exception.

I hadn't looked at the actual output, but that confirms my earlier 
suspicion, that after the ext* saved subvolume delete, the defrag somehow 
missed at least one file > 1 GiB with a "super-extent" also > 1 GiB in 
size.

>From there... I've never used it but I /think/ btrfs inspect-internal 
logical-resolve should let you map the 182109... address to a filename.  
>From there, moving that file out of the filesystem and back in should 
eliminate that issue.

Assuming no snapshots still contain the file, of course, and that the 
ext* saved subvolume has already been deleted.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


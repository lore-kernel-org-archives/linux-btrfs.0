Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout013.mail.hostpoint.ch ([217.26.49.173]:59706 "EHLO
	mxout013.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbcFPSSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 14:18:53 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout013.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bDbsQ-0004KY-Tp
	for linux-btrfs@vger.kernel.org; Thu, 16 Jun 2016 20:18:50 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bDbsQ-00053A-Rp
	for linux-btrfs@vger.kernel.org; Thu, 16 Jun 2016 20:18:50 +0200
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <2FE8C51A-285F-48E5-B939-CA5977B3A75B@bueechi.net>
Date: Thu, 16 Jun 2016 20:18:50 +0200
Message-Id: <BCC1C109-01F3-4E10-A138-756E105F4F13@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net> <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net> <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net> <e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com> <E0C7FC1F-AEEE-4A79-9031-51FF616D027B@bueechi.net> <pan$b3671$36ea03da$e28136e8$8de0280e@cox.net> <2FE8C51A-285F-48E5-B939-CA5977B3A75B@bueechi.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> a "replace" of the 3rd 6 TB drive onto a second 8 TB drive is currently in progress (at high speed).

This second replace is now finished, and it looks OK now:

	# btrfs replace status /data
	Started on 16.Jun 01:15:17, finished on 16.Jun 11:40:30, 0 write errs, 0 uncorr. read errs

Transfer rate of ~134 MiB/s, or ~2.2 hours per TiB.

	# btrfs device usage  /data 
	/dev/dm-2, ID: 3
	   Device size:             5.46TiB
	   Data,RAID1:              4.85TiB
	   Metadata,RAID1:          3.00GiB
	   Unallocated:           620.03GiB

	/dev/mapper/AAAAAAAA_enc, ID: 1
	   Device size:             7.28TiB
	   Data,RAID1:              6.66TiB
	   Metadata,RAID1:         12.69GiB
	   System,RAID1:           64.00MiB
	   Unallocated:           620.31GiB

	/dev/mapper/BBBBBBBB_enc, ID: 2
	   Device size:             7.28TiB
	   Data,RAID1:              4.79TiB
	   Metadata,RAID1:          9.69GiB
	   System,RAID1:           64.00MiB
	   Unallocated:           676.31GiB

However, while the replace was in progress, it showed weird stuff, like this percentage > 100 today at 9am (~3 hours before completion):

	# btrfs replace status /data       
	272.1% done, 0 write errs, 0 uncorr. read errs

Also, contrary to he first replace, filesystem info was not updated during the replace, and looked like this (for example):

	# btrfs device usage  /data 
	/dev/dm-2, ID: 3
	   Device size:             5.46TiB
	   Data,RAID1:              4.85TiB
	   Metadata,RAID1:          3.00GiB
	   Unallocated:           620.03GiB

	/dev/dm-3, ID: 2
	   Device size:             5.46TiB
	   Data,RAID1:              4.79TiB
	   Metadata,RAID1:          9.69GiB
	   System,RAID1:           64.00MiB
	   Unallocated:           676.31GiB

	/dev/mapper/AAAAAAAA_enc, ID: 1
	   Device size:             7.28TiB
	   Data,RAID1:              6.66TiB
	   Metadata,RAID1:         12.69GiB
	   System,RAID1:           64.00MiB
	   Unallocated:           620.31GiB

	/dev/mapper/BBBBBBBB_enc, ID: 0
	   Device size:             7.28TiB
	   Unallocated:             5.46TiB

I'm happy it worked, just wondering why it behaved weirdly this second time.

During the first replace, my Fedora 23 was booted in emergency mode, whereas for the second time it was booted normally.

I'm going to reboot now to update Kernel 4.5.5 to 4.5.6 and then continue replacing drives.


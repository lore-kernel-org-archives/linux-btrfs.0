Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42971 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751136AbaE1HDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 03:03:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Failed Disk RAID10 Problems
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com>
Date: Wed, 28 May 2014 01:03:51 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <08C16AE5-02A8-413B-B95C-EC2B5A1D32EC@colorremedies.com>
References: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com>
To: Justin Brown <justin.brown@fandingo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 28, 2014, at 12:19 AM, Justin Brown <justin.brown@fandingo.org> wrote:

> Hi,
> 
> I have a Btrfs RAID 10 (data and metadata) file system that I believe
> suffered a disk failure. In my attempt to replace the disk, I think
> that I've made the problem worse and need some help recovering it.
> 
> I happened to notice a lot of errors in the journal:
> 
> end_request: I/O error, dev dm-11, sector 1549378344
> BTRFS: bdev /dev/mapper/Hitachi_HDS721010KLA330_GTA040PBG71HXF1 errs:
> wr 759675, rd 539730, flush 23, corrupt 0, gen 0
> 
> The file system continued to work for some time, but eventually a NFS
> client encountered IO errors. I figured that device was failing (It
> was very old.). I attached a new drive to the hot-swappable SATA slot
> on my computer, partitioned it with GPT, and ran partprobe to detect
> it. Next I attempted to add a new device, which was successful.

For future reference, it should to add a device and then use btrfs device delete missing. But I've found btrfs replace start to be more reliable. It does the add, delete and balance in one step.


> ~: mount /dev/mapper/SAMSUNG_HD103SI_499431FS734755p1 /var/media
> mount: wrong fs type, bad option, bad superblock on
> /dev/mapper/SAMSUNG_HD103SI_499431FS734755p1,
>       missing codepage or helper program, or other error
> 
>       In some cases useful info is found in syslog - try
>       dmesg | tail or so.
> 
> BTRFS: device label media devid 2 transid 44804
> /dev/mapper/WDC_WD10EACS-00D6B0_WD-WCAU40229179p1
> BTRFS info (device dm-10): disk space caching is enabled
> BTRFS: failed to read the system array on dm-10
> BTRFS: open_ctree failed

I'd try in order:

mount -o degraded,ro
mount -o recovery,ro
mount -o degraded,recovery,ro

If any of those works, then update your backup before trying anything else. Whatever command above worked, try it without ro.

If a degrade option is needed then that makes me think a btrfs device delete missing won't work, but then I'm also not seeing a missing device in your btrfs fi show either. You definitely need to make sure the device producing the errors is the device that's missing and is the one you're removing.

Chris Murphy


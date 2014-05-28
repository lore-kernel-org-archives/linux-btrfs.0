Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62653 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaE1GTJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 02:19:09 -0400
Received: by mail-ie0-f180.google.com with SMTP id tp5so9843955ieb.39
        for <linux-btrfs@vger.kernel.org>; Tue, 27 May 2014 23:19:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 28 May 2014 01:19:09 -0500
Message-ID: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com>
Subject: Failed Disk RAID10 Problems
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a Btrfs RAID 10 (data and metadata) file system that I believe
suffered a disk failure. In my attempt to replace the disk, I think
that I've made the problem worse and need some help recovering it.

I happened to notice a lot of errors in the journal:

end_request: I/O error, dev dm-11, sector 1549378344
BTRFS: bdev /dev/mapper/Hitachi_HDS721010KLA330_GTA040PBG71HXF1 errs:
wr 759675, rd 539730, flush 23, corrupt 0, gen 0

The file system continued to work for some time, but eventually a NFS
client encountered IO errors. I figured that device was failing (It
was very old.). I attached a new drive to the hot-swappable SATA slot
on my computer, partitioned it with GPT, and ran partprobe to detect
it. Next I attempted to add a new device, which was successful.
However, something peculiar happened:

~: btrfs fi df /var/media/
Data, RAID10: total=2.33TiB, used=2.33TiB
Data, RAID6: total=72.00GiB, used=71.96GiB
System, RAID10: total=96.00MiB, used=272.00KiB
Metadata, RAID10: total=4.12GiB, used=2.60GiB

I don't know where that RAID6 file system came from, but it did not
exist over the weekend when I last checked. I attempted to run a
balance operation, but this is when the IO errors became severe, and I
cancelled it. Next, I tried to remove the failed device, thinking that
Btrfs could rebalance after that. Removing the failed device failed:

~: btrfs device delete /dev/dm-11 /var/media
ERROR: error removing the device '/dev/dm-11' - Device or resource busy

I shutdown the system and detached the failed disk. Upon reboot, I
cannot mount the filesystem:

~: mount /dev/mapper/SAMSUNG_HD103SI_499431FS734755p1 /var/media
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/SAMSUNG_HD103SI_499431FS734755p1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

BTRFS: device label media devid 2 transid 44804
/dev/mapper/WDC_WD10EACS-00D6B0_WD-WCAU40229179p1
BTRFS info (device dm-10): disk space caching is enabled
BTRFS: failed to read the system array on dm-10
BTRFS: open_ctree failed

I reattached the failed disk, and I'm still getting the same mount
error as above.

Here's where the array currently stands:

Label: 'media'  uuid: 7b7afc82-f77c-44c0-b315-669ebd82f0c5
Total devices 5 FS bytes used 2.39TiB
devid    1 size 931.51GiB used 919.41GiB path
/dev/mapper/SAMSUNG_HD103SI_499431FS734755p1
devid    2 size 931.51GiB used 919.41GiB path
/dev/mapper/WDC_WD10EACS-00D6B0_WD-WCAU40229179p1
devid    3 size 1.82TiB used 1.19TiB path
/dev/mapper/WDC_WD20EFRX-68AX9N0_WD-WMC1T1268493p1
devid    4 size 931.51GiB used 920.41GiB path
/dev/mapper/WDC_WD10EARS-00Y5B1_WD-WMAV50654875p1
devid    5 size 931.51GiB used 918.50GiB path
/dev/mapper/Hitachi_HDS721010KLA330_GTA040PBG71HXF1
devid    6 size 1.82TiB used 3.41GiB path
/dev/mapper/WDC_WD20EFRX-68AX9N0_WD-WMC300239240p1

Btrfs v3.12

Devid 6 is the drive that I added earlier.

What can I do to recover this file system? I have another spare drive
that I can use if it's any help.

Thanks,
Justin

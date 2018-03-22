Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.donaanacounty.org ([67.134.23.10]:60628 "EHLO
        mail.donaanacounty.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753917AbeCVAn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 20:43:29 -0400
Received: from pps.filterd (proofpointagent.donaanacounty.org [127.0.0.1])
        by ProofPointAgent.donaanacounty.org (8.16.0.21/8.16.0.21) with SMTP id w2M0CpGC019465
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 18:13:40 -0600
Received: from webmail.donaanacounty.org (gcmxbe02.dac.int [10.250.250.90])
        by ProofPointAgent.donaanacounty.org with ESMTP id 2gs18s9nay-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 18:13:40 -0600
From: Matthew Hawn <matthewh@donaanacounty.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: grub_probe/grub-mkimage does not find all drives in BTRFS RAID1
Date: Thu, 22 Mar 2018 00:13:38 +0000
Message-ID: <DF0C87D105B235419E2D9E5066CCCF51988BA347@gcmxbe02.dac.int>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is almost definitely a bug in GRUB, but I wanted to get the btrfs mailing list opinion first.

Symptoms:
I have a btrfs raid1 /boot and root filesystem.  Ever since I replaced a drive, when I run the grub utilities to create my grub.cfg and install to boot sector, it only recognizes one of the drives.

$ sudo grub-probe /boot/grub -t device
/dev/mapper/VG_BTRFS2-LV_BOOT2

$ sudo grub-probe /boot/grub -t bios_hints
lvmid/gEfhOx-J9hr-8tkA-OgjD-Aqqu-XR2T-sFB4me/oNnMDp-Rit5-P0qs-QZlf-bQQe-tZU7-Wwmz8z

This also prevents boot if the above drive is disconnected. Grub error in locating lvmid/gEfhOx-J9hr-8tkA-OgjD-Aqqu-XR2T-sFB4me/oNnMDp-Rit5-P0qs-QZlf-bQQe-tZU7-Wwmz8z

Boot works fine if both drives, or only the above drive is present.

Before drive replacement, the above commands returned both drives that were part of the RAID1 mirror.  I never tried booting with a device disconnected, but both showed up in my grub.cfg.   Replacement was not standard since the prior drive was developing bad sectors, but had not failed. Replacement was done by adding a third disk to the mirror, then removing the 1st disk.

Probable Cause:
To determine the boot drive, grub-probe and grub-mkimage make several ioctl  in osdep/linux/getroot.c: grub_find_root_devices_from_btrfs
A call to BTRFS_IOC_FS_INFO gets the max_id and num_devices.  It then iterates from 1 to max_id, calling BTRFS_IOC_DEV_INFO to get the path.  

For my system, max_id = 3 and num_devices = 2.  Requesting BTRFS_IOC_DEV_INFO for device 1 yields a "No Such Device".  Instead of continuing on to device 2 and 3 (which return without error), grub treats all ioctl errors as fatal, exits the btrfs specific code with a failure, then falls back to generic linux code that only detects the single drive. 

So, is this a grub bug? If so, any suggestions before I submit to the grub-bug list?  Also, as I wait until a fix is published (or I rebuild grub with my own patch), any ideas to workaround this?


Info:
Kernel:  4.15.0-12-generic #13-Ubuntu SMP (based on 4.15.7 mainline)
btrfs-progs: 4.15.1-1
Grub:  2.02~beta2-36ubuntu3.17 

$ btrfs fi show
Label: none  uuid: 84c8e78b-9d7f-4451-966d-3c25154e89b8
	Total devices 2 FS bytes used 22.16GiB
	devid    2 size 100.00GiB used 25.03GiB path /dev/mapper/VG_BTRFS2-LV_ROOT2
	devid    3 size 100.00GiB used 25.03GiB path /dev/mapper/VG_BTRFS3-LV_ROOT3


Label: none  uuid: 059ab98f-eb63-471d-b099-6561baf39040
	Total devices 2 FS bytes used 61.04GiB
	devid    2 size 200.00GiB used 62.03GiB path /dev/mapper/VG_BTRFS2-LV_HOME2
	devid    3 size 200.00GiB used 62.03GiB path /dev/mapper/VG_BTRFS3-LV_HOME3


Label: none  uuid: ffe8b1a0-030c-42c2-94f5-b7e8e54b1439
	Total devices 2 FS bytes used 342.04MiB
	devid    2 size 1.00GiB used 693.62MiB path /dev/mapper/VG_BTRFS2-LV_BOOT2
	devid    3 size 1.00GiB used 693.62MiB path /dev/mapper/VG_BTRFS3-LV_BOOT3
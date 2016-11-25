Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:51739 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbcKYLHB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 06:07:01 -0500
Received: from localhost (unknown [192.168.1.156])
        by mail.linuxsystems.it (Postfix) with ESMTPSA id 0D319A9B68
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 12:05:58 +0100 (CET)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: My system mounts the wrong btrfs partition, from the wrong disk!
Date: Fri, 25 Nov 2016 12:05:57 +0100
MIME-Version: 1.0
Message-ID: <a39949b5-abab-40a3-943e-818b6ca7106b@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is something pretty unbelievable, so I had to repeat it several times 
before finding the courage to actually post it to the mailing list :)

After dozens of data loss I don't trust my btrfs partition that much, so I 
make a backup copy with dd weekly. Yesterday I was going to do some 
balancing and deduplication, but since the disk was full I had to remove 
the content of a whole subvolume (16GB) to make some space available to the 
tools (I had the backup made with dd on an external drive).

After the balance and deduplication I attached and mounted the external 
drive with the backup and then I mounted the img file with the copy of the 
partition. To my great wonder the subvolume in the backup which should have 
had the files I deleted was empty! So I rebooted to a live usb and mounted 
the backup again: my files were still there, phew! Then I mounted the 
partition in the laptop's disk and I tried to copy the files from the 
backup and it complained that they already existed! If I unmount both the 
backup and the real disk and then I mount the real disk it's empty again as 
it should.

These are the exact steps to reproduce it from the live usb:

# Opening the encrypted partition from the real disk and then mounting it
cryptsetup luksOpen /dev/sda5 cryptroot
mount -o noatime,compress=lzo,autodefrag /dev/mapper/cryptroot /real_disk

ls /real_disk/@Pictures --> empty (as it should)

# Mounting the external disk with the backup
mount /dev/sdb1 /external_disk

# Mounting the unencrypted backup from the external disk
mount /external_disk/backup.img /backup

ls /backup/@Pictures ---> empty (*it shouldn't!*)

umount /backup
umount /external_disk
cryptsetup luksClose cryptroot

# Mounting the external disk with the backup
mount /dev/sdb1 /external_disk

# Mounting the unencrypted backup from the external disk
mount /external_disk/backup.img /backup

ls /backup/@Pictures ---> 16GB of photos (as it should)

# Opening the encrypted partition from the real disk and then mounting it
cryptsetup luksOpen /dev/sda5 cryptroot
mount -o noatime,compress=lzo,autodefrag /dev/mapper/cryptroot /real_disk

ls /real_disk/@Pictures --> 16GB of photos (it *shouldn't!*)


I really don't know where the bug may lie, probably not even in btrfs but I 
didn't know where to report it. I'm using Archlinux with kernel 4.8.10 and 
the live is an Arch live usb with kernel 4.8 too.

Niccolò Belli

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33244 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbcDRFWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 01:22:35 -0400
Received: by mail-yw0-f195.google.com with SMTP id o63so22333020ywe.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 22:22:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2016 13:22:34 +0800
Message-ID: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
Subject: Install to or Recover RAID Array Subvolume Root?
From: David Alcorn <nroclaed@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Debian's default installer (1) can not create a BTRFS raid array
during installation, and (2) installs to the default subvol of the
BTRFS target.  The default subvol is 5 (BTRFS root) unless (i) prior
to installation a BTRFS file-system was created, (ii) the default
subvol is set to something other than 5, and (iii) you do not format
the installation target during install. This perspective benefits from
https://aykevl.nl/2015/11/debian-btrfs-subvolume.

Can Debian install BTRFS to a pre-existing BTRFS RAID 6 array?  If the
array's default is set to ,say subvolid 257, can I install to array
subvolume 257?  The goal is to install to a subvolume on the array
without disturbing date on other array subvolumes.

I erred and shutdown my NAS during a balance.  Grub lost track of my
root.  Root was on RAID 6 array subvolid 257.  I can boot a different
root from a USB flash drive but neither update-grub not install-grub
sees my old root on array subvolid 257.  I am happy to either recover
or lose array subvolid 257 but do not want to lose data on other array
subvol's.  I prefer to have my root on the array rather than a flash
drive.  The balance completed successfully after I booted from the
flash drive.

I am running a debian back-ported 4.4.0 kernel with btrfs-progs v4.4
on both my flash drive and array subvolid 257.  Both installs are
UEFI.  df -h reports:

Filesystem      Size  Used Avail Use% Mounted on
udev             10M     0   10M   0% /dev
tmpfs           790M  8.6M  781M   2% /run
/dev/sdb3       3.8G  1.1G  2.4G  31% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/sdb1        93M  311K   93M   1% /boot/efi
/dev/sde         22T  4.9T   13T  29% /lit

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44427 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbaAUVbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 16:31:22 -0500
Received: by mail-vc0-f174.google.com with SMTP id im17so3809943vcb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 13:31:21 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 21 Jan 2014 22:31:21 +0100
Message-ID: <CAD_cGvFie41PxiJqa1tL04vZYNsfk8fCHrf4=znXO2Ds=sF8Vw@mail.gmail.com>
Subject: failed to read the system array on sdX
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I suddenly got issues accessing a samba share and rebooted the server.
After the reboot the btrfs mount does not come up and prints the
following messages in dmesg:

[  530.881802] btrfs: device fsid 9302fc8f-15c6-46e9-9217-951d7423927c
devid 4 transid 138602 /dev/sdt
[  530.882734] btrfs: disk space caching is enabled
[  530.883697] btrfs: failed to read the system array on sdt
[  530.898188] btrfs: open_ctree failed

Probably some kind of issue with btrfs was the reason for the samba
share failing.
--
- All seven 4TB drives is in one btrfs RAID10 with no lvm/mdadm

btrfs fi show
Label: none  uuid: 9302fc8f-15c6-46e9-9217-951d7423927c
        Total devices 7 FS bytes used 9.91TiB
        devid    2 size 3.64TiB used 3.07TiB path /dev/sdm
        devid    3 size 3.64TiB used 3.07TiB path /dev/sds
        devid    4 size 3.64TiB used 3.07TiB path /dev/sdt
        devid    5 size 3.64TiB used 3.07TiB path /dev/sdo
        devid    6 size 3.64TiB used 3.07TiB path /dev/sdp
        devid    7 size 3.64TiB used 3.07TiB path /dev/sdq
        devid    8 size 3.64TiB used 3.07TiB path /dev/sdr

Btrfs v3.12

/etc/fstab:
UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /btrfs
              btrfs   defaults,compress=lzo,noatime          0   2
UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /storage/storage-vol0
              btrfs   defaults,subvol=storage-vol0,noatime   0   2

uname -a
Linux merkur 3.12.6 #1 SMP Sat Dec 21 02:23:32 CET 2013 x86_64 GNU/Linux

Hardware:
Supermicro Xeon server with 16GB ECC RAM, LSI HBAs and WD SE 4TB drives.

Adding recovery to mount options:
# mount /btrfs/
mount: wrong fs type, bad option, bad superblock on /dev/sdt,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so


----

What is the correct steps forward to mount my array again?

Best regards,
Hans-Kristian

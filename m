Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:54672 "EHLO mout2.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbdJHAIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 7 Oct 2017 20:08:35 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
        by mout2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.89 #1)
        id 1e0z8z-0000KW-VA
        for linux-btrfs@vger.kernel.org; Sun, 08 Oct 2017 02:08:33 +0200
Received: from [::1] (port=55312 helo=mjail1.freenet.de)
        by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.89 #1)
        id 1e0z8z-0004Y8-Rf
        for linux-btrfs@vger.kernel.org; Sun, 08 Oct 2017 02:08:33 +0200
Received: from mx12.freenet.de ([195.4.92.22]:34256)
        by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.89 #1)
        id 1e0z72-0004E0-Pl
        for linux-btrfs@vger.kernel.org; Sun, 08 Oct 2017 02:06:32 +0200
Received: from ppp-46-244-210-162.dynamic.mnet-online.de ([46.244.210.162]:39934 helo=[192.168.1.200])
        by mx12.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (port 465) (Exim 4.89 #1)
        id 1e0z72-0007HZ-JM
        for linux-btrfs@vger.kernel.org; Sun, 08 Oct 2017 02:06:32 +0200
Subject: Re: How to get Super_num_devices in sync with num_devices again?!
From: g6094199@freenet.de
To: linux-btrfs@vger.kernel.org
References: <1bf24e337599ff54dc3d851ba3fbf913@email.freenet.de>
Message-ID: <8cae5d9b-db01-5154-1c92-86ede911db21@freenet.de>
Date: Sun, 8 Oct 2017 02:06:31 +0200
MIME-Version: 1.0
In-Reply-To: <1bf24e337599ff54dc3d851ba3fbf913@email.freenet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He Guys!

Again now in a readable from....

I have an Ubuntu 16.04 machine (K4.4 and K4.11, btrfs-progs v4.5.2) running / on btrfs raid1 and for some
month (after i had to replace a / disk) super_numdevices and num_devices are out of sync peventing me to boot
Kernels newer than around 4.7 (afaik), where the kernels began the be more restictive on checking valid btrfs
disks.


I tried to remove the raid and converted to single with several balances after that so that there are no raid
chunks left.
Label: 'System'  uuid: 35fdbfd4-5809-4a30-94c1-5e3ca206ca4d
     Total devices 1 FS bytes used 14.86GiB
     devid    6 size 50.00GiB used 17.31GiB path /dev/nvme0n1p1


Data, single: total=15.00GiB, used=13.84GiB
System, single: total=64.00MiB, used=16.00KiB
Metadata, single: total=2.25GiB, used=1.02GiB
GlobalReserve, single: total=336.00MiB, used=0.00B


/dev/nvme0n1p1, ID: 6
    Device size:            50.00GiB
    Data,single:            15.00GiB
    Metadata,single:         2.25GiB
    System,single:          64.00MiB
    Unallocated:            32.69GiB
Overall:
     Device size:          50.00GiB
     Device allocated:          17.31GiB
     Device unallocated:          32.69GiB
     Device missing:             0.00B
     Used:              14.86GiB
     Free (estimated):          33.85GiB    (min: 33.85GiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         336.00MiB    (used: 0.00B)

Data,single: Size:15.00GiB, Used:13.84GiB
    /dev/nvme0n1p1      15.00GiB

Metadata,single: Size:2.25GiB, Used:1.02GiB
    /dev/nvme0n1p1       2.25GiB

System,single: Size:64.00MiB, Used:16.00KiB
    /dev/nvme0n1p1      64.00MiB

Unallocated:
    /dev/nvme0n1p1      32.69GiB


But again newer kernels refuse to boot with tlling me: "BTRFS error.....: super_num_devices 2 missmatch
with num_devices 1 found here".
So the the two counters are alwasy off by one, dont matter what i try.


Question: how do i get thouse two counters in sync again so that my system acts again as expected?!


regards
Sash


Am 05.10.2017 um 13:38 schrieb g6094199@freenet.de:
> He Guys!I have an ubuntu 16.04 machine (K4.4 and K4.11, btrfs-progs v4.5.2) running / on btrfs raid1 and for somemonth (after i had to replace a / disk) super_numdevices and num_devices are out of sync peventing me to bootKernels newer than around 4.7 (ifaik), where the kernels began the be more restictive on checking valid btrfsdisks.I tried to remove the raid and converted to single with several balances after that so that there are no raidchunks left.Label: 'System'  uuid: 35fdbfd4-5809-4a30-94c1-5e3ca206ca4d    Total devices 1 FS bytes used 14.86GiB    devid    6 size 50.00GiB used 17.31GiB path /dev/nvme0n1p1Data, single: total=15.00GiB, used=13.84GiBSystem, single: total=64.00MiB, used=16.00KiBMetadata, single: total=2.25GiB, used=1.02GiBGlobalReserve, single: total=336.00MiB, used=0.00B/dev/nvme0n1p1, ID: 6   Device size:            50.00GiB   Data,single:            15.00GiB   Metadata,single:         2.25GiB   System,single:          6400MiB   Unallocated:            32.69GiBOverall:    Device size:          50.00GiB    Device allocated:          17.31GiB    Device unallocated:          32.69GiB    Device missing:             0.00B    Used:              1486GiB    Free (estimated):          33.85GiB    (min: 33.85GiB)    Data ratio:                  1.00    Metadata ratio:              1.00    Global reserve:         336.00MiB    (used: 0.00B)Data,single: Size:15.00GiB, Used:13.84GiB   /dev/nvme0n1p1      15.00GiBMetadata,single: Size:2.25GiB, Used:1.02GiB   /dev/nvme0n1p1       2.25GiBSystem,single: Size:64.00MiB, Used:1600KiB   /dev/nvme0n1p1      64.00MiBUnallocated:   /dev/nvme0n1p1      32.69GiBBut again newer kernels refuse to boot with tlling me: "BTRFS error....: super_num_devices 2 missmatchwith num_devices 1 found here".So the the two counters are alwasy off by one, dont matter what i try.Question: how do i get thouse two counters in sync again so that my system acts again as expected?!regardsSash




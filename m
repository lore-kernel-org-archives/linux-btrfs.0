Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44482 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeH3Vrs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:47:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id q127-v6so7953458ljq.11
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:44:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT9CREHP=bkeMMEBS46mT=ra8GqGuVbUXKrxm=PmScbgA@mail.gmail.com>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com> <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com> <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <VI1PR08MB08629058D1231A1E374A8C4292080@VI1PR08MB0862.eurprd08.prod.outlook.com>
 <CAJCQCtT9CREHP=bkeMMEBS46mT=ra8GqGuVbUXKrxm=PmScbgA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 30 Aug 2018 11:44:30 -0600
Message-ID: <CAJCQCtRz6e0jmz5SbR9fx3dq=ZFnaJ2uVZBovxQx6DGb070AAg@mail.gmail.com>
Subject: Re: How to erase a RAID1 (+++)?
To: Chris Murphy <lists@colorremedies.com>
Cc: Alberto Bursi <alberto.bursi@outlook.it>,
        Pierre Couderc <pierre@couderc.eu>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And also, I'll argue this might have been a btrfs-progs bug as well,
depending on what version was used and the command. Both mkfs and dev
add should not be able to add type code 0x05. At least libblkid
correctly shows that it's 1KiB in size, so really Btrfs should not
succeed at adding this device, it can't put any of the supers in the
correct location.

[chris@f28h ~]$ sudo fdisk -l /dev/loop0
Disk /dev/loop0: 1 GiB, 1073741824 bytes, 2097152 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7e255cce

Device       Boot  Start    End Sectors  Size Id Type
/dev/loop0p1        2048 206847  204800  100M 83 Linux
/dev/loop0p2      206848 411647  204800  100M 83 Linux
/dev/loop0p3      411648 616447  204800  100M 83 Linux
/dev/loop0p4      616448 821247  204800  100M  5 Extended
/dev/loop0p5      618496 821247  202752   99M 83 Linux

[chris@f28h ~]$ sudo kpartx -a /dev/loop0
[chris@f28h ~]$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0         7:0    0     1G  0 loop
├─loop0p1   253:1    0   100M  0 part
├─loop0p2   253:2    0   100M  0 part
├─loop0p3   253:3    0   100M  0 part
├─loop0p4   253:4    0     1K  0 part
└─loop0p5   253:5    0    99M  0 part

[chris@f28h ~]$ sudo mkfs.btrfs /dev/loop0p4
btrfs-progs v4.17.1
See http://btrfs.wiki.kernel.org for more information.

probe of /dev/loop0p4 failed, cannot detect existing filesystem.
ERROR: use the -f option to force overwrite of /dev/loop0p4
[chris@f28h ~]$ sudo mkfs.btrfs /dev/loop0p4 -f
btrfs-progs v4.17.1
See http://btrfs.wiki.kernel.org for more information.

ERROR: mount check: cannot open /dev/loop0p4: No such file or directory
ERROR: cannot check mount status of /dev/loop0p4: No such file or directory
[chris@f28h ~]$


I guess that's a good sign in this case?


Chris Murphy

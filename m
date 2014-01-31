Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52813 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaAaG3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 01:29:05 -0500
Received: by mail-qa0-f48.google.com with SMTP id f11so5786251qae.35
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 22:29:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABgvyo822bOAHeA1GH28MPaBAU+Zdi72MD_uwL+dhopt+nwMig@mail.gmail.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <CABgvyo822bOAHeA1GH28MPaBAU+Zdi72MD_uwL+dhopt+nwMig@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Fri, 31 Jan 2014 07:28:24 +0100
Message-ID: <CABgvyo_ZetAgEcvA7OJSDJS9BXXTG+c-0wXcXSua=uxfGk=Eow@mail.gmail.com>
Subject: Fwd: lost with degraded RAID1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-30 Chris Murphy <lists@colorremedies.com>:
>> Now the damaged disk disappeared completely. No sign of it in /proc/diskstats.
>
> I don't know what you mean by it's disappeared complete. Are you talking about the physical block device? Or the dm logical block device?
It failed and doesn't appear anywhere. I don't have physical access to
the server at the moment.
> What do you get for:
> lsblk
> blkid
> btrfs device scan --all-devices
> btrfs fi show
root@fortknox:/# lsblk
NAME               MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                  8:0    0 232,9G  0 disk
└─sda1               8:1    0 232,9G  0 part  /
sdb                  8:16   0   1,8T  0 disk
└─sdb1               8:17   0   1,8T  0 part
  └─bunkerA (dm-0) 253:0    0   1,8T  0 crypt
sdc                  8:32   0   2,7T  0 disk
└─sdc1               8:33   0   2,7T  0 part  /USBPLATTE
loop1                7:1    0   500G  0 loop
root@fortknox:/# blkid
/dev/sda1: UUID="d055ffe7-80ed-455e-8117-4a2c8bef3ed5" TYPE="ext4"
/dev/sdc1: UUID="812c784b-df5a-48a6-98ff-5b755e29b563" TYPE="ext4"
/dev/sdb1: UUID="947206e2-488e-4dc4-b243-912901512ed4" TYPE="crypto_LUKS"
/dev/mapper/bunkerA: LABEL="bunker"
UUID="7f954a85-7566-4251-832c-44f2d3de2211"
UUID_SUB="6c66c3c1-df8f-4b29-9acb-bd923a69b3ee" TYPE="btrfs"
root@fortknox:/# btrfs device scan --all-devices
Scanning for Btrfs filesystems
root@fortknox:/# btrfs fi show
Label: 'bunker'  uuid: 7f954a85-7566-4251-832c-44f2d3de2211
        Total devices 2 FS bytes used 1.58TiB
        devid    2 size 1.82TiB used 1.59TiB path /dev/mapper/bunkerA
        *** Some devices missing

Btrfs v3.12

>> But now, I can't mount bunkerA degraded,RW because degraded
>> filesystems are not allowed to be mounted RW (?)
>
> Have you tried? What errors do you get in user space and dmesg?
root@fortknox:/# umount /mnt
umount: /mnt: not mounted
root@fortknox:/# mount -odegraded,rw /dev/mapper/bunkerA /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/bunkerA,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@fortknox:/# dmesg|tail
[756751.574065] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[756751.837133] Btrfs: too many missing devices, writeable mount is not allowed
[756751.865278] btrfs: open_ctree failed
[781332.902000] btrfs: device label bunker devid 2 transid 121487 /dev/dm-0
[781630.561889] btrfs: device label bunker devid 2 transid 121487
/dev/mapper/bunkerA
[781630.564673] btrfs: allowing degraded mounts
[781630.564684] btrfs: disk space caching is enabled
[781630.598155] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[781630.816989] Btrfs: too many missing devices, writeable mount is not allowed
[781630.842901] btrfs: open_ctree failed

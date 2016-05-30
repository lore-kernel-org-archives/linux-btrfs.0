Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33706 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbcE3CDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 22:03:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id m198so23139345oig.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS3hG8nQ39bAnKpSz-9kBhiPY6wFM2t3g5Ek-RNnx1DFA@mail.gmail.com>
References: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
	<CAJCQCtS3hG8nQ39bAnKpSz-9kBhiPY6wFM2t3g5Ek-RNnx1DFA@mail.gmail.com>
Date: Sun, 29 May 2016 20:03:15 -0600
Message-ID: <CAJCQCtR4rcADvAGy_Wv4afaHRJJLV3M_1jQhBT5Ky6e=4TSsNQ@mail.gmail.com>
Subject: Re: [regression] make sure seed is writeable sprout after device add
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With 4.5.5 the 'mount -o remount,rw' works like the wiki describes,
and is in my opinion contrary to the mount man page.

After the -o remount,rw following btrfs dev add VG/sprout, I get this partial:

# lsblk -o +UUID
NAME                      MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT UUID
│ └─VG-thintastic_tdata   253:1    0    90G  0 lvm
│   └─VG-thintastic-tpool 253:2    0    90G  0 lvm
│     ├─VG-thintastic     253:3    0    90G  0 lvm
│     ├─VG-seed           253:5    0    50G  0 lvm   /mnt/0
59828c01-8354-43ac-a92d-f22d1b5d0e22
│     └─VG-sprout         253:6    0    50G  0 lvm
e8de3a52-34d1-46af-98c1-8620642be884

And

# mount
[...trimmed...]
/dev/mapper/VG-seed on /mnt/0 type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)

This is just wrong. The wrong volume UUID is associated with /mnt/0 by
lsblk. And mount shows VG/seed as rw, which is not possible because by
definition the seed is read-only.

I've always thought this was misleading and confusing.

Next I tried it with kernel-4.6.0...

[root@f24m ~]# losetup
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE    DIO
/dev/loop0         0      0         0  0 /root/seed     0
/dev/loop1         0      0         0  0 /root/sprout   0

# mount
[...trimmed...]
/dev/loop0 on /mnt/0 type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)

So it's the same incorrect information as 4.5.5.

# lsblk -o +UUID
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT UUID
loop0    7:0    0    10G  0 loop /mnt/0     63288b0c-9216-4f11-aed4-cc054ae90e07
loop1    7:1    0    10G  0 loop            63288b0c-9216-4f11-aed4-cc054ae90e07

This is worse.

# btrfs fi show
Label: none  uuid: 63288b0c-9216-4f11-aed4-cc054ae90e07
    Total devices 2 FS bytes used 384.00KiB
    devid    1 size 10.00GiB used 2.02GiB path /dev/loop0
    devid    2 size 10.00GiB used 0.00B path /dev/loop1

So is this. Where is the new UUID for the newly created sprout volume?

/dev/loop0: UUID="63288b0c-9216-4f11-aed4-cc054ae90e07"
UUID_SUB="e379aedb-6d14-4d56-be7d-1772c9984bc5" TYPE="btrfs"
/dev/loop1: UUID="63288b0c-9216-4f11-aed4-cc054ae90e07"
UUID_SUB="b282f566-8382-468e-b9ec-f748244b703b" TYPE="btrfs"

Uhh? Identical UUIDs for seed and sproud? That's not right.

Same version of btrfs-progs in both cases, just different kernels, BUT
on different machines, and hence why LVM in the first case, and
fallocated files on loop for the second. I'm not sure what's causing
this.



----
Chris Murphy

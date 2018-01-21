Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:44750 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeAUPx5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 10:53:57 -0500
Received: by mail-wr0-f171.google.com with SMTP id w50so5925271wrc.11
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 07:53:56 -0800 (PST)
Received: from [192.168.2.108] (msk.klfree.cz. [81.201.50.219])
        by smtp.gmail.com with ESMTPSA id z39sm10219979wrz.20.2018.01.21.07.53.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jan 2018 07:53:55 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: msk conf <msk.conf@gmail.com>
Subject: Can't mount (even in ro) after power outage - corrupt leaf,
 open_ctree failed
Message-ID: <7ebd40d4-3eea-9ad7-492f-b5d22cf935b0@gmail.com>
Date: Sun, 21 Jan 2018 16:53:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

I would like to ask you for help with (corrupted) btrfs on my nas.

After power outage I can't mount it back at all:
UUID="e8cb7e76-7f93-4eac-aec7-ca64395d2110"    /array  btrfs 
noatime,compress=lzo    0       2
UUID="e8cb7e76-7f93-4eac-aec7-ca64395d2110"    /home   btrfs 
noatime,compress=lzo,subvolid=3315      0       0

I tried combination of recovery,ro,degraded,usebackuproot, specifying 
partial partitions where fs is placed to - no success at all.
for example
mount -ousebackuproot,ro 
/dev/disk/by-uuid/e8cb7e76-7f93-4eac-aec7-ca64395d2110 /mnt/restore
mount -ousebackuproot,ro,degraded /dev/sdb4 /mnt/restore
...

Failing with:
[ 2765.719548] BTRFS critical (device sda4): corrupt leaf, slot offset 
bad: block=3997250650112, root=1, slot=48
[ 2765.731772] BTRFS error (device sda4): failed to read block groups: -5
[ 2765.781993] BTRFS error (device sda4): open_ctree failed

Some informations at beginning:

uname -a
Linux nas 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3 (2017-12-03) x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.7.3

btrfs fi show
Label: none  uuid: 4a20b115-4742-42f1-9e1a-225323faa31a
         Total devices 1 FS bytes used 8.32GiB
         devid    1 size 11.17GiB used 11.02GiB path /dev/md0

Label: none  uuid: e8cb7e76-7f93-4eac-aec7-ca64395d2110
         Total devices 2 FS bytes used 1.86TiB
         devid    2 size 3.62TiB used 1.86TiB path /dev/sdb4
         devid    4 size 3.62TiB used 1.86TiB path /dev/sda4

sda4+sdb4 is btrfs-raid1 filesystem which is currently failing to mount.

btrfs check /dev/sda4

incorrect offsets 13686 13622
checking extents
incorrect offsets 13686 13622
bad block 3996803399680
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154150576128-3154158186496 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154158247936-3154158645248 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154158657536-3154160283648 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154160676864-3154160701440 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154160951296-3154162651136 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154162782208-3154162786304 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154163032064-3154164342784 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154164428800-3154165215232 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154165477376-3154165501952 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3154165764096-3154799960064 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3160185249792-3161232998400 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3176324980736-3176425730048 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3176426110976-3176831508480 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 3176831909888-3177245937664 but there is no extent record
incorrect offsets 13715 13651
Error looking up extent record -1
Csum exists for 4098653097984-4098792165376 but there is no extent record
incorrect offsets 13715 13651
Error looking up extent record -1
Csum exists for 4098792427520-4098934644736 but there is no extent record
incorrect offsets 13715 13651
Error looking up extent record -1
Csum exists for 4116888281088-4116889329664 but there is no extent record
incorrect offsets 13715 13651
Error looking up extent record -1
Csum exists for 4116889731072-4116952510464 but there is no extent record
incorrect offsets 13686 13622
Error looking up extent record -1
Csum exists for 4167480627200-4168429125632 but there is no extent record
Checking filesystem on /dev/sda4
UUID: e8cb7e76-7f93-4eac-aec7-ca64395d2110
found 1935048380418 bytes used err is 19
total csum bytes: 0
total tree bytes: 285835264
total fs tree bytes: 0
total extent tree bytes: 284655616
btree space waste bytes: 61859235
file data blocks allocated: 495452160
  referenced 495452160

What I didn't tried yet is recovery (have not another drive to place 
data to) and --repair (I am scared to do so).

Am i lost and must buy another drive and try restore or is there way how 
to fix that?
Any help is appreciated.

Thank you.

--
msk


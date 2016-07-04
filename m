Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37544 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGDTL2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 15:11:28 -0400
Received: by mail-wm0-f52.google.com with SMTP id a66so126242558wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 12:11:28 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
Date: Mon, 4 Jul 2016 21:11:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Result from dmesg:
http://sebsauvage.net/paste/?4e8e95b5eafbf675#ybToBzZ/WAoRjjugeH6N2YXZKEBlswaNI/J41GBmFYU=

sudo btrfs dev scan
Scanning for Btrfs filesystems

sudo btrfs fi show
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
Label: none  uuid: 2dab74bb-fc73-4c47-a413-a55840f6f71e
        Total devices 3 FS bytes used 3.80TiB
        devid    1 size 3.64TiB used 1.92TiB path /dev/sdb
        devid    2 size 3.64TiB used 1.92TiB path /dev/sda
        *** Some devices missing

sudo blkid
/dev/sda: UUID="2dab74bb-fc73-4c47-a413-a55840f6f71e"
UUID_SUB="7262d027-202a-4b29-aaf8-0bb8cf107d4d" TYPE="btrfs"
/dev/sdb: UUID="2dab74bb-fc73-4c47-a413-a55840f6f71e"
UUID_SUB="afa4cff8-d037-472e-9eb1-070d331b6a20" TYPE="btrfs"
/dev/sdc1: UUID="6731963f-5bf9-458c-a44d-6f0bbea38357" TYPE="ext2"
PARTUUID="ccb00f7e-01"
/dev/sdc5: UUID="522XeT-jWNr-O0oG-HeHV-akQu-AR3P-fzeUAy"
TYPE="LVM2_member" PARTUUID="ccb00f7e-05"
/dev/sdd1: LABEL="Verbatim HDD" UUID="70947DE1947DAA6C" TYPE="ntfs"
PARTUUID="58334162-01"
/dev/mapper/uncik--srv--vg-root:
UUID="15b50e38-d4cc-454c-ba0f-80adbb4cd4e1" TYPE="ext4"
/dev/mapper/uncik--srv--vg-swap_1:
UUID="c9db5981-acc3-43bb-a209-a213b80cc9cb" TYPE="swap"

sudo btrfs check /dev/sda
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
Couldn't open file system
 
Thank you
Tomas


------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Monday, July 04, 2016 9:01PM
 *To:* Tomáš Hrdina, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

On Mon, Jul 4, 2016 at 12:54 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> Degraded gives same result:
> 
> sudo mount -t btrfs -o ro,degraded /dev/sda /shares
> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 

That's bad. What are the kernel messages for the mount attempt?

Do the following and report back all the results.

# btrfs dev scan
# btrfs fi show
# blkid
# btrfs check /dev/sda


Also, make sure you reply to the btrfs list also and not just to me
personally. And also don't top post or it'll annoy some people on the
list.




---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus


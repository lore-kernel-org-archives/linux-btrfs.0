Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:48992 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaLIW3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 17:29:21 -0500
Received: by mail-yk0-f179.google.com with SMTP id 19so696483ykq.24
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Dec 2014 14:29:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
Date: Tue, 9 Dec 2014 23:29:20 +0100
Message-ID: <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 November 2014 at 13:35, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
> On 24 November 2014 at 05:23, Duncan <1i5t5.duncan@cox.net> wrote:
>> Patrik Lundquist posted on Sun, 23 Nov 2014 16:12:54 +0100 as excerpted:
>>
>>> The balance run now finishes without errors with usage=99 and I think
>>> I'll leave it at that. No RAID yet but will convert to RAID1.
>>
>> Converting between raid modes is done with a balance, so if you can't get
>> that last bit to balance, you can't do a full conversion to raid1.
>
> Good point! It slipped my mind. I'll report back if incremental
> balances eventually solves the balance after conversion ENOSPC
> problem.

I'm having no luck with a full balance of the converted filesystem.
Tried it again with Linux v3.18.0 and btrfs-progs v3.17.3.

What conclusions can be drawn from the following?

BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
BTRFS: space_info 1 has 4773171200 free, is not full
BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
reserved=99700736, may_use=2102390784, readonly=241664
BTRFS: block group 234109272064 has 5368709120 bytes, 5368709120 used
0 pinned 0 reserved
BTRFS info (device sdc1): block group has cluster?: no
BTRFS info (device sdc1): 0 blocks of free space at or bigger than bytes is
BTRFS: block group 242699206656 has 5368709120 bytes, 5368709120 used
0 pinned 0 reserved
BTRFS info (device sdc1): block group has cluster?: no
BTRFS info (device sdc1): 0 blocks of free space at or bigger than bytes is
BTRFS: block group 339335970816 has 5368709120 bytes, 5368705024 used
0 pinned 0 reserved
BTRFS critical (device sdc1): entry offset 344704675840, bytes 4096, bitmap no


Label: none  uuid: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
    Total devices 1 FS bytes used 1.35TiB
    devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1


Data, single: total=1.35TiB, used=1.35TiB
System, single: total=32.00MiB, used=112.00KiB
Metadata, single: total=3.00GiB, used=1.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Checking filesystem on /dev/sdc1
UUID: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
found 825003219475 bytes used err is 0
total csum bytes: 1452612464
total tree bytes: 1669943296
total fs tree bytes: 39600128
total extent tree bytes: 52903936
btree space waste bytes: 79921034
file data blocks allocated: 1487627730944
 referenced 1487627730944

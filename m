Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34555 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaLJHTu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 02:19:50 -0500
Received: by mail-yh0-f51.google.com with SMTP id a41so1034314yho.10
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Dec 2014 23:19:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54878210.8030807@pobox.com>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
Date: Wed, 10 Dec 2014 08:19:49 +0100
Message-ID: <CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 December 2014 at 00:13, Robert White <rwhite@pobox.com> wrote:
> On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
>>
>> Label: none  uuid: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
>>      Total devices 1 FS bytes used 1.35TiB
>>      devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1
>>
>>
>> Data, single: total=1.35TiB, used=1.35TiB
>> System, single: total=32.00MiB, used=112.00KiB
>> Metadata, single: total=3.00GiB, used=1.55GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Are you trying to convert a filesystem on a single device/partition to RAID
> 1?

Not yet. I'm stuck at the full balance after the conversion from ext4.
I haven't added the disks for RAID1 and might need them for starting
over instead.

A balance with -musage=100 -dusage=99 works but a full fails. It would
be nice to nail the bug since the fs passes btrfs check and it seems
to be a clear ENOSPC bug.


I don't know how to interpret the space_info error. Why is only
4773171200 (4,4GiB) free?
Can I inspect block group 1821099687936 to try to find out what makes
it problematic?

BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
BTRFS: space_info 1 has 4773171200 free, is not full
BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
reserved=99700736, may_use=2102390784, readonly=241664


> P.S. you should re-balance your System and Metadata as "DUP" for now. Two
> copies of that stuff is better than one as right now you have no real
> recovery path for that stuff. If you didn't make that change on purpose it
> probably got down-revved from DUP automagically when you tired to RAID it.

Good point. Maybe btrfs-convert should do that by default? I don't
think it has ever been DUP.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1167.vcdns.de ([88.80.200.92]:51424 "EHLO delorus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab3FHWmF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Jun 2013 18:42:05 -0400
Message-ID: <51B3B339.4030108@delorus.de>
Date: Sun, 09 Jun 2013 00:42:01 +0200
From: =?ISO-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Moved partition via dd
References: <51B327C4.3000304@delorus.de> <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com>
In-Reply-To: <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 09.06.2013 00:20, schrieb Chris Murphy:
>
> On Jun 8, 2013, at 8:47 AM, André Schlichting <andre@delorus.de> wrote:
>
>>
>> The old partition had the sector boundaries: 245547520 - 732566527
>>
>> I deleted this one and created a new one with boundaries: 33024 - 732566640
>>
>> Now I moved the data
>>   > sudo dd conv=notrunc bs=4096 iflag=fullblock if=/dev/sdc2 skip=$((245547520-33024)) seek=0 of=/dev/sdc2
>
> You ultimately moved the wrong data because bs=4096 for dd, yet the partition logical sectors are based on 512 bytes.
>
>
> Chris Murphy
>

I'm not sure, but this external disk has a GPT with sector size 4096 and 
as I wrote the dm-crypted LUKS container can be opened without complains.
 > fdisk -l /dev/sdc
WARNING: fdisk GPT support is currently new, and therefore in an 
experimental phase. Use at your own discretion.

Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes, 732566646 sectors
Units = Sektoren of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: gpt
#         Start          End    Size  Type            Name
  1            6        32773    128M  Microsoft reserved partition
  2        33024    732566640    2,7T  Linux filesystem

André Schlichting

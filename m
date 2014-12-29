Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout1.ltindia.com ([203.199.60.132]:37314 "EHLO
	mailout1.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaL2HPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 02:15:30 -0500
From: Ankur Tank <Ankur.Tank@LntTechservices.com>
To: Anand Jain <Anand.Jain@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs doesn't format eMMC if previous filesystem is ext4
Date: Mon, 29 Dec 2014 07:15:11 +0000
Message-ID: <CFB3B8F56DDE9F45B45EBDEBED372A664423AB@POCITMSEXMB05.LntUniverse.com>
References: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com>
 <54A0C17C.7010009@oracle.com>
In-Reply-To: <54A0C17C.7010009@oracle.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

Precondition : Previous filesystem on eMMC  was --- ext4----
Use case : Now format eMMC to btrfs format, using ---mkfs.btrfs---
mkfs.btrfs denies formatting eMMC telling that eMMC contain an existing filesystem(ext4).

In my opinion mkfs.btrfs must allow to format eMMC with btrfs even if there is other filesystem on it.

mkfs.ext4 and mkfs.f2fs does allow formatting even if eMMC contains some other file system on it.

Note: If I add "-f" option mkfs.btrf does allow formatting eMMC to btrfs filesytem.

Regards,
Ankur
-----Original Message-----
From: Anand Jain [mailto:Anand.Jain@oracle.com]
Sent: Monday, December 29, 2014 8:21 AM
To: Ankur Tank; linux-btrfs@vger.kernel.org
Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4



On 12/26/2014 11:24 PM, Ankur Tank wrote:
> Hi,
>
> I wanted to test btrfs on the eMMC of beaglebone black based custom board.
> Precondition: eMMC is formatted with ext4 filesystem Use case:
>          Format eMMC with mkfs.btrfs  -L  <label>  <dev>
> Result:
>          Mkfs.btrfs denies formatting eMMC because its existing
> filesystem
>
> # mkfs.btrfs -L "1storage" /dev/mmcblk0p2
> /dev/mmcblk0p2 appears to contain an existing filesystem (ext4).
> Error: Use the -f option to force overwrite.
>
> If I add "-f" its possible to format the eMMC.
>
> # mkfs.btrfs -f -L "1storage" /dev/mmcblk0p2 Detected a SSD, turning
> off metadata duplication.  Mkfs with -m dup if you want to force metadata duplication.
> Btrfs v3.17
> See http://btrfs.wiki.kernel.org for more information.
>
> Performing full device TRIM (1.72GiB) ...
> Turning ON incompat feature 'extref': increased hardlink limit per
> file to 65536 [273917.692896] btrfs: device label 1storage devid 1
> transid 3 /dev/mmcblk0p2 fs created label 1storage on /dev/mmcblk0p2
>          nodesize 16384 leafsize 16384 sectorsize 4096 size 1.72GiB
>
> I had downloaded debian package from following link
> https://packages.debian.org/sid/armhf/btrfs-tools/download
>
> Is it a bug ? or I am missing something ?

  I don't see any bug. Can you be more specific ? Thanks.

> Thank you,
>
> Regards,
> Ankur
> L&T Technology Services Ltd
>
> www.LntTechservices.com<http://www.lnttechservices.com/>
>
> This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
>
L&T Technology Services Ltd

www.LntTechservices.com<http://www.lnttechservices.com/>

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

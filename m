Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61747 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932519AbcLSSoX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 13:44:23 -0500
MIME-Version: 1.0
Message-ID: <trinity-65b0bf95-1288-4044-9bd4-c47299bb96c4-1482173054794@3capp-mailcom-bs02>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: =?UTF-8?Q?=22Jari_Sepp=C3=A4l=C3=A4=22?=
        <lihamakaroonilaatikko@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help please: BTRFS fs crashed due to bad removal of USB drive,
 no help from recovery procedures
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Dec 2016 19:44:14 +0100
In-Reply-To: <5A6A5345-FD05-402C-A003-7C742007F94D@gmail.com>
References: <66A9C2C6-028F-466B-9EFF-F06BF3FB4694@gmail.com>
 <trinity-2653fb5f-aa88-4ece-bced-51dee466d428-1482006464623@3capp-mailcom-bs11>,
 <5A6A5345-FD05-402C-A003-7C742007F94D@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jari,

The message shows:
> [ 135.446260] BTRFS error (device sdb1): superblock contains fatal errors
 
So according this info, before trying to run repair / rescue procedure, would you like to show the 0,1,2 superblock status?

Regards,
Xin
 
 

Sent: Monday, December 19, 2016 at 2:32 AM
From: "Jari Seppälä" <lihamakaroonilaatikko@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: "Xin Zhou" <xin.zhou@gmx.com>
Subject: Re: Help please: BTRFS fs crashed due to bad removal of USB drive, no help from recovery procedures
Xin Zhou <xin.zhou@gmx.com> kirjoitti 17.12.2016 kello 22.27:
>
> Hi Jari,
>
> Similar with other file system, btrfs has copies of super blocks.
> Try to run "man btrfs check", "man btrfs rescue" and related commands for more details.
> Regards,
> Xin

Hi Xin,

I did follow all recovery procedures from man and wiki pages. Tools do not help as they thing there is no BTRFS fs anymore. However if I try to reformat the device I get:

btrfs-progs v4.4
See http://btrfs.wiki.kernel.org for more information.
/dev/sdb1 appears to contain an existing filesystem (btrfs).

So, recovery tools seem to thing there is no btrfs filesystem. Mkfs seems to thing there is.

What I have tried:
btrfsck /dev/sdb1
mount -t btrfs -o ro /dev/sdb1 /mnt/share/
mount -t btrfs -o ro,recovery /dev/sdb1 /mnt/share/
mount -t btrfs -o roootflags=recovery,nospace_cache /dev/sdb1 /mnt/share/
mount -t btrfs -o rootflags=recovery,nospace_cache /dev/sdb1 /mnt/share/
mount -t btrfs -o rootflags=recovery,nospace_cache,clear_cache /dev/sdb1 /mnt/share/
mount -t btrfs -o ro,rootflags=recovery,nospace_cache,clear_cache /dev/sdb1 /mnt/share/
btrfs restore /dev/sdb1 /target/device
btrfs rescue zero-log /dev/sdb1
btrfsck --init-csum-tree /dev/sdb1
btrfsck --fix-crc /dev/sdb1
btrfsck --check-data-csum /dev/sdb1
btrfs rescue chunk-recover /dev/sdb1
btrfs rescue super-recover /dev/sdb1
btrfs rescue zero-log /dev/sdb1

No help whatsoever.

Jari

>
>
>
> Sent: Saturday, December 17, 2016 at 2:06 AM
> From: "Jari Seppälä" <lihamakaroonilaatikko@gmail.com>
> To: linux-btrfs@vger.kernel.org
> Subject: Help please: BTRFS fs crashed due to bad removal of USB drive, no help from recovery procedures
> Syslog tells:
> [ 135.446222] BTRFS error (device sdb1): system chunk array too small 0 < 97
> [ 135.446260] BTRFS error (device sdb1): superblock contains fatal errors
> [ 135.462544] BTRFS error (device sdb1): open_ctree failed
>
> What have been done:
> * All "btrfs rescue" options
>
> Info on system
> * fs on external SSD via USB
> * kernel 4.9.0 (tried with 4.8.13)
> * btrfs-tools 4.4
> * Mythbuntu (Ubuntu) 16.04.1 LTS with latest fixes 2012-12-16
>
> Any help appreciated. Around 300G of TV recordings on the drive, which of course will eventually come as replays.
>
> Jari
> --
> *** Jari Seppälä
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]

--
*** Jari Seppälä
 

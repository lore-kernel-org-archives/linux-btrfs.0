Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35192 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbbFJF2t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 01:28:49 -0400
Received: by igbzc4 with SMTP id zc4so27692974igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 22:28:49 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Jun 2015 02:28:49 -0300
Message-ID: <CAEko1BnVkHrZPR9O1-CX_DwuN0ZEfrzTHFQsr3XJxt85BpG5qQ@mail.gmail.com>
Subject: raid 1 to 10 conversion
From: =?UTF-8?Q?Guilherme_Gon=C3=A7alves?= <agamennon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!, i think i made a mistake
i had two 3tb drivre on a raid 1 setup, i bought two aditional 3tb
drives to make my raid 10 array
i used this commands

btrfs -f device add /dev/sdc /mnt/nas/    (i used -f because i
formatted my new drives using gpt)
btrfs -f device add /dev/sdf /mnt/nas/

finally:
btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt/nas/

after a couple of hours i ran:

btrfs filesystem  df /mnt/nas/

Data, RAID1: total=963.00GiB, used=962.69GiB
System, RAID1: total=32.00MiB, used=176.00KiB
Metadata, RAID1: total=6.00GiB, used=4.59GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

should that not read raid 10 ?

output for btrfs fi usage /mnt/nas

Overall:
    Device size:  10.92TiB
    Device allocated:   1.89TiB
    Device unallocated:   9.02TiB
    Device missing:     0.00B
    Used:   1.89TiB
    Free (estimated):   4.51TiB (min: 4.51TiB)
    Data ratio:      2.00
    Metadata ratio:      2.00
    Global reserve: 512.00MiB (used: 0.00B)

Data,RAID1: Size:963.00GiB, Used:962.69GiB
   /dev/sdc 481.00GiB
   /dev/sdd1 482.00GiB
   /dev/sde1 482.00GiB
   /dev/sdf 481.00GiB

Metadata,RAID1: Size:6.00GiB, Used:4.59GiB
   /dev/sdc   4.00GiB
   /dev/sdd1   2.00GiB
   /dev/sde1   2.00GiB
   /dev/sdf   4.00GiB

System,RAID1: Size:32.00MiB, Used:176.00KiB
   /dev/sdd1  32.00MiB
   /dev/sde1  32.00MiB

Unallocated:
   /dev/sdc   2.25TiB
   /dev/sdd1   2.26TiB
   /dev/sde1   2.26TiB
   /dev/sdf   2.25TiB


I think i made a mess here...  why is system only on two drives? why
is it not showing raid 10?
If i actually failed how do i acheive this? i want all four drives in
a raid 10 setup.

Thanks in advance

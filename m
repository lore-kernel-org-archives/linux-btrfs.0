Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38822 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbbFJFbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 01:31:48 -0400
Received: by wibdq8 with SMTP id dq8so35187772wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 22:31:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEko1BnVkHrZPR9O1-CX_DwuN0ZEfrzTHFQsr3XJxt85BpG5qQ@mail.gmail.com>
References: <CAEko1BnVkHrZPR9O1-CX_DwuN0ZEfrzTHFQsr3XJxt85BpG5qQ@mail.gmail.com>
Date: Wed, 10 Jun 2015 15:31:47 +1000
Message-ID: <CA+WRLO9fnZNezbthL8QmMtZXA5U+AU0NfKmVdKDZQGgL6ehmwA@mail.gmail.com>
Subject: Re: raid 1 to 10 conversion
From: Gareth Pye <gareth@cerberos.id.au>
To: =?UTF-8?Q?Guilherme_Gon=C3=A7alves?= <agamennon@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs has a small bug at the moment where balance can't convert raid
levels (it just does nothing), it is meant to be fixed with the next
kernel release.

On Wed, Jun 10, 2015 at 3:28 PM, Guilherme Gonçalves
<agamennon@gmail.com> wrote:
> Hello!, i think i made a mistake
> i had two 3tb drivre on a raid 1 setup, i bought two aditional 3tb
> drives to make my raid 10 array
> i used this commands
>
> btrfs -f device add /dev/sdc /mnt/nas/    (i used -f because i
> formatted my new drives using gpt)
> btrfs -f device add /dev/sdf /mnt/nas/
>
> finally:
> btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt/nas/
>
> after a couple of hours i ran:
>
> btrfs filesystem  df /mnt/nas/
>
> Data, RAID1: total=963.00GiB, used=962.69GiB
> System, RAID1: total=32.00MiB, used=176.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.59GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> should that not read raid 10 ?
>
> output for btrfs fi usage /mnt/nas
>
> Overall:
>     Device size:  10.92TiB
>     Device allocated:   1.89TiB
>     Device unallocated:   9.02TiB
>     Device missing:     0.00B
>     Used:   1.89TiB
>     Free (estimated):   4.51TiB (min: 4.51TiB)
>     Data ratio:      2.00
>     Metadata ratio:      2.00
>     Global reserve: 512.00MiB (used: 0.00B)
>
> Data,RAID1: Size:963.00GiB, Used:962.69GiB
>    /dev/sdc 481.00GiB
>    /dev/sdd1 482.00GiB
>    /dev/sde1 482.00GiB
>    /dev/sdf 481.00GiB
>
> Metadata,RAID1: Size:6.00GiB, Used:4.59GiB
>    /dev/sdc   4.00GiB
>    /dev/sdd1   2.00GiB
>    /dev/sde1   2.00GiB
>    /dev/sdf   4.00GiB
>
> System,RAID1: Size:32.00MiB, Used:176.00KiB
>    /dev/sdd1  32.00MiB
>    /dev/sde1  32.00MiB
>
> Unallocated:
>    /dev/sdc   2.25TiB
>    /dev/sdd1   2.26TiB
>    /dev/sde1   2.26TiB
>    /dev/sdf   2.25TiB
>
>
> I think i made a mess here...  why is system only on two drives? why
> is it not showing raid 10?
> If i actually failed how do i acheive this? i want all four drives in
> a raid 10 setup.
>
> Thanks in advance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"

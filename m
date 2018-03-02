Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:42836 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946452AbeCBLiL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 06:38:11 -0500
Received: by mail-io0-f180.google.com with SMTP id u84so10333339iod.9
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Mar 2018 03:38:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
References: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
From: Menion <menion@gmail.com>
Date: Fri, 2 Mar 2018 12:37:49 +0100
Message-ID: <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com>
Subject: Re: dmesg flooded with "Very big device. Trying to use READ
 CAPACITY(16)" with 8TB HDDs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it really a no problem? I mean, for some reason BTRFS is
continuously read the HDD capacity in an array, that does not seem to
be really correct
Bye

2018-02-26 11:07 GMT+01:00 Menion <menion@gmail.com>:
> Hi all
> I have recently started to operate an array of 5x8TB HDD (WD RED) in RAID5 mode
> The array seems to work ok, but with the time the dmesg is flooded by this log:
>
> [ 338.674673] sd 0:0:0:0: [sda] Very big device. Trying to use READ
> CAPACITY(16).
> [ 338.767184] sd 0:0:0:1: [sdb] Very big device. Trying to use READ
> CAPACITY(16).
> [  338.989477] sd 0:0:0:3: [sdd] Very big device. Trying to use READ
> CAPACITY(16).
> [  339.301194] sd 0:0:0:4: [sde] Very big device. Trying to use READ
> CAPACITY(16).
> [  339.506579] sd 0:0:0:2: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
> [  649.393340] sd 0:0:0:0: [sda] Very big device. Trying to use READ
> CAPACITY(16).
> [  650.129849] sd 0:0:0:1: [sdb] Very big device. Trying to use READ
> CAPACITY(16).
> [  650.379622] sd 0:0:0:3: [sdd] Very big device. Trying to use READ
> CAPACITY(16).
> [  650.524828] sd 0:0:0:4: [sde] Very big device. Trying to use READ
> CAPACITY(16).
> [  650.721615] sd 0:0:0:2: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
> [  959.544384] sd 0:0:0:0: [sda] Very big device. Trying to use READ
> CAPACITY(16).
> [  959.627015] sd 0:0:0:1: [sdb] Very big device. Trying to use READ
> CAPACITY(16).
> [  959.790280] sd 0:0:0:3: [sdd] Very big device. Trying to use READ
> CAPACITY(16).
> [  959.901179] sd 0:0:0:4: [sde] Very big device. Trying to use READ
> CAPACITY(16).
> [  960.048734] sd 0:0:0:2: [sdc] Very big device. Trying to use READ
> CAPACITY(16).
>
> sda,sdb,sdc,sdd,sde as you can imagine are the HDDs in the array
>
> Other info (note: there is also another single BTRFS array of 3 small
> device that never print this log and my root filesystem is BTRFS as
> well)
>
> menion@Menionubuntu:/etc$ uname -a
> Linux Menionubuntu 4.15.5-041505-generic #201802221031 SMP Thu Feb 22
> 15:32:28 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> menion@Menionubuntu:/etc$   btrfs --version
> btrfs-progs v4.15.1
> menion@Menionubuntu:/etc$ sudo btrfs fi show
> [sudo] password for menion:
> Label: none  uuid: 6db4baf7-fda8-41ac-a6ad-1ca7b083430f
>         Total devices 1 FS bytes used 9.02GiB
>         devid    1 size 27.07GiB used 11.02GiB path /dev/mmcblk0p3
>
> Label: none  uuid: 931d40c6-7cd7-46f3-a4bf-61f3a53844bc
>         Total devices 5 FS bytes used 5.47TiB
>         devid    1 size 7.28TiB used 1.37TiB path /dev/sda
>         devid    2 size 7.28TiB used 1.37TiB path /dev/sdb
>         devid    3 size 7.28TiB used 1.37TiB path /dev/sdc
>         devid    4 size 7.28TiB used 1.37TiB path /dev/sdd
>         devid    5 size 7.28TiB used 1.37TiB path /dev/sde
>
> Label: none  uuid: ba1e0d88-2e26-499d-8fe3-458b9c53349a
>         Total devices 3 FS bytes used 534.50GiB
>         devid    1 size 232.89GiB used 102.03GiB path /dev/sdh
>         devid    2 size 232.89GiB used 102.00GiB path /dev/sdi
>         devid    3 size 465.76GiB used 335.03GiB path /dev/sdj
>
> menion@Menionubuntu:/etc$ sudo btrfs fi df /media/storage/das1
> Data, RAID5: total=5.49TiB, used=5.46TiB
> System, RAID5: total=12.75MiB, used=352.00KiB
> Metadata, RAID5: total=7.00GiB, used=6.11GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> menion@Menionubuntu:/etc$

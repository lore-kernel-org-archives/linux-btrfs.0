Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:51215 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdJ1BJt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 21:09:49 -0400
Received: by mail-io0-f194.google.com with SMTP id b186so16242143iof.8
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 18:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1e230313-112b-c685-f02b-e99cdcb287a8@jmuchemb.eu>
References: <1e230313-112b-c685-f02b-e99cdcb287a8@jmuchemb.eu>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 28 Oct 2017 04:09:08 +0300
Message-ID: <CAGqmi75CA5s0v5p8M-aXKFspVLs81Gc4iJ7fkTR9mwpWnAMHyg@mail.gmail.com>
Subject: Re: raid1: can't readd removed dev while the fs is mounted
To: Julien Muchembled <jm@jmuchemb.eu>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-28 1:40 GMT+03:00 Julien Muchembled <jm@jmuchemb.eu>:
> Hello,
>
> I have 2 disks in RAID1, each one having 2 partitions:
> - 1 for / (BtrFS)
> - 1 for /home (MD/XFS)
>
> For some reasons, 1 disk was removed and readded. I had no issue at readding it to the MD array, but for BtrFS, I had to reboot.
>
> Then, I tried to investigate more using qemu with systemrescuecd (kernel 4.9.30 and btrfs-progs v4.9.1). From:
>
>   /sys/devices/pci0000:00/0000:00:01.1/ata1/host0
>
> I use:
>
>   # echo 1 > target0:0:1/0:0:1:0/delete
>
> to remove sdb and after some changes in the mount point:
>
>   # echo '- - -' > scsi_host/host0/scan
>
> to readd it.
>
> Then I executed
>
>   # btrfs scrub start -B -d /mnt/tmp
>
> to fix things but I only get uncorrectable errors and the dmesg is full of 'i/o error' lines
>
> Maybe some command is required so that BtrFS accept to reuse the device. I tried:
>
>   # btrfs replace start -B -f 2 /dev/sdb /mnt/tmp
>   ERROR: ioctl(DEV_REPLACE_STATUS) failed on "/mnt/tmp": Inappropriate ioctl for device
>
> Julien
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

AFAIK, no, for now btrfs just can't reuse device - no way
At least for mounted FS.
AFAIK, btrfs have patches for dynamic device states, but patches not merged

-- 
Have a nice day,
Timofey.

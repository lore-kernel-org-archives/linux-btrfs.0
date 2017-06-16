Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:35079 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753023AbdFPIuX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 04:50:23 -0400
Received: by mail-qt0-f178.google.com with SMTP id w1so53919482qtg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Jun 2017 01:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
References: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 16 Jun 2017 11:49:42 +0300
Message-ID: <CAGqmi77nF9Kumd95DZyXkpOwkpou3BRSiE-+wBrzMt=X-BmmgQ@mail.gmail.com>
Subject: Re: Disk usage is more than double the snapshots exclusive data
To: vianney@stroebel.fr
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-15 12:44 GMT+03:00 Vianney Stroebel <vianney@stroebel.fr>:
> On a backup drive for a home computer, disk usage as shown by 'btrfs fi
> show' is more than double the snapshots exclusive data as shown by "btrfs
> qgroup show" (574 GB vs 265 GB).
>
> I've done a lot of research online and I couldn't find any answer to this
> problem.
>
> Output of some commands:
>
> uname -a
> Linux viybel-pc 4.10.0-22-generic #24-Ubuntu SMP Mon May 22 17:43:20 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.9.1
>
> sudo btrfs fi show
> Label: 'btrfs-backup'  uuid: 35905dc5-1400-4687-8be7-cf87d6ad0980
>         Total devices 1 FS bytes used 573.89GiB
>         devid    1 size 698.64GiB used 697.04GiB path /dev/sdb1
>
> btrfs fi df /mnt/btrfs-backup
> Data, single: total=670.01GiB, used=564.26GiB
> System, DUP: total=8.00MiB, used=112.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=13.50GiB, used=8.64GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=14.95MiB
>
> From https://github.com/agronick/btrfs-size (i.e. more readable "btrfs
> qgroup show")
>
> btrfs-size /mnt/btrfs-backup
> ==================================================================================================================================
> Snapshot / Subvolume                                               ID
> Total   Exclusive Data
> ==================================================================================================================================
> 10726 gen 216807 top level 5 path full/2016-06-19_12-32-01         10726
> 208.68GB 208.68GB
> 21512 gen 216853 top level 5 path full/2016-12-14_16-21-34         21512
> 166.98GB 40.36GB
> 23054 gen 216853 top level 5 path full/2017-03-03_08-47-00         23054
> 154.79GB 7.53GB
> 25451 gen 216856 top level 5 path full/2017-04-14_21-54-25         25451
> 123.48GB 3.07GB
> 26514 gen 216862 top level 5 path full/2017-05-02_14-58-09         26514
> 123.70GB 5.03GB
> 28499 gen 218095 top level 5 path full/2017-06-11_19-29-16         28499
> 154.65GB 169.78MB
> 28556 gen 218094 top level 5 path full/2017-06-13_03-15-00         28556
> 154.88GB 403.89MB
> ==================================================================================================================================
>                                                                 Exclusive
> Total: 265.23GB
>
> Feel free to ask me any question.
>
> Vianney

btrfs fi du -s /mnt/btrfs-backup


-- 
Have a nice day,
Timofey.

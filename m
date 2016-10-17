Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35025 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754835AbcJQRXj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:23:39 -0400
Received: by mail-io0-f175.google.com with SMTP id f5so12603766ioj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 10:23:39 -0700 (PDT)
Subject: Re: Monitoring Btrfs
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
Date: Mon, 17 Oct 2016 13:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-17 12:44, Stefan Malte Schumacher wrote:
> Hello
>
> I would like to monitor my btrfs-filesystem for missing drives. On
> Debian mdadm uses a script in /etc/cron.daily, which calls mdadm and
> sends an email if anything is wrong with the array. I would like to do
> the same with btrfs. In my first attempt I grepped and cut the
> information from "btrfs fi show" and let the script send an email if
> the number of devices was not equal to the preselected number.
>
> Then I saw this:
>
> ubuntu@ubuntu:~$ sudo btrfs filesystem show
> Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
>     Total devices 6 FS bytes used 5.47TiB
>     devid    1 size 1.81TiB used 1.71TiB path /dev/sda3
>     devid    2 size 1.81TiB used 1.71TiB path /dev/sdb3
>     devid    3 size 1.82TiB used 1.72TiB path /dev/sdc1
>     devid    4 size 1.82TiB used 1.72TiB path /dev/sdd1
>     devid    5 size 2.73TiB used 2.62TiB path /dev/sde1
>     *** Some devices missing
>
> on this page: https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> The number of devices is still at 6, despite the fact that one of the
> drives is missing, which means that my first idea doesnt work.
This is actually correct behavior, the filesystem reports that it should 
have 6 devices, which is how it knows a device is missing.
> I have
> two questions:
> 1) Has anybody already written a script like this? After all, there is
> no need to reinvent the wheel a second time.
Not that I know of, but I may be wrong.
> 2) What should I best grep for? In this case I would just go for the
> "missing". Does this cover all possible outputs of btrfs fi show in
> case of a damaged array? What other outputs do I need to consider for
> my script.
That should catch any case of a failed device.  It will not catch things 
like devices being out of sync or at-rest data corruption.  In general, 
you should be running scrub regularly to check for those conditions (and 
fix them if they have happened).

FWIW, what I watch is the filesystem flags (it will go read-only if it 
becomes degraded), and the filesystem size (which will change in most 
cases as disks are added or removed).  I also have regular SMART status 
checks on the disks themselves too though, so even aside from BTRFS, 
I'll know if a disk has failed (or thinks it's failed) pretty quickly.

Also, you may want to look into something like Monit 
(https://mmonit.com/monit/) to handle the monitoring.  It lets you 
define all your monitoring requirements in a single file (or multiple if 
you prefer), and provides the infrastructure to handle e-mail 
notifications (including the ability to cache messages when the upstream 
mail server is down).

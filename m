Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36503 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbcJSWq2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 18:46:28 -0400
Received: by mail-lf0-f51.google.com with SMTP id b75so46722969lfg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 15:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Thu, 20 Oct 2016 00:46:25 +0200
Message-ID: <CAA3ktqnht2NterzovpwhRoE0gDrEJ4=WEonttcHhdN9SDxvbOA@mail.gmail.com>
Subject: Re: Monitoring Btrfs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to everybody for the help. I have been doing regular
smart-tests for quite some time and I also let scrub run on a regular
basis.
I will use a simple shellscript witch inspects the output of "greps
btrfs fi show" for lines containing "missing" and another which checks
"btrfs dev stats" for None-Zero Entries.

Thanks everybody for your advice.
Stefan

2016-10-17 18:44 GMT+02:00 Stefan Malte Schumacher
<stefan.m.schumacher@gmail.com>:
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
> drives is missing, which means that my first idea doesnt work. I have
> two questions:
> 1) Has anybody already written a script like this? After all, there is
> no need to reinvent the wheel a second time.
> 2) What should I best grep for? In this case I would just go for the
> "missing". Does this cover all possible outputs of btrfs fi show in
> case of a damaged array? What other outputs do I need to consider for
> my script.
>
> Yours sincerely
> Stefan

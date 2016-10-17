Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35565 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965200AbcJQQoQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 12:44:16 -0400
Received: by mail-qk0-f181.google.com with SMTP id z190so244763982qkc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:44:16 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Mon, 17 Oct 2016 18:44:14 +0200
Message-ID: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
Subject: Monitoring Btrfs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I would like to monitor my btrfs-filesystem for missing drives. On
Debian mdadm uses a script in /etc/cron.daily, which calls mdadm and
sends an email if anything is wrong with the array. I would like to do
the same with btrfs. In my first attempt I grepped and cut the
information from "btrfs fi show" and let the script send an email if
the number of devices was not equal to the preselected number.

Then I saw this:

ubuntu@ubuntu:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 6 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sda3
    devid    2 size 1.81TiB used 1.71TiB path /dev/sdb3
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc1
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd1
    devid    5 size 2.73TiB used 2.62TiB path /dev/sde1
    *** Some devices missing

on this page: https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
The number of devices is still at 6, despite the fact that one of the
drives is missing, which means that my first idea doesnt work. I have
two questions:
1) Has anybody already written a script like this? After all, there is
no need to reinvent the wheel a second time.
2) What should I best grep for? In this case I would just go for the
"missing". Does this cover all possible outputs of btrfs fi show in
case of a damaged array? What other outputs do I need to consider for
my script.

Yours sincerely
Stefan

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36173 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933155AbdGTHGz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 03:06:55 -0400
Received: by mail-io0-f170.google.com with SMTP id q2so8432108ioe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 00:06:54 -0700 (PDT)
MIME-Version: 1.0
From: Chen Chiang CHAI <ccchai86@gmail.com>
Date: Thu, 20 Jul 2017 17:06:53 +1000
Message-ID: <CAEQdt1LLXd1_Oq8QR2dmi0n-CzOeA7GZJwOzuoHWLXSCpZpa=A@mail.gmail.com>
Subject: btrfs cant mount -d single 4 volumes of different sizes hard drives
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Sir,

my btrfs -d single(4 drives) is failing when one of my hard drive is
slowly dying.

because of that, i wanted to remove the hard drive thats responsible
for it, so i used btrfs device delete /dev/sdf after it mounted.
It was successful, so i have 3 drives left and its working.

So i physically removed the dying drive and move one of the working
drive to a different sata port( probably shouldnt have done that:
silly me )

Now when i start up my archlinux 4.11.10,
This problem occured as below:

Scanning for Btrfs filesystems
~ >>> sudo btrfs fi show
Label: none  uuid: 72977fa6-09de-43f0-a6db-ddfdbc668e50
Total devices 4 FS bytes used 1.02TiB
devid    1 size 465.76GiB used 195.01GiB path /dev/sdb
devid    3 size 931.51GiB used 659.03GiB path /dev/sdd
devid    5 size 1.82TiB used 194.03GiB path /dev/sde
*** Some devices missing

I tried to mount in -o degraded this the error it produced when dmesg ｜ tail
~ >>> dmesg | tail
                            [32]
[  382.410910] BTRFS error (device sdb): failed to read chunk tree: -22
[  382.442944] BTRFS error (device sdb): open_ctree failed
[  671.080860] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  986.041955] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 1196.432643] BTRFS info (device sdb): allowing degraded mounts
[ 1196.432647] BTRFS info (device sdb): disk space caching is enabled
[ 1196.432648] BTRFS info (device sdb): has skinny extents
[ 1196.502252] BTRFS error (device sdb): super_num_devices 4 mismatch
with num_devices 3 found here
[ 1196.502256] BTRFS error (device sdb): failed to read chunk tree: -22
[ 1196.531619] BTRFS error (device sdb): open_ctree failed

search all over the net for that mismatch error.. only one mailing
list comes out saying something about using a tool to set
super_num_devices but there's no solution to it..

Sorry if my english is just weird not my first language.

Please help Thank you very much

sincerely yours,
Desparate Fool

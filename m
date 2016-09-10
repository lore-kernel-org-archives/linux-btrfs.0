Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36003 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbcIJG7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 02:59:22 -0400
Received: by mail-vk0-f44.google.com with SMTP id m62so31982023vkd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 23:59:22 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Grdykopl=C4=85s_Namorzyn?= <ssuukk2@gmail.com>
Date: Sat, 10 Sep 2016 08:59:21 +0200
Message-ID: <CAN3EzUeH0uFW1fD0vkmeoz01ha1fAabTVmupsaG_ejR4hR1WKQ@mail.gmail.com>
Subject: Btrfs unmountable - claims it is missing a volume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While my btrfs mounts ok on several instances of my home OpenElec, but
on ArchLinux it fails with:

[174828.954975] BTRFS error (device sdc): super_num_devices 3 mismatch
with num_devices 2 found here

[174828.956969] BTRFS error (device sdc): failed to read chunk tree: -22

Note that it never had 3 volumes! Same happens with -o degraded:

[174828.860334] BTRFS info (device sdc): allowing degraded mounts
[174828.860352] BTRFS info (device sdc): disk space caching is enabled
[174828.954975] BTRFS error (device sdc): super_num_devices 3 mismatch
with num_devices 2 found here
[174828.956969] BTRFS error (device sdc): failed to read chunk tree: -22

My system:

[root@storage ~]#   uname -a
Linux storage 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST
2016 x86_64 GNU/Linux
[root@storage ~]#   btrfs --version
btrfs-progs v4.7
[root@storage ~]#   btrfs fi show
Label: none  uuid: 8ef88ab7-0dae-481c-bb68-5fbed7e86efa
        Total devices 3 FS bytes used 4.68TiB
        devid    1 size 3.64TiB used 3.26TiB path /dev/sdc
        devid    3 size 1.82TiB used 1.44TiB path /dev/sdb
        *** Some devices missing

What can I do to mount it on this machine?

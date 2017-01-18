Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35245 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbdARQoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 11:44:04 -0500
Received: by mail-it0-f51.google.com with SMTP id 203so121406667ith.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 08:44:04 -0800 (PST)
Received: from localhost ([108.63.177.210])
        by smtp.gmail.com with ESMTPSA id z13sm1276979ioz.3.2017.01.18.08.44.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Jan 2017 08:44:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Message-ID: <148475784092.5560.1270748127213800815@luna>
From: Steven Hum <sdothum@gmail.com>
Subject: Cannot mount volume after balance crash
Date: Wed, 18 Jan 2017 11:44:00 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added 2 drives to my RAID10, then ran btrfs balance. The system appears
to have crashed after several hours (I was ssh'd into that server at the
time on my local network). When I rebooted the Arch system, I ran btrfs
check and no errors were reported.

However, attempting to mount the vol hangs the system. Trying to mount
the system in recovery mode also hangs the system.

    ─────  uname -a                                                                                                                             ~
Linux luna 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016 x86_64 GNU/Linux
    ─────     btrfs --version                                                                                                                   ~
btrfs-progs v4.9
    ─────     btrfs fi show                                                                                                                     ~
Label: 'Archlinux'  uuid: e5ee12ac-7fb3-4e73-b9b2-a5cfb35145ae
        Total devices 1 FS bytes used 66.41GiB
        devid    1 size 111.24GiB used 111.24GiB path /dev/sda2

Label: 'Share'  uuid: 9102bb33-49ad-4baf-a88d-1c7622bff938
        Total devices 6 FS bytes used 4.20TiB
        devid    1 size 2.73TiB used 1.90TiB path /dev/sdc
        devid    2 size 2.73TiB used 1.90TiB path /dev/sdd
        devid    3 size 2.73TiB used 1.90TiB path /dev/sde
        devid    4 size 2.73TiB used 1.90TiB path /dev/sdb
        devid    5 size 2.73TiB used 440.34GiB path /dev/sdf
        devid    6 size 2.73TiB used 440.34GiB path /dev/sdg

The dmesg log when attempting to mount the vol can be found at url

http://cwillu.com:8080/108.63.177.210/1

Any ideas what can be done to be able to mount the volume and complete
the balancing?

Regards,
Steven


--
"Truth or die."

Steven Hum
417 Mayfair Av
Ottawa, ON K1Y 0K4
email sdothum@gmail.com
tel 613.237.9058


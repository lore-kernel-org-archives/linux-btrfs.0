Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60832 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaA2TQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 14:16:51 -0500
Received: by mail-qc0-f178.google.com with SMTP id m20so3398965qcx.23
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 11:16:50 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Wed, 29 Jan 2014 20:16:09 +0100
Message-ID: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
Subject: lost with degraded RAID1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My situation:

Former btrfs-RAID1 on two luks encrypted partitions (bunkerA and bunkerB).
Disk holding bunkerB died online.
Now I started rebalancing bunkerA to single, but in between had the
idea to go over a reboot ("maybe the disk reappears"?). So stopped
rebalancing, rebooted.
Now the damaged disk disappeared completely. No sign of it in /proc/diskstats.
So, i wanted to finish the rebalancing to single.

Label: bunker  uuid: 7f954a85-7566-4251-832c-44f2d3de2211
        Total devices 2 FS bytes used 1.58TiB
        devid    1 size 1.82TiB used 1.58TiB path
        devid    2 size 1.82TiB used 1.59TiB path /dev/mapper/bunkerA

btrfs filesystem df /mnt
Data, RAID1: total=1.58TiB, used=1.57TiB
Data, single: total=11.00GiB, used=10.00GiB
System, RAID1: total=8.00MiB, used=240.00KiB
Metadata, RAID1: total=3.00GiB, used=1.61GiB

The 11 GiB single Data was balanced in this way while having no second
actually functioning device in the array before reboot!

But now, I can't mount bunkerA degraded,RW because degraded
filesystems are not allowed to be mounted RW (?). The consequence is,
that I felt unable to do anything other than mounting it RO and back
it up (all data is fine) to another filesystem. I don't have a new
substitute disk, yet, so I couldn't test whether I can add a new
device to a RO-mounted filesystem. Adding a loop device didn't work.

What are my options now? What further information could be useful? I
cant believe, that I have all my data in front of me and have to start
over again with a new filesystem because of security checks and no
enforcement option to mount it RW.

Thanks

Johan Kröckel

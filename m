Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36311 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbcFJSEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 14:04:38 -0400
Received: by mail-vk0-f66.google.com with SMTP id v188so2613411vkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 11:04:37 -0700 (PDT)
MIME-Version: 1.0
From: "ojab //" <ojab@ojab.ru>
Date: Fri, 10 Jun 2016 18:04:34 +0000
Message-ID: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
Subject: Cannot balance FS (No space left on device)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Please CC me since I'm not subscribed to the list]
Hi,
I've tried to `/usr/bin/btrfs fi defragment -r` my btrfs partition,
but it's failed w/ "No space left on device" and now I can't get any
free space on that partition (deleting some files or adding new device
doesn't help). During defrag I've used `space_cache=v2` mount option,
but remounted FS w/ `clear_cache` flag since then. Also I've deleted
about 50Gb of files and added new 250Gb disk since then:

>$ df -h /mnt/xxx/
>Filesystem      Size  Used Avail Use% Mounted on
>/dev/sdc1       2,1T  1,8T   37G  99% /mnt/xxx
>$ sudo /usr/bin/btrfs fi show
>Label: none  uuid: 8a65465d-1a8c-4f80-abc6-c818c38567c3
>    Total devices 3 FS bytes used 1.78TiB
>    devid    1 size 931.51GiB used 931.51GiB path /dev/sdc1
>    devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
>    devid    3 size 230.41GiB used 0.00B path /dev/sdd1
>$ sudo /usr/bin/btrfs fi usage /mnt/xxx/
>Overall:
>    Device size:                   2.04TiB
>    Device allocated:              1.82TiB
>    Device unallocated:            230.41GiB
>    Device missing:                0.00B
>    Used:                          1.78TiB
>    Free (estimated):              267.23GiB      (min: 152.03GiB)
>    Data ratio:                    1.00
>    Metadata ratio:                2.00
>    Global reserve:                512.00MiB      (used: 0.00B)
>
>Data,RAID0: Size:1.81TiB, Used:1.78TiB
>   /dev/sdb1               928.48GiB
>   /dev/sdc1               928.48GiB
>
>Metadata,RAID1: Size:3.00GiB, Used:2.30GiB
>   /dev/sdb1       3.00GiB
>   /dev/sdc1       3.00GiB
>
>System,RAID1: Size:32.00MiB, Used:176.00KiB
>   /dev/sdb1    32.00MiB
>   /dev/sdc1    32.00MiB
>
>Unallocated:
>   /dev/sdb1       1.01MiB
>   /dev/sdc1       1.00MiB
>   /dev/sdd1       230.41GiB
>$ sudo /usr/bin/btrfs balance start -dusage=66 /mnt/xxx/
>Done, had to relocate 0 out of 935 chunks
>$ sudo /usr/bin/btrfs balance start -dusage=67 /mnt/xxx/
>ERROR: error during balancing '/mnt/xxx/': No space left on device
>There may be more info in syslog - try dmesg | tail

I assume that there is something wrong with metadata, since I can copy
files to FS.
I'm on 4.6.2 vanilla kernel and using btrfs-progs-4.6, btrfs-debugfs
output can be found here:
https://gist.githubusercontent.com/ojab/1a8b1f83341403a169a8e66995c7c3da/raw/61621d22f706d7543a93a3d005415543af9a0db0/gistfile1.txt.
Any hint what else can I try to fix the issue?

//wbr ojab

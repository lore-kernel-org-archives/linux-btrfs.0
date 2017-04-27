Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34331 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934082AbdD0Nwc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 09:52:32 -0400
Received: by mail-oi0-f48.google.com with SMTP id x184so38255106oia.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 06:52:32 -0700 (PDT)
MIME-Version: 1.0
From: Gerard Saraber <gsaraber@rarcoa.com>
Date: Thu, 27 Apr 2017 08:52:30 -0500
Message-ID: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
Subject: No space left on device when doing "mkdir"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I'm running: Linux shrapnel 4.11.0-rc8 #2 SMP Mon Apr 24 08:47:46 CDT
2017 x86_64 Intel(R) Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
32GB memory

There's a kworker taking 100% cpu:
30856 root      20   0       0      0      0 R 100.0  0.0  19:26.90
kworker/u8:0

and writing about 3-5MB/sec according to iotop:
30856 be/4 root        0.00 B/s    5.07 M/s  0.00 %  0.00 % [kworker/u8:0]

My filesystem is a Raid1 and has plenty of space:
/dev/sdb         35T   21T   14T  61% /home/exports

and I am using NFS to write to the volume, a lot

Label: none  uuid: 7af2e65c-3935-4e0d-aa63-9ef6be991cb9
        Total devices 18 FS bytes used 20.92TiB
        devid    2 size 3.64TiB used 2.24TiB path /dev/sdb
        devid    3 size 3.64TiB used 2.46TiB path /dev/sdc
        devid    4 size 3.64TiB used 2.00TiB path /dev/sde
        devid    7 size 2.73TiB used 1.42TiB path /dev/sdl
        devid    8 size 2.73TiB used 1.12TiB path /dev/sdn
        devid    9 size 3.64TiB used 2.35TiB path /dev/sdq
        devid   10 size 3.64TiB used 2.07TiB path /dev/sdr
        devid   11 size 5.46TiB used 4.19TiB path /dev/sda
        devid   12 size 5.46TiB used 4.23TiB path /dev/sdf
        devid   13 size 5.46TiB used 4.08TiB path /dev/sdh
        devid   14 size 3.64TiB used 1.98TiB path /dev/sdo
        devid   15 size 2.73TiB used 1.07TiB path /dev/sdm
        devid   17 size 5.46TiB used 3.80TiB path /dev/sdd
        devid   18 size 2.73TiB used 1.07TiB path /dev/sdj
        devid   19 size 2.73TiB used 1.07TiB path /dev/sdg
        devid   20 size 2.73TiB used 1.07TiB path /dev/sdk
        devid   21 size 3.64TiB used 1.98TiB path /dev/sdp
        devid   22 size 5.46TiB used 3.80TiB path /dev/sds

The problem:

shrapnel gerard-store # mkdir gopro
mkdir: cannot create directory 'gopro': No space left on device

^^ that error message pops up after 10-15 seconds.

I could just reboot the system and be fine for a week or so, but is
there any way to diagnose this?

Thanks!
-Gerard

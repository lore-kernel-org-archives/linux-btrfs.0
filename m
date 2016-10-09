Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34737 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbcJIU7Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Oct 2016 16:59:25 -0400
Received: by mail-yw0-f180.google.com with SMTP id w3so33406098ywg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Oct 2016 13:59:25 -0700 (PDT)
MIME-Version: 1.0
From: Jeremy Yoder <jmyoder@gmail.com>
Date: Sun, 9 Oct 2016 16:59:04 -0400
Message-ID: <CALbEpLMp0L1aCCp5_ctYq_HE-XkW7XbXnNKP3SvDKcmxWYgOXw@mail.gmail.com>
Subject: Data total size shrinking during btrfs balance
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't notice this until it was nearly too late.  I had run out of
metadata space so I ran
 btrfs balance start -v -dusage=0 /mnt/btrfsroot

That went fine, but I was still low on metadata space, so I tried a
few variations:
 btrfs balance start -v -dusage=1 /mnt/btrfsroot
 btrfs balance start -v -dusage=5 /mnt/btrfsroot
 btrfs balance start -v -dusage=10 /mnt/btrfsroot

I didn't run any of these to completion, I cancelled them after a few hours.

I captured the output of a couple commands every once in a while:
 btrfs fi df /mnt/btrfsroot
 btrfs fi show /dev/sda5

What I didn't notice (because I was looking at the metadata space) was
the Data total size.

It starts out as:

Data, single: total=4.61TiB, used=2.50TiB
System, DUP: total=8.00MiB, used=576.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=46.50GiB, used=42.82GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=0.00

Label: none  uuid: e6818780-7d28-41fe-b7a8-e38b61a98621
        Total devices 1 FS bytes used 2.54TiB
        devid    1 size 5.35TiB used 4.70TiB path /dev/sda5

Over time however, the Data total begins to drop:
Data, single: total=4.56TiB, used=2.50TiB
Data, single: total=4.41TiB, used=2.50TiB
Data, single: total=4.23TiB, used=2.51TiB
Data, single: total=4.00TiB, used=2.51TiB
Data, single: total=3.59TiB, used=2.51TiB
Data, single: total=3.35TiB, used=2.51TiB

The drop corresponds to a drop in the "show" used amounts:
        devid    1 size 5.35TiB used 4.65TiB path /dev/sda5
        devid    1 size 5.35TiB used 4.50TiB path /dev/sda5
        devid    1 size 5.35TiB used 4.32TiB path /dev/sda5
        devid    1 size 5.35TiB used 4.09TiB path /dev/sda5
        devid    1 size 5.35TiB used 3.68TiB path /dev/sda5
        devid    1 size 5.35TiB used 3.44TiB path /dev/sda5

System info:
Ubuntu 14.04
Linux server4 4.4.0-38-generic #57~14.04.1-Ubuntu SMP Tue Sep 6
17:20:43 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

I had been running the 14.04 btrfs-progs version 3.12-1ubuntu0.1

I just upgraded to btrfs-progs 4.4.1~ubuntu14.04.1~ppa1 from a PPA,
which allowed me to run
# btrfs fi usage /mnt/btrfsroot/
Overall:
    Device size:                   5.35TiB
    Device allocated:              3.44TiB
    Device unallocated:            1.91TiB
    Device missing:                  0.00B
    Used:                          2.59TiB
    Free (estimated):              2.75TiB      (min: 1.80TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:3.35TiB, Used:2.51TiB
   /dev/sda5       3.35TiB

Metadata,DUP: Size:46.50GiB, Used:42.07GiB
   /dev/sda5      93.00GiB

System,DUP: Size:32.00MiB, Used:416.00KiB
   /dev/sda5      64.00MiB

Unallocated:
   /dev/sda5       1.91TiB

Any suggestions?

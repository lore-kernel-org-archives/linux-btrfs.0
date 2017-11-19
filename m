Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:44548 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdKSGRn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 01:17:43 -0500
Received: by mail-ot0-f182.google.com with SMTP id d27so5229859ote.11
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 22:17:43 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 18 Nov 2017 23:17:42 -0700
Message-ID: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
Subject: bug? fstrim only trims unallocated space, not unused in bg's
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fstrim should trim free space, but it only trims unallocated. This is
with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
behaved this way with 4.12 also.


[root@f27h ~]# fstrim -v /
/: 39 GiB (41841328128 bytes) trimmed
[root@f27h ~]# btrfs fi us /
Overall:
    Device size:          70.00GiB
    Device allocated:          31.03GiB
    Device unallocated:          38.97GiB
    Device missing:             0.00B
    Used:              22.02GiB
    Free (estimated):          47.72GiB    (min: 47.72GiB)
    Data ratio:                  1.00
    Metadata ratio:              1.00
    Global reserve:          65.97MiB    (used: 0.00B)

Data,single: Size:30.00GiB, Used:21.25GiB
   /dev/nvme0n1p8      30.00GiB

Metadata,single: Size:1.00GiB, Used:791.58MiB
   /dev/nvme0n1p8       1.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/nvme0n1p8      32.00MiB

Unallocated:
   /dev/nvme0n1p8      38.97GiB


-- 
Chris Murphy

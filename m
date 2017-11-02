Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:55225 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754573AbdKBMYV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:24:21 -0400
Received: from mail-yw0-f174.google.com ([209.85.161.174]) by
 mrelay.perfora.net (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0MKbHV-1eAVG73ASl-001vsf for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017
 13:24:20 +0100
Received: by mail-yw0-f174.google.com with SMTP id q126so4567037ywq.10
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 05:24:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$684ae$1b07c469$c5218ba1$a89f7997@cox.net>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
 <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com>
 <pan$7f6a7$60d76ea4$36d8c4cb$1d03823c@cox.net> <pan$684ae$1b07c469$c5218ba1$a89f7997@cox.net>
From: Zak Kohler <y2k@y2kbugger.com>
Date: Thu, 2 Nov 2017 08:23:49 -0400
Message-ID: <CAD8FQQ2hZ_6t6FD1ELBXjczwaodggvYwKe630QNuPMB_DvDwig@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well it looks like things have stabilized....for the
moment at least.

$ btrfs scrub start --offline --progress /dev/disk/by-id/XX3
Doing offline scrub [o] [681/681]
Scrub result:
Tree bytes scrubbed: 5234425856
Tree extents scrubbed: 638968
Data bytes scrubbed: 4353724284928
Data extents scrubbed: 374300
Data bytes without csum: 533200896
Read error: 0
Verify error: 0
Csum error: 0

$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/XX3
Doing offline scrub [o] [681/681]
Scrub result:
Tree bytes scrubbed: 5234425856
Tree extents scrubbed: 638968
Data bytes scrubbed: 4353724284928
Data extents scrubbed: 374300
Data bytes without csum: 533200896
Read error: 0
Verify error: 0
Csum error: 0

$ sudo btrfs send /mnt/dataroot.2017.10.21 | pv -i2 > /dev/null
At subvol /mnt/dataroot.2017.10.21
1.55TiB 1:38:46 [ 283MiB/s] [         <=>                               ]

One interesting note is that when the --offline scrub came back with
Csum errors, sometimes the Tree bytes scrubbed were different:

Tree bytes scrubbed: 5234491392 #bad
vs
Tree bytes scrubbed: 5234425856 #good

The hardware is a Q6600 (the first Core2 Quad @2.4GHz) and a dell PERC
6/i card flashed with IT mode.

*** 2 days have past since I wrote the above
I checked my overclock and sure enough I had the FSB boosted, CPU
reaching ~2.9 GHz. The PCI were held at a constant freq but I bet
there was some bad interaction with the PERC. I don't know why the
system chose to be stable 2 days ago before resetting the overclock,
but I am very confident it will stay that way now.

Takeaways:

1. I came to btrfs because upon manual hash comparison I noticed bit
flips occurring. Now I have very likely found the source of the issues
thanks to btrfs and I can also be more confident against those issues
in the future.

2. A stable memtest86+ doesn't necessarily mean a stable storage stack

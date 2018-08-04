Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42994 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbeHDMO5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 08:14:57 -0400
Received: by mail-pf1-f172.google.com with SMTP id l9-v6so4515059pff.9
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Aug 2018 03:14:45 -0700 (PDT)
MIME-Version: 1.0
From: Marijn Stollenga <m.stollenga@gmail.com>
Date: Sat, 4 Aug 2018 12:14:44 +0200
Message-ID: <CAP-4mcAfmp-rCrr5_-TJL4HNz8tVi5kpsOo-8WkZNRLRPOgD=g@mail.gmail.com>
Subject: recover broken partition on external HDD
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs experts, I need your help trying to recover an external
HDD. I accidentally created a zfs partition on my external HD, which
of course screw up the whole partition. I quickly unplugged it and it
being a 1TB drive is assume there is still data on it.

With some great help on IRC I searched for tags using grep and found
many positions:
https://paste.ee/p/xzL5x

Now I would like to scan all these positions for their information and
somehow piece it together, I know there is supposed to be a superblock
around 256GB but I'm not sure where the partition started (the search
was run from a manually created partition starting at 1MB).

In general I would be happy if someone can point me to a library that
can do low level reading and piecing together of these pieces of meta
information and see what is left.

I know there is btrfs-check etc. but these need the superblock to be
known. Also on another messed up drive (I screwed up two btrfs drives
in the same way at the same time) I was able to find the third
superblock, but it seems they in the end pointed to other parts in the
file system in the beginning of the drive which were broken.

In general I would really want the lowest level library that can read
these pieces of information and try to recover anything. Any pointers
are very appreciated.

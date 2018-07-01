Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:41800 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbeGAB7Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 21:59:16 -0400
Received: by mail-lf0-f44.google.com with SMTP id y127-v6so9431057lfc.8
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jun 2018 18:59:15 -0700 (PDT)
MIME-Version: 1.0
From: Lewis Diamond <me@lewisdiamond.com>
Date: Sat, 30 Jun 2018 21:59:14 -0400
Message-ID: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
Subject: btrfs check --readonly crash
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I've been told to report this issue to this mailing list.

sudo btrfs check --readonly /dev/sdc
Checking filesystem on /dev/sdc
UUID: 2630aec8-8399-4bd8-9397-8c04953a35d5
checking extents
checking free space cache
there is no free space entry for 1596152365056-1596152381440
there is no free space entry for 1596152365056-1597220323328
cache appears valid but isn't 1596146581504
there is no free space entry for 1613348585472-1613348618240
there is no free space entry for 1613348585472-1614400192512
cache appears valid but isn't 1613326450688
block group 1645538705408 has wrong amount of free space, free space
cache has 58212352 block group has 58277888
failed to load free space cache for block group 1645538705408
block group 1683119669248 has wrong amount of free space, free space
cache has 52838400 block group has 52953088
failed to load free space cache for block group 1683119669248
btrfs: unable to add free space :-17
free-space-cache.c:843: btrfs_add_free_space: BUG_ON `ret == -EEXIST`
triggered, value 1
btrfs(+0x37337)[0x556024d5d337]
btrfs(btrfs_add_free_space+0x11d)[0x556024d5da2d]
btrfs(load_free_space_cache+0xde9)[0x556024d5e889]
btrfs(cmd_check+0x15fe)[0x556024d8b9ee]
btrfs(main+0x88)[0x556024d38768]
/usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f9382a9506b]
btrfs(_start+0x2a)[0x556024d3888a]
Aborted


This happened on a USB HDD duo in raid 1 which had btrfs issues
(probably due to a bad controller). One of the hdd was subsequently
dropped by a 2 year old (causing subsequent checks to crash).

-Lewis

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:38819 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754219AbdG3QPQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Jul 2017 12:15:16 -0400
Received: by mail-ua0-f171.google.com with SMTP id w45so182634474uac.5
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jul 2017 09:15:16 -0700 (PDT)
MIME-Version: 1.0
From: "marcel.cochem" <marcel.cochem@googlemail.com>
Date: Sun, 30 Jul 2017 18:14:35 +0200
Message-ID: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
Subject: BTRFS error: bad tree block start 0 623771648
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had to shut down my PC because it hang up, after the next reboot i
got the following error:
    BTRFS error on /dev/nvme0n1p4 bad tree block start 0 623771648
    open_ctree failed
    mount wrong fs type
    bad superblock
    missing codepage or helper program, or other error.

I had no backup (schame on my, now i made a backup of my failed parition)
I can't check or rescure any data, because all btrfs-progs stop with
messages like:

    root@marcel-debug:/mnt# btrfs restore  /dev/nvme0n1p4 /mnt/1
    checksum verify failed on 623771648 found E4E3BDB6 wanted 00000000
    checksum verify failed on 623771648 found E4E3BDB6 wanted 00000000
    bytenr mismatch, want=623771648, have=0
    Couldn't read tree root

or

    root@marcel-debug:/home/marcel/Desktop/btrfs-progs#
./btrfs-find-root /dev/nvme0n1p4
    Couldn't read tree root
    Superblock thinks the generation is 82096
    Superblock thinks the level is 1

My bad installation had kernel 4.11 and my rescue installation has
also 4.11 installed. However the btrfs-progs had some problems
(endless loop for btrfs-find-root), so i decided to compile them
myself with the newest version 4.12 . However neither version works.

I am pretty sure that not all data is lost as i can grep thorugh the
100 GB SSD partition. But my question is, if there is a tool to rescue
all (intact) data and maybe have only a few corrupt files which can't
be recovered.

I put detailed information and commands outputs in pastebin:
https://pastebin.com/7kzjb4Ae

Best regards,
Marcel

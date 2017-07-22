Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34126 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdGVH6r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 03:58:47 -0400
Received: by mail-lf0-f46.google.com with SMTP id g25so26257292lfh.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 00:58:47 -0700 (PDT)
Received: from [192.168.1.6] (ppp109-252-90-242.pppoe.spdop.ru. [109.252.90.242])
        by smtp.gmail.com with ESMTPSA id 2sm1314271ljo.48.2017.07.22.00.58.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jul 2017 00:58:45 -0700 (PDT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: How to detect "orphaned" subvolume attachment point in snapshot?
Message-ID: <9d5e5337-8b67-cce0-f85b-431639afaf48@gmail.com>
Date: Sat, 22 Jul 2017 10:58:44 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is structure of snapshots in openSUSE; all snapshots of root volume
are created under /.snapshots subvolume:

linux-gtrk:/host/home/src/python-btrfs/examples # sudo mount -o
ro,subvol=/ /dev/sda3 /mnt
linux-gtrk:/host/home/src/python-btrfs/examples #
./show_directory_contents.py /mnt/
directory /mnt/@ tree 257 inum 256
inode generation 6 transid 315 size 72 nbytes 0 block_group 0 mode 40755
nlink 1 uid 0 gid 0 rdev 0 flags 0x0(none)
inode ref index 0 name utf-8 ..
...
dir item list hash 1921786525 size 1
    dir item location (258 ROOT_ITEM -1) type DIR name utf-8 .snapshots
...
linux-gtrk:/host/home/src/python-btrfs/examples #
./show_directory_contents.py /mnt/@/.snapshots/251/snapshot/
directory /mnt/@/.snapshots/251/snapshot/ tree 774 inum 256
inode generation 6 transid 15867 size 164 nbytes 0 block_group 0 mode
40755 nlink 1 uid 0 gid 0 rdev 0 flags 0x0(none)
inode ref index 0 name utf-8 ..
...
dir item list hash 1921786525 size 1
    dir item location (258 ROOT_ITEM -1) type DIR name utf-8 .snapshots
...
linux-gtrk:/host/home/src/python-btrfs/examples #

Note that both directory items in /mnt/@ and
/mnt/@/.snapshots/251/snapshot store the same tree ID for .snapshots
item - 258. This causes grub2 btrfs driver loop - when it comes to
/mnt/@/.snapshots/251/snapshot and looks for .snapshots it jumps back to
/mnt/@/.snapshots tree.

I see that in Linux kernel somehow distinguishes between both of them; I
am not sure how it actually does it though.

What on-disk information should we check to find out "orphaned" snapshot
directory?

TIA

-andrei



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34878 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbcBGNPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 08:15:04 -0500
Received: by mail-lb0-f172.google.com with SMTP id bc4so70779939lbc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 05:15:02 -0800 (PST)
MIME-Version: 1.0
Reply-To: a.t.hild@gmail.com
Date: Sun, 7 Feb 2016 20:15:01 +0700
Message-ID: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
Subject: Fi corruption on RAID1, generation doesn't match
From: Andreas Hild <a.t.hild@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

The file system on a RAID1 Debian server seems corrupted in a major
way, with 99% of the files not found. This was the result of a
precarious shutdown after a crash that was preceded by an accidental
misconfiguration in /etc/fstab; it pointed "/" and "/tmp" to one and
the same UUID by omitting a subvol entry.

Is there any way to repair or recover a substantial part of this RAID?

The following output was obtained via a live disk boot.


Many thanks!

Best wishes,
Andreas


--- --- ---
uname -a
Linux debian 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3
(2016-01-17) x86_64 GNU/Linux
--

sudo btrfs fi show
Label: none  uuid: fc429e82-f46e-4018-a9fa-ded688cef161
        Total devices 2 FS bytes used 42.36MiB
        devid    1 size 455.76GiB used 169.03GiB path /dev/sdb4
        devid    2 size 455.76GiB used 169.03GiB path /dev/sda4

Btrfs v3.17

--
sudo btrfs fi df /mnt
Data, RAID1: total=168.00GiB, used=42.00MiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=1.00GiB, used=320.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
--

sudo btrfs subvol list /mnt/
ID 257 gen 192248 top level 5 path home
ID 258 gen 192228 top level 5 path usr
ID 259 gen 192226 top level 5 path tmp
ID 260 gen 192238 top level 5 path var
--

sudo btrfs-find-root /dev/sdb4
Super think's the tree root is at 647630274560, chunk root 647596376064
Well block 647629897728 seems great, but generation doesn't match,
have=192251, want=192253 level 1
Well block 647630012416 seems great, but generation doesn't match,
have=192251, want=192253 level 0
Well block 647630028800 seems great, but generation doesn't match,
have=192252, want=192253 level 1
Well block 647630110720 seems great, but generation doesn't match,
have=192249, want=192253 level 0
Well block 647630143488 seems great, but generation doesn't match,
have=192252, want=192253 level 0
Well block 647630159872 seems great, but generation doesn't match,
have=192252, want=192253 level 0
Well block 647630176256 seems great, but generation doesn't match,
have=192252, want=192253 level 0
Well block 647630192640 seems great, but generation doesn't match,
have=192252, want=192253 level 0
Well block 647630258176 seems great, but generation doesn't match,
have=192252, want=192253 level 0
Found tree root at 647630274560 gen 192253 level 1
--

sudo btrfs check /dev/sdb4
Checking filesystem on /dev/sdb4
UUID: fc429e82-f46e-4018-a9fa-ded688cef161
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 12173435 bytes used err is 0
total csum bytes: 0
total tree bytes: 376832
total fs tree bytes: 98304
total extent tree bytes: 49152
btree space waste bytes: 229409
file data blocks allocated: 44040192
 referenced 44040192
--

sudo btrfs-debug-tree -R /dev/sdb4
root tree: 647630274560 level 1
chunk tree: 647596376064 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 647630307328 level 1
device tree key (DEV_TREE ROOT_ITEM 0) 647630094336 level 1
fs tree key (FS_TREE ROOT_ITEM 0) 647730692096 level 0
checksum tree key (CSUM_TREE ROOT_ITEM 0) 647630422016 level 0
uuid tree key (UUID_TREE ROOT_ITEM 0) 647641219072 level 0
file tree key (257 ROOT_ITEM 0) 647629996032 level 0
file tree key (258 ROOT_ITEM 0) 647730413568 level 0
file tree key (259 ROOT_ITEM 0) 648013332480 level 0
file tree key (260 ROOT_ITEM 0) 647731609600 level 0
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 648438398976 level 0
btrfs root backup slot 0
        tree root gen 192252 block 647630028800
                extent root gen 192252 block 647630045184
                chunk root gen 191843 block 647596376064
                device root gen 192252 block 647630094336
                csum root gen 192252 block 647630225408
                fs root gen 192233 block 647730692096
                44417024 used 978736644096 total 2 devices
btrfs root backup slot 1
        tree root gen 192253 block 647630274560
                extent root gen 192253 block 647630307328
                chunk root gen 191843 block 647596376064
                device root gen 192252 block 647630094336
                csum root gen 192253 block 647630422016
                fs root gen 192233 block 647730692096
                44417024 used 978736644096 total 2 devices
btrfs root backup slot 2
        tree root gen 192244 block 647731642368
                extent root gen 192244 block 647731691520
                chunk root gen 191843 block 647596376064
                device root gen 192244 block 647731724288
                csum root gen 192244 block 647731789824
                fs root gen 192233 block 647730692096
                44695552 used 978736644096 total 2 devices
btrfs root backup slot 3
        tree root gen 192245 block 647737933824
                extent root gen 192245 block 647737950208
                chunk root gen 191843 block 647596376064
                device root gen 192244 block 647731724288
                csum root gen 192245 block 647738081280
                fs root gen 192233 block 647730692096
                44695552 used 978736644096 total 2 devices
total bytes 978736644096
bytes used 44417024
uuid fc429e82-f46e-4018-a9fa-ded688cef161
--

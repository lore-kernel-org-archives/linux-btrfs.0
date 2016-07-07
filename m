Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35032 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbcGGO3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 10:29:38 -0400
MIME-Version: 1.0
From: Anatoly Pugachev <matorola@gmail.com>
Date: Thu, 7 Jul 2016 17:29:35 +0300
Message-ID: <CADxRZqwhBoc9sNxxZ4a9ZJ0JiYWiL9xtG8T_ws4i61YrtNHtHg@mail.gmail.com>
Subject: btrfs module does not load on sparc64
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: sparclinux@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Compiled linux kernel (git version 4.7.0-rc6+) using my own kernel
config file, enabling :

CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y

and now I can't load btrfs module:

# modprobe btrfs
modprobe: ERROR: could not insert 'btrfs': Invalid argument


and in logs (and on console):

[1897399.942697] Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on
[1897400.024645] BTRFS: selftest: sectorsize: 8192  nodesize: 8192
[1897400.098089] BTRFS: selftest: Running btrfs free space cache tests
[1897400.175863] BTRFS: selftest: Running extent only tests
[1897400.241871] BTRFS: selftest: Running bitmap only tests
[1897400.307877] BTRFS: selftest: Running bitmap and extent tests
[1897400.380329] BTRFS: selftest: Running space stealing from bitmap to extent
[1897400.470517] BTRFS: selftest: Free space cache tests finished
[1897400.542875] BTRFS: selftest: Running extent buffer operation tests
[1897400.621710] BTRFS: selftest: Running btrfs_split_item tests
[1897400.692929] BTRFS: selftest: Running extent I/O tests
[1897400.757459] BTRFS: selftest: Running find delalloc tests
[1897401.082670] BTRFS: selftest: Running extent buffer bitmap tests
[1897401.161223] BTRFS: selftest: Setting straddling pages failed
[1897401.233661] BTRFS: selftest: Extent I/O tests finished


this is sparc64 sid/unstable debian:

# uname -a
Linux nvg5120 4.7.0-rc6+ #38 SMP Thu Jul 7 14:51:23 MSK 2016 sparc64 GNU/Linux

# getconf PAGESIZE
8192

PS: using btrfs-progs from kdave repo,
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git ,
i'm able to create fs, but unable to mount:

root@nvg5120:/home/mator/btrfs-progs# ./mkfs.btrfs -f /dev/vg1/vol1
btrfs-progs v4.6.1
See http://btrfs.wiki.kernel.org for more information.

WARNING: failed to open /dev/btrfs-control, skipping device
registration: No such device
Label:              (null)
UUID:               ddd8a268-62e5-444c-9baf-6ba1b2d4448b
Node size:          16384
Sector size:        8192
Filesystem size:    15.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.01GiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    15.00GiB  /dev/vg1/vol1


Can someone help please? Thanks.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward101p.mail.yandex.net ([77.88.28.101]:47416 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727043AbeH1C3y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 22:29:54 -0400
Received: from mxback19j.mail.yandex.net (mxback19j.mail.yandex.net [IPv6:2a02:6b8:0:1619::95])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 06D784E85346
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 01:33:44 +0300 (MSK)
To: linux-btrfs@vger.kernel.org
From: Tucker Boniface <tucker@boniface.tech>
Subject: btrfs-progs: btrfs-convert: unable to find block group for 0
Message-ID: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
Date: Mon, 27 Aug 2018 15:33:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I am trying to convert an ext4 partition to btrfs using 
btrfs-convert. I am running Arch Linux with kernel 4.18.5 and 
btrfs-progs 4.17.1. The full error is inline below.

-> # btrfs-convert /dev/sda1
create btrfs filesystem:
	blocksize: 4096
	nodesize:  16384
	features:  extref, skinny-metadata (default)
creating ext2 image file
Unable to find block group for 0
Unable to find block group for 0
Unable to find block group for 0
extent-tree.c:2743: alloc_tree_block: BUG_ON `ret` triggered, value -28
btrfs-convert(+0x1d512)[0x564d08cd3512]
btrfs-convert(btrfs_alloc_free_block+0x1e8)[0x564d08cda188]
btrfs-convert(+0x15bd1)[0x564d08ccbbd1]
btrfs-convert(btrfs_search_slot+0xf27)[0x564d08ccd7d7]
btrfs-convert(btrfs_csum_file_block+0x499)[0x564d08cdf219]
btrfs-convert(+0xe625)[0x564d08cc4625]
btrfs-convert(main+0x1abf)[0x564d08cc3adf]
/usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f1822576223]
btrfs-convert(_start+0x2e)[0x564d08cc41be]
Aborted

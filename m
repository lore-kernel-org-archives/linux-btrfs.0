Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-36-230.dynamic.qsc.de ([92.195.36.230]:56246 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLQXbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 18:31:53 -0500
Received: from [192.168.178.20] (unknown [192.168.178.20])
	by richtercloud.de (Postfix) with ESMTPSA id 0E9923160756
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 23:25:19 +0000 (UTC)
Message-ID: <549210D9.4060302@richtercloud.de>
Date: Thu, 18 Dec 2014 00:25:13 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "btrfs_reserve_extent: Assertion `ret` failed." during btrfsck --init-csum-tree
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi together,
after a btrfs was missing some csums and therefore remounted read-only,
I unmounted it and experienced

    $ sudo btrfsck --init-csum-tree /dev/sde1
    Creating a new CRC tree
    Checking filesystem on /dev/sde1
    UUID: bd6298ea-0748-45fe-87c8-eace6793ca89
    Reinit crc root
    extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
    btrfs check[0x43d6c1]
    btrfs check(btrfs_reserve_extent+0xb63)[0x443111]
    btrfs check(btrfs_alloc_free_block+0x5a)[0x44318c]
    btrfs check[0x436585]
    btrfs check(btrfs_search_slot+0x11d1)[0x4382fc]
    btrfs check(btrfs_csum_file_block+0x3ce)[0x4477cc]
    btrfs check(cmd_check+0xef2)[0x425ef5]
    btrfs check(main+0x15d)[0x40991d]
    /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f405dcf8ec5]
    btrfs check[0x4094d9]

with btrfs-progs 3.18-rc1 on Linux 3.17.6. What could that mean?

-Kalle

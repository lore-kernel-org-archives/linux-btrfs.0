Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56326 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcIIVh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 17:37:26 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id BADC1600A9
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Sep 2016 23:37:22 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: btrfstune -x -> extent-tree.c:2688: btrfs_reserve_extent: Assertion
 `ret` failed.
Message-ID: <478c1cee-80f0-c8f3-0bb9-c8c8932a9fb5@mendix.com>
Date: Fri, 9 Sep 2016 23:37:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While trying to enable skinny metadata on a filesystem, I got this error
(after minutes of reading from disk by the program):

-# btrfstune -x /dev/xvdb
extent-tree.c:2688: btrfs_reserve_extent: Assertion `ret` failed.
btrfstune[0x410ef6]
btrfstune[0x410f1d]
btrfstune(btrfs_reserve_extent+0x781)[0x41522e]
btrfstune(btrfs_alloc_free_block+0x63)[0x415413]
btrfstune(__btrfs_cow_block+0xfc)[0x409176]
btrfstune(btrfs_cow_block+0x8b)[0x409718]
btrfstune[0x40d8ad]
btrfstune(btrfs_commit_transaction+0xb8)[0x40f10d]
btrfstune(main+0x3b3)[0x407e31]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f945fa06700]
btrfstune(_start+0x29)[0x408509]

This is a ~40TiB filesystem that was created about one and a half year
ago, has grown from 1TiB to this size now and has always been running
with the Debian 3.16-ckt kernel.

# uname -a
Linux backups-dolly 4.7.0-1-amd64 #1 SMP Debian 4.7.2-1 (2016-08-28)
x86_64 GNU/Linux

# btrfs version
btrfs-progs v4.7.1

One of the things I already did earlier today was switching to
space_cache=v2

Does the shown error ring a bell? What's the next step to debug this?

The filesystem is a clone of the production filesystem (not btrfs clone,
but lower level, on iSCSI storage) meant to be used for upgrade-testing
and performance testing, so if anything goes wrong in whatever way,
there will be no panicing involved.

-- 
Hans van Kranenburg

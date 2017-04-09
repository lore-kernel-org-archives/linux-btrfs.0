Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.tu-berlin.de ([130.149.7.33]:21891 "EHLO mail.tu-berlin.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752511AbdDIRgQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Apr 2017 13:36:16 -0400
Received: from ex-mbx-09.tubit.win.tu-berlin.de ([130.149.6.163] helo=exchange.tu-berlin.de)
        by mail.tu-berlin.de (exim-4.84_2/mailfrontend-6) with esmtp
        for <linux-btrfs@vger.kernel.org>
        id 1cxGTE-0008D8-3f; Sun, 09 Apr 2017 19:17:49 +0200
Message-ID: <1491758260.15056.2.camel@campus.tu-berlin.de>
Subject: BTRFS not mountable, recover won't work
From: Malte Eggers <m.eggers@campus.tu-berlin.de>
To: <linux-btrfs@vger.kernel.org>
Date: Sun, 9 Apr 2017 19:17:40 +0200
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After suspending and waking up my laptop with the external hard drive
connected, I could no longer access the files on it. So I unmounted and
remounted it, only to discover that I could no longer mount it.


This is the error (mounting with usebackuproot, same error without):

[891667.002861] BTRFS info (device dm-0): trying to use backup root at
mount time
[891667.002870] BTRFS info (device dm-0): disk space caching is enabled
[891667.002876] BTRFS info (device dm-0): has skinny extents
[891667.016395] BTRFS error (device dm-0): parent transid verify failed
on 108855296 wanted 32139 found 32104
[891667.017181] BTRFS error (device dm-0): parent transid verify failed
on 108855296 wanted 32139 found 32104
[891667.017194] BTRFS error (device dm-0): failed to recover balance:
-5
[891667.078829] BTRFS error (device dm-0): open_ctree failed


btrfs restore and btrfs-find-root fail like this (on both debian sid
and fedora 25):

parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
Ignoring transid failure
volumes.c:1645: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs(+0x530d5)[0x5634cfb180d5]
btrfs(btrfs_chunk_readonly+0x5a)[0x5634cfb1a3b3]
btrfs(btrfs_read_block_groups+0x1dc)[0x5634cfb0fb0c]
btrfs(btrfs_setup_all_roots+0x336)[0x5634cfb0b158]
btrfs(+0x4654c)[0x5634cfb0b54c]
btrfs(open_ctree_fs_info+0xd7)[0x5634cfb0b673]
btrfs(cmd_restore+0x339)[0x5634cfaf93dc]
btrfs(main+0x12f)[0x5634cfadca6b]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f3f7161f2b1]
btrfs(_start+0x2a)[0x5634cfadcaaa]
Aborted


How would I go about recovering my Data?

Thanks,
Malte

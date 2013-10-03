Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63871 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3JCGZx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Oct 2013 02:25:53 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so838779ead.7
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 23:25:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 23:25:52 -0700
Message-ID: <CAEm3SNBnxThU5Beenc6hn+d+pDMF+w15E-jWoXucN+ekL12ZnA@mail.gmail.com>
Subject: Unable to suspend to memory while scrub running
From: Justin Husted <valentinej@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to suspend a computer running linux 3.11.1 while a scrub was
going, and I got this:

Oct  2 20:15:12 caper kernel: [ 1237.472716] PM: Preparing system for mem sleep
Oct  2 20:15:12 caper kernel: [ 1237.472856] Freezing user space processes ...
Oct  2 20:15:12 caper kernel: [ 1257.474848] Freezing of tasks failed
after 20.004 seconds (2 tasks refusing to freeze, wq_busy=0):
Oct  2 20:15:12 caper kernel: [ 1257.474947] btrfs           D
0000000000000000     0  4709      1 0x00000004
Oct  2 20:15:12 caper kernel: [ 1257.474951]  ffff8800888b9888
0000000000000002 ffff8800888b9888 0000000000000296
Oct  2 20:15:12 caper kernel: [ 1257.474953]  ffff8800888b9fd8
ffff8800888b9fd8 ffff8800888b9fd8 0000000000014580
Oct  2 20:15:12 caper kernel: [ 1257.474956]  ffffffff81c14440
ffff880134161770 ffff8800888b9898 ffff8800bf8f5300
Oct  2 20:15:12 caper kernel: [ 1257.474958] Call Trace:
Oct  2 20:15:12 caper kernel: [ 1257.474965]  [<ffffffff8172d3b9>]
schedule+0x29/0x70
Oct  2 20:15:12 caper kernel: [ 1257.474994]  [<ffffffffa014fa15>]
scrub_add_page_to_rd_bio+0x1e5/0x2d0 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.474999]  [<ffffffff81089ab0>] ?
add_wait_queue+0x60/0x60
Oct  2 20:15:12 caper kernel: [ 1257.475012]  [<ffffffffa0150b3c>]
scrub_pages+0x1fc/0x2a0 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475024]  [<ffffffffa0150f35>]
scrub_extent+0x115/0x230 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475036]  [<ffffffffa0151b01>]
scrub_stripe+0xab1/0xd30 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475046]  [<ffffffffa00d84c7>] ?
read_block_for_search.isra.47+0xa7/0x1d0 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475058]  [<ffffffffa0151ea3>]
scrub_chunk.isra.14+0x123/0x150 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475060]  [<ffffffff8172e7de>] ?
_raw_spin_lock+0xe/0x20
Oct  2 20:15:12 caper kernel: [ 1257.475072]  [<ffffffffa0152150>]
scrub_enumerate_chunks+0x280/0x5b0 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475075]  [<ffffffff81089a00>] ?
add_wait_queue_exclusive+0x10/0x60
Oct  2 20:15:12 caper kernel: [ 1257.475087]  [<ffffffffa0153378>]
btrfs_scrub_dev+0x1a8/0x520 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475099]  [<ffffffffa012c2b8>] ?
btrfs_ioctl_scrub+0x58/0x110 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475102]  [<ffffffff811d3018>] ?
__mnt_want_write+0x58/0x70
Oct  2 20:15:12 caper kernel: [ 1257.475104]  [<ffffffff811d30d1>] ?
__mnt_want_write_file+0x51/0x60
Oct  2 20:15:12 caper kernel: [ 1257.475116]  [<ffffffffa012c311>]
btrfs_ioctl_scrub+0xb1/0x110 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475129]  [<ffffffffa013128c>]
btrfs_ioctl+0x87c/0xa90 [btrfs]
Oct  2 20:15:12 caper kernel: [ 1257.475132]  [<ffffffff8109caf6>] ?
account_user_time+0xa6/0xc0
Oct  2 20:15:12 caper kernel: [ 1257.475134]  [<ffffffff8109d134>] ?
vtime_account_user+0x74/0x90
Oct  2 20:15:12 caper kernel: [ 1257.475136]  [<ffffffff811c5b7c>]
do_vfs_ioctl+0x7c/0x2f0
Oct  2 20:15:12 caper kernel: [ 1257.475140]  [<ffffffff810210a9>] ?
syscall_trace_enter+0x29/0x270
Oct  2 20:15:12 caper kernel: [ 1257.475141]  [<ffffffff811c5e81>]
SyS_ioctl+0x91/0xb0
Oct  2 20:15:12 caper kernel: [ 1257.475144]  [<ffffffff81737e2f>]
tracesys+0xe1/0xe6

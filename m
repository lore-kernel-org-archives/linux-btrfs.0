Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47611 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCGKzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 05:55:18 -0500
Received: by mail-ob0-f174.google.com with SMTP id wo20so3941979obc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 02:55:17 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Mar 2014 18:55:17 +0800
Message-ID: <CAMVG2stsU-5QpEKXT4qGLMqdW0TFZWeTEkJTZgFayqv-HOwuYg@mail.gmail.com>
Subject: 3.13.5 btrfs read() oops
From: Daniel J Blueman <daniel@quora.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With kernel 3.13.5 (Ubuntu mainline), when plugging in a (evidently
twitchy) USB3 stick with a BTRFS filesystem, I hit an oops in read()
[1].

Full dmesg output is at:
http://quora.org/2014/btrfs-oops.txt

Thanks,
  Daniel

-- [1]

IP: 0010:[<ffffffff8135eaf6>] [<ffffffff8135eaf6>] memcpy+0x6/0x110
RSP: 0018:ffff88025fa1b910 EFLAGS: 00010207
RAX: ffff88005c3d906e RBX: 000000000000027e RCX: 000000000000027e
RDX: 000000000000027e RSI: 0005080000000000 RDI: ffff88005c3d906e
RBP: ffff88025fa1b948 R08: 0000000000001000 R09: ffff88025fa1b918
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800560e6350
R13: 0000160000000000 R14: ffff88005c3d92ec R15: 000000000000027e
FS: 00007f9272f79700(0000) GS:ffff88026f3c0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9264010018 CR3: 000000025f79a000 CR4: 00000000001407e0
Stack:
 ffffffffa036401c 0000000000001000 ffff8800837f3800 ffff8801e041a000
 0000000000000000 ffff8800763df218 ffff880064c8c4c0 ffff88025fa1ba08
 ffffffffa0348f9c 0000000000000f18 0000000000000000 0000000000001000
Call Trace:
 [<ffffffffa036401c>] ? read_extent_buffer+0xbc/0x110 [btrfs]
 [<ffffffffa0348f9c>] btrfs_get_extent+0x91c/0x970 [btrfs]
 [<ffffffffa0360217>] __do_readpage+0x357/0x730 [btrfs]
 [<ffffffffa0348680>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
 [<ffffffffa0360972>] __extent_readpages.constprop.41+0x2a2/0x2c0 [btrfs]
 [<ffffffffa0348680>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
 [<ffffffffa03627f6>] extent_readpages+0x1b6/0x1c0 [btrfs]
 [<ffffffffa0348680>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
 [<ffffffff81192f03>] ? alloc_pages_current+0xa3/0x160
 [<ffffffffa03467df>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffff811578d9>] __do_page_cache_readahead+0x1b9/0x270
 [<ffffffff81157dd2>] ondemand_readahead+0x152/0x2a0
 [<ffffffff81157f51>] page_cache_sync_readahead+0x31/0x50
 [<ffffffff8114d655>] generic_file_aio_read+0x4c5/0x700
 [<ffffffff811b671a>] do_sync_read+0x5a/0x90
 [<ffffffff811b6db5>] vfs_read+0x95/0x160
 [<ffffffff811b78c9>] SyS_read+0x49/0xa0
 [<ffffffff81715bff>] tracesys+0xe1/0xe6
-- 
Daniel J Blueman

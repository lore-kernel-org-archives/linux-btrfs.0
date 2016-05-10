Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34921 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcEJXTX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 19:19:23 -0400
Received: by mail-io0-f194.google.com with SMTP id i75so3030867ioa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2016 16:19:23 -0700 (PDT)
Received: from zzz (c-24-7-245-123.hsd1.mn.comcast.net. [24.7.245.123])
        by smtp.gmail.com with ESMTPSA id b67sm1943158iob.33.2016.05.10.16.19.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 10 May 2016 16:19:22 -0700 (PDT)
Date: Tue, 10 May 2016 18:19:20 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: WARNING at fs/btrfs/inode.c:9261 btrfs_destroy_inode()
Message-ID: <20160510231920.GA938@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The following warning has been triggering for me since about v4.6-rc3:

	WARN_ON(BTRFS_I(inode)->csum_bytes);

On one machine the warning has occurred 657 times since v4.6-rc5.  On another it
has occurred 3 times since v4.6-rc3.  Both are now on v4.6-rc7, where I have
still observed the warning.  The warnings occur in groups, and do_unlinkat() and
evict() are always in the call stack.

Is this a known issue?  Here is the first occurrence:

Apr 17 10:31:19 zzz kernel: ------------[ cut here ]------------
Apr 17 10:31:19 zzz kernel: WARNING: CPU: 0 PID: 4092 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x23c/0x2b0
Apr 17 10:31:19 zzz kernel: Modules linked in: fuse vhost_net vhost tun bridge stp llc ccm iptable_filter iptable_nat nf_conntrack_ipv4 
Apr 17 10:31:19 zzz kernel: CPU: 0 PID: 4092 Comm: rm Tainted: G        W       4.6.0-rc3 #178
Apr 17 10:31:19 zzz kernel: Hardware name: Dell Inc. Inspiron 15-7568/0M5YMV, BIOS 01.00.00 08/07/2015
Apr 17 10:31:19 zzz kernel:  0000000000000286 0000000031dfd09a ffff8801b9277dc0 ffffffff813320d8
Apr 17 10:31:19 zzz kernel:  0000000000000000 0000000000000000 ffff8801b9277e00 ffffffff81074221
Apr 17 10:31:19 zzz kernel:  0000242d85cec000 ffff88019408c9a8 ffff88019408c9a8 ffff880085cec000
Apr 17 10:31:19 zzz kernel: Call Trace:
Apr 17 10:31:19 zzz kernel:  [<ffffffff813320d8>] dump_stack+0x4d/0x65
Apr 17 10:31:19 zzz kernel:  [<ffffffff81074221>] __warn+0xc1/0xe0
Apr 17 10:31:19 zzz kernel:  [<ffffffff81074348>] warn_slowpath_null+0x18/0x20
Apr 17 10:31:19 zzz kernel:  [<ffffffff8126e77c>] btrfs_destroy_inode+0x23c/0x2b0
Apr 17 10:31:19 zzz kernel:  [<ffffffff81185296>] destroy_inode+0x36/0x60
Apr 17 10:31:19 zzz kernel:  [<ffffffff811853e4>] evict+0x124/0x180
Apr 17 10:31:19 zzz kernel:  [<ffffffff81185b68>] iput+0x148/0x1d0
Apr 17 10:31:19 zzz kernel:  [<ffffffff8117b884>] do_unlinkat+0x194/0x2b0
Apr 17 10:31:19 zzz kernel:  [<ffffffff8117c0e6>] SyS_unlinkat+0x16/0x30
Apr 17 10:31:19 zzz kernel:  [<ffffffff817031db>] entry_SYSCALL_64_fastpath+0x13/0x8f
Apr 17 10:31:19 zzz kernel: ---[ end trace 87f6a0e10f4df484 ]---

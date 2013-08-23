Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:60959 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3HWAkT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 20:40:19 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 8BBD38004F
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 17:40:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 673B78004F
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 17:40:18 -0700 (PDT)
Date: Thu, 22 Aug 2013 17:40:18 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: bad unlock balance in btrfs_commit_transaction_async
Message-ID: <alpine.DEB.2.00.1308221731350.2577@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just noticed that there is a locking imbalance warning with sb_internal 
in the transaction commit code.  I believe this has only started appearing 
recently (after I merged -rc5 into my testing tree), but I'm working on 
confirming that. The error is

<4>[27034.835134] =====================================
<4>[27034.839854] [ BUG: bad unlock balance detected! ]
<4>[27034.844576] 3.11.0-rc5-ceph-00061-g546140d #1 Not tainted
<4>[27034.849992] -------------------------------------
<4>[27034.854713] ceph-osd/30797 is trying to release lock (sb_internal) at:
<4>[27034.861304] [<ffffffffa0148fd8>] btrfs_commit_transaction_async+0x1c8/0x2c0 [btrfs]
<4>[27034.868994] but there are no more locks to release!
<4>[27034.873887] 
<4>[27034.873887] other info that might help us debug this:
<4>[27034.880448] no locks held by ceph-osd/30797.
<4>[27034.884733] 
<4>[27034.884733] stack backtrace:
<4>[27034.889123] CPU: 0 PID: 30797 Comm: ceph-osd Not tainted 3.11.0-rc5-ceph-00061-g546140d #1
<4>[27034.897421] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
<4>[27034.904938]  ffffffffa0148fd8 ffff88020baf9c68 ffffffff81642d85 0000000000000007
<4>[27034.912411]  ffff88021b32deb0 ffff88020baf9c98 ffffffff810ab89e ffff88020cff8000
<4>[27034.919883]  0000000000000246 ffff88020aaeddd0 ffffffffa0148fd8 ffff88020baf9ce8
<4>[27034.927358] Call Trace:
<4>[27034.929836]  [<ffffffffa0148fd8>] ? btrfs_commit_transaction_async+0x1c8/0x2c0 [btrfs]
<4>[27034.937790]  [<ffffffff81642d85>] dump_stack+0x46/0x58
<4>[27034.942951]  [<ffffffff810ab89e>] print_unlock_imbalance_bug+0xfe/0x110
<4>[27034.949599]  [<ffffffffa0148fd8>] ? btrfs_commit_transaction_async+0x1c8/0x2c0 [btrfs]
<4>[27034.957552]  [<ffffffff810aeafe>] lock_release+0x15e/0x220
<4>[27034.963069]  [<ffffffffa0148fff>] btrfs_commit_transaction_async+0x1ef/0x2c0 [btrfs]
<4>[27034.970850]  [<ffffffff810af6f5>] ? trace_hardirqs_on_caller+0x105/0x1d0
<4>[27034.977587]  [<ffffffffa0177907>] btrfs_ioctl_start_sync+0x47/0xc0 [btrfs]
<4>[27034.984499]  [<ffffffffa017c575>] btrfs_ioctl+0xe55/0x1af0 [btrfs]
<4>[27034.990700]  [<ffffffff8164ab2b>] ? _raw_spin_unlock+0x2b/0x40
<4>[27034.996552]  [<ffffffff810b40b5>] ? do_futex+0xa45/0xbb0
<4>[27035.001885]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
<4>[27035.007302]  [<ffffffff811922a6>] do_vfs_ioctl+0x96/0x560
<4>[27035.012720]  [<ffffffff8119cf6e>] ? fget_light+0x9e/0x130
<4>[27035.018137]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
<4>[27035.023556]  [<ffffffff81192801>] SyS_ioctl+0x91/0xb0
<4>[27035.028628]  [<ffffffff813338fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
<4>[27035.035089]  [<ffffffff81653782>] system_call_fastpath+0x16/0x1b

This is presumably some breakage in the freeze locking dance that goes on 
with async commits (btrfs_commit_transaction_async caller takes the freeze 
semaphore, do_async_commit releases it), but it's not obvious to me what 
broke yet.  Unless this rings any bells for anyone, I'll go ahead and 
bisect.

Thanks!
sage

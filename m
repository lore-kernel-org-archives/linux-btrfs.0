Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:37557 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab3AVTvz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 14:51:55 -0500
Date: Tue, 22 Jan 2013 11:51:54 -0800
From: Zach Brown <zab@zabbo.net>
To: Piotr Nowojski <piotr.nowojski@adocean-global.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS deadlock (btrfs_join_transaction?)
Message-ID: <20130122195154.GB14246@lenny.home.zabbo.net>
References: <50FEC3B5.1040100@adocean-global.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FEC3B5.1040100@adocean-global.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> kernel: 3.7.2 from kernel.org

> [14501.689372] BUG: soft lockup - CPU#2 stuck for 22s!
> [14501.689446] CPU 2
> [14501.689452] Pid: 29021, comm: btrfs-delayed-m Not tainted
> 3.7.2-custom2 #1 Intel Corporation S2600IP/S2600IP
> [14501.689455] RIP: 0010:[<ffffffff81044ab5>] [<ffffffff81044ab5>]
> __ticket_spin_lock+0x25/0x30

So stuck spinning on a spinlock.

> [14501.689523] Call Trace:
> [14501.689533]  [<ffffffff816a0b6e>] _raw_spin_lock+0xe/0x20
> [14501.689560]  [<ffffffffa018db85>] join_transaction.isra.26+0x25/0x370 [btrfs]

Probably the first trans_lock in join_transaction().

> exact same message repeats 28 seconds later, and then it is followed
> by: pastebin.com/349ikn0c

All 16 cpus have traces in that dump and only this stuck CPU's seems
interesting. 

> Any ideas?

It doesn't look like there's any easy answers in the code: no unbalanced
lock and unlocks and nothing scary done while holding the lock.  (Some
list traversal, but the traces don't show another cpu stuck spinning on
a corrupt list).

If I had to guess, I'd guess that the lock got corrupted somehow.  Maybe
a race that has delayed work run on a freed structure.

Would it be possible to enable some debugging options in the kernel
you're building?   DEBUG_LIST, DEBUG_SPINLOCK, and the various lockdep
options (DEBUG_LOCKDEP, PROVE_LOCKING) might raise an alarm that would
shed some light.  Hopefully they wouldn't be unusably slow.

- z

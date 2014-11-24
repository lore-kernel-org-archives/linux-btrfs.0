Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:37308 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKXAX2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 19:23:28 -0500
Message-ID: <1416788595.4998.5.camel@kernel.crashing.org>
Subject: Re: [GIT PULL] Btrfs deadlock fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Mason <clm@fb.com>
Cc: torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 11:23:15 +1100
In-Reply-To: <20141123151439.GA16816@ret.masoncoding.com>
References: <20141123151439.GA16816@ret.masoncoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2014-11-23 at 10:14 -0500, Chris Mason wrote:
> Hi Linus,
> 
> My for-linus branch:

Not sure if this is related, but with -rc4, on this ppc64el box, when
grub updates (it starts trying to mount everything under the sun with
every filesystem), the box hangs with:

[  177.344522] INFO: rcu_sched detected stalls on CPUs/tasks: { 8}
(detected by 9, t=25883 jiffies, g=3642, c=3641, q=5206)

With xmon I can catch it with this backtrace:

[link register   ] d00000000ecec3f8 test_check_exists+0x1f8/0x280 [btrfs]
[c000000f0cc63930] d00000000ecec2b0 test_check_exists+0xb0/0x280 [btrfs] (unreliable)
[c000000f0cc63990] d00000000ed2a4b4 btrfs_test_free_space_cache+0x774/0x1150 [btrfs]
[c000000f0cc63a20] d00000000ed30f04 init_btrfs_fs+0x11c/0x210 [btrfs]
[c000000f0cc63a90] c00000000000b4dc do_one_initcall+0x12c/0x280
[c000000f0cc63b60] c0000000001628b8 load_module+0x2088/0x2970
[c000000f0cc63d50] c0000000001633d0 SyS_finit_module+0xc0/0x120
[c000000f0cc63e30] c00000000000927c syscall_exit+0x0/0x7c
--- Exception: c01 (System Call) at 00003fff88697184

Note that afaik there isn't any btrfs partition on any disk on that
machine... well not that I know of :)

Cheers,
Ben.

> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> Has a fix for a long standing deadlock that we've been trying to nail
> down for a while.  It ended up being a bad interaction with the fair
> reader/writer locks and the order btrfs reacquires locks in the btree.
> 
> Chris Mason (1) commits (+25/-15):
>     btrfs: fix lockups from btrfs_clear_path_blocking
> 
> Total: (1) commits (+25/-15)
> 
>  fs/btrfs/ctree.c   | 14 ++------------
>  fs/btrfs/locking.c | 24 +++++++++++++++++++++---
>  fs/btrfs/locking.h |  2 ++
>  3 files changed, 25 insertions(+), 15 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



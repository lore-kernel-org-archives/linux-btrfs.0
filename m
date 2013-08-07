Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab3HGSwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 14:52:36 -0400
Date: Wed, 7 Aug 2013 11:52:35 -0700
From: Zach Brown <zab@redhat.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem "hang" after page allocation failure: order:0 +
 kernel BUG at fs/btrfs/extent_io.c:4151
Message-ID: <20130807185235.GS12314@lenny.home.zabbo.net>
References: <20130808021705.1dcb139e@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130808021705.1dcb139e@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 02:17:05AM +0800, Tomasz Chmielewski wrote:
> One of btrfs filesystems hanged on my server.

Yeah, that's the consequence of using BUG_ON() for error handling.  It
forcefully tears down the task that executes it without returning back
up the stack.  Any locks that are held by callers are locked forever.

$ egrep 'BUG_ON.*(ret|ENOMEM|![a-z]*\))' fs/btrfs/*.c | wc -l
195

> root      2397  0.6  0.0      0     0 ?        D    Aug05  19:17 [btrfs-transacti]
> root     12293  2.9  0.1  41512 34344 pts/17   D+   Aug06  68:43 rm -rfv really-lots-of-different-files/
> root     26613  0.0  0.0      0     0 ?        D    06:08   0:00 [btrfs-flush_del]
> root     27256  0.0  0.0  17752   300 pts/18   D+   06:29   0:00 btrfs subvolume snapshot -r /mnt/lxc1/test/latest /mnt/lxc1/test/2013-08-07-06:18:49
> root     27257  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]
> root     27258  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]
> root     27259  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]

A dump of these stacks could satisfy the curiousity of knowing just
which locks happened to be left locked by the task that BUG_ON torn
down.  But it's not really needed.  We know the root cause: BUG_ON().
Every use in btrfs is a bug.

> [137328.086287] btrfs-endio-wri: page allocation failure: order:0, mode:0x20

0x20 == GFP_ATOMIC: an allocation that can't sleep so it can't wait for
more memory to be freed when there is none so it does return failure.

> [137328.087051]  [<ffffffffa07212a6>] btrfs_clone_extent_buffer+0x53/0xc3 [btrfs]

                p = alloc_page(GFP_ATOMIC);
                BUG_ON(!p);

815a51c74 (Jan Schmidt        2012-05-16 17:00:02 +0200 4192) p = alloc_page(GFP_ATOMIC);
815a51c74 (Jan Schmidt        2012-05-16 17:00:02 +0200 4193) BUG_ON(!p);

- z

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729643AbeGMPBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 11:01:41 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4A358AE78
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 14:46:43 +0000 (UTC)
Date: Fri, 13 Jul 2018 16:46:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
Message-ID: <20180713144638.GY3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
 <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 10:36:42PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月13日 22:34, David Sterba wrote:
> > On Thu, Jul 12, 2018 at 02:19:07PM +0800, Qu Wenruo wrote:
> >> Introduce a new macro based compile time check for ioctl structures.
> >>
> >> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
> >> VMMDEV_ASSERT_SIZE().
> > 
> > The macro should be generic, there's nothing specific to btrfs. There's
> > a similar one in the progs.
> > 
> >> Such check is only added to structure pended to power of 2.
> > 
> > There's no constraint about power of 2 sizes, it works for any size.
> 
> While some structure doesn't do padding at all, and it looks like they
> may get expanded later.
> Do we really need to limit the size right now?

The size of an ioctl structure is part of kernel<->userspace API and
must not change once public. The ioctl number is calculated using the
structure size.

> >> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
> >> well.
> >> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_STATS
> >> ioctls to one").
> > 
> > Yeah, that was an oversight, so the correct value to check against is
> > 1024 + 8 = 1032, see ioctl.h in progs.
> 
> Can't we just revert to 1024?

Answered by the above, we absolutely cannot change the numbers now.

> That plus 8 doesn't really look well, and shrink the size shouldn't
> bring any problem AFAIK.

See

https://elixir.bootlin.com/linux/latest/source/include/uapi/asm-generic/ioctl.h#L88

for _IOWR definition,

btrfs-progs:ioctl.h

817 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
818                                       struct btrfs_ioctl_get_dev_stats)

kernel:fs/btrfs/ioctl.c

5914         case BTRFS_IOC_GET_DEV_STATS:
5915                 return btrfs_ioctl_get_dev_stats(fs_info, argp);

The values must match, otherwise dev stats will randomly break on
old/new kernel and progs combinations.

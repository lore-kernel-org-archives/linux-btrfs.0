Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729644AbeGMOtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 10:49:18 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F9F8ACED
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 14:34:23 +0000 (UTC)
Date: Fri, 13 Jul 2018 16:34:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
Message-ID: <20180713143418.GW3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180712061907.24783-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180712061907.24783-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 02:19:07PM +0800, Qu Wenruo wrote:
> Introduce a new macro based compile time check for ioctl structures.
> 
> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
> VMMDEV_ASSERT_SIZE().

The macro should be generic, there's nothing specific to btrfs. There's
a similar one in the progs.

> Such check is only added to structure pended to power of 2.

There's no constraint about power of 2 sizes, it works for any size.

> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
> well.
> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_STATS
> ioctls to one").

Yeah, that was an oversight, so the correct value to check against is
1024 + 8 = 1032, see ioctl.h in progs.

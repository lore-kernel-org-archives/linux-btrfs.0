Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3H2MpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 08:45:11 -0400
Date: Thu, 29 Aug 2013 14:45:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
Message-ID: <20130829124510.GH23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377755258-2722-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377755258-2722-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 01:47:38PM +0800, Miao Xie wrote:
> By the current code, if the requested size is very large, and all the extents
> in the free space cache are small, we will waste lots of the cpu time to cut
> the requested size in half and search the cache again and again until it gets
> down to the size the allocator can return. In fact, we can know the max extent
> size in the cache after the first search, so we needn't cut the size in half
> repeatedly, and just use the max extent size directly. This way can save
> lots of cpu time and make the performance grow up when there are only fragments
> in the free space cache.
> 
> According to my test, if there are only 4KB free space extents in the fs,
> and the total size of those extents are 256MB, we can reduce the execute
> time of the following test from 5.4s to 1.4s.
>   dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync

Sounds like a good improvement! Can you please post the test? Fragmented
free space is nothing uncommon, so I guess aging the filesystem for a
while works as well and there the improvement would show up in reduced
cpu time.

Patch looks ok.

david

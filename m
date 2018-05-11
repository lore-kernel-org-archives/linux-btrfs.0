Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbeEKPZm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 11:25:42 -0400
Date: Fri, 11 May 2018 17:22:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V3 0/3] Btrfs: btrfs_dedupe_file_range() ioctl, remove
 16MiB restriction
Message-ID: <20180511152258.GB6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180502051538.26432-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180502051538.26432-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 08:15:35AM +0300, Timofey Titovets wrote:
> At now btrfs_dedupe_file_range() restricted to 16MiB range for
> limit locking time and memory requirement for dedup ioctl()
> 
> For too big input range code silently set range to 16MiB
> 
> Let's remove that restriction by do iterating over dedup range.
> That's backward compatible and will not change anything for request
> less then 16MiB.
> 
> Changes:
>   v1 -> v2:
>     - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
>     - Store memory of pages array between iterations
>     - Lock inodes once, not on each iteration
>     - Small inplace cleanups
>   v2 -> v3:
>     - Split to several patches
> 
> Timofey Titovets (3):
>   Btrfs: split btrfs_extent_same() for simplification
>   Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
>   Btrfs: btrfs_extent_same() reuse cmp workspace

Looks good to me, thanks. I'll edit the changlogs a bit and add the
patches to 4.18 queue.

In the original code there's kcalloc for the array holding the page
pointers. This can grow up to 32kb if the full 16MiB range is used so
I'll add a patch that'll use kvmalloc (the vmalloc fallback) in case
there's no 32kib of contiguous memory.

IIRC the 16M limit is mentioned in manual pages, so this would need to
be fixed and documented how this is going to behave.

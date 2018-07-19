Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727584AbeGSMrJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:47:09 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8324CAD6F
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 12:04:17 +0000 (UTC)
Subject: Re: [PATCH 0/7] Structure and callback cleanups
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1531996240.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aab413e4-b3ab-e3d2-3d09-6572f9c6fbd5@suse.com>
Date: Thu, 19 Jul 2018 15:04:16 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.07.2018 14:05, David Sterba wrote:
> A handful of removed structure members that are not used,
> async_submit_bio is down by 16 bytes and async_cow by 8.
> 
> Some of the extent_io_ops callbacks are unnecessarily called indirectly.
> The rest of extent_io_ops is going to be transformed in following
> series.
> 
> David Sterba (7):
>   btrfs: remove unused member async_submit_bio::fs_info
>   btrfs: remove unused member async_submit_bio::bio_flags
>   btrfs: remove redundant member async_cow::root
>   btrfs: unify end_io callbacks of async_submit_bio
>   btrfs: drop extent_io_ops::tree_fs_info callback
>   btrfs: drop extent_io_ops::merge_bio_hook callback
>   btrfs: drop extent_io_ops::set_range_writeback callback
> 
>  fs/btrfs/compression.c | 10 +++-------
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/disk-io.c     | 42 +++---------------------------------------
>  fs/btrfs/disk-io.h     |  5 +++--
>  fs/btrfs/extent_io.c   | 28 +++++++---------------------
>  fs/btrfs/extent_io.h   |  8 --------
>  fs/btrfs/inode.c       | 32 ++++++++------------------------
>  7 files changed, 25 insertions(+), 102 deletions(-)
> 

For the whole series (apart from my comments on 6/7):

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

I'm guessing this will alleviate some of the performance hit stemming
from  spectre/meltdown mitigations.

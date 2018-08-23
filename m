Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbeHWOzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 10:55:23 -0400
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <18c54f58-26d2-6e69-2b60-ab8f9bcb52d2@suse.com>
Date: Thu, 23 Aug 2018 14:26:04 +0300
MIME-Version: 1.0
In-Reply-To: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.08.2018 22:51, Liu Bo wrote:
> Several structs in btrfs are using rb_first() in a while loop, it'd be
> more efficient to do this with rb_first_cached() which has the O(1)
> complexity.
> 
> This patch set updates five structs which may have a large rb tree in
> practice
> 
> Liu Bo (5):
>   Btrfs: href_root: use rb_first_cached
>   Btrfs: href->ref_tree: use rb_first_cached
>   Btrfs: delayed_items: use rb_first_cached
>   Btrfs: extent_map: use rb_first_cached
>   Btrfs: preftree: use rb_first_cached
> 
>  fs/btrfs/backref.c                | 34 +++++++++++++-------------
>  fs/btrfs/delayed-inode.c          | 29 +++++++++++++----------
>  fs/btrfs/delayed-inode.h          |  4 ++--
>  fs/btrfs/delayed-ref.c            | 50 +++++++++++++++++++++++----------------
>  fs/btrfs/delayed-ref.h            |  4 ++--
>  fs/btrfs/disk-io.c                |  8 +++----
>  fs/btrfs/extent-tree.c            | 19 ++++++++-------
>  fs/btrfs/extent_map.c             | 27 +++++++++++----------
>  fs/btrfs/extent_map.h             |  2 +-
>  fs/btrfs/inode.c                  |  4 ++--
>  fs/btrfs/tests/extent-map-tests.c |  4 ++--
>  fs/btrfs/transaction.c            |  5 ++--
>  fs/btrfs/volumes.c                |  5 ++--
>  13 files changed, 107 insertions(+), 88 deletions(-)
> 

Do you have any performance data proving this is in fact helping?

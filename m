Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbeFHNuQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 09:50:16 -0400
Subject: Re: [PATCH 00/15] Add delayed-refs support to btrfs-progs
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e5b7b849-7d31-b563-0285-919b5732fc04@gmx.com>
Date: Fri, 8 Jun 2018 21:50:04 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> Hello,                                                                          
>                                                                                 
> Here is a series which adds support for delayed refs. This is needed to enable  
> later work on adding freespace tree repair code.

Would it be possible to explain this in details?
Personally speaking, I'd like to avoid introducing complex delayed-ref
into btrfs-progs if possible.

And in my (possibly wrong) understanding, the main purpose of
delayed-ref is to reduce the race on extent tree, thus to improve
performance.
However in btrfs-progs, it's the least important aspect.

So extra comment on this is appreciated.

Thanks,
Qu

> Additionally, it results in  
> more code sharing between kernel/user space.
> 
> Patches 1-9 are simple prep patches removing some arguments, causing problems
> later. They can go independently of the delayed refs work. They don't introduce
> any functional changes. Next, patches 10-13 introduce the needed infrastructure
> to for delayed refs without actually activating it. Patch 14 finally wires it
> up by adding the necessary call outs to btrfs_run_delayed refs and reworking the
> extent addition/freeing functions. With all of this done, patch 15 finally
> removes the old code.
> 
> This series passes all btrfs progs fsck and misc tests + fuzz tests apart from
> fuzz-003/007/009 - but those fail without this series so it's unlikely it's
> caused by it.
> 
> Nikolay Borisov (15):
>   btrfs-progs: Remove root argument from pin_down_bytes
>   btrfs-progs: Remove root argument from btrfs_del_csums
>   btrfs-progs: Add functions to modify the used space by a root
>   btrfs-progs: Refactor the root used bytes are updated
>   btrfs-progs: Make update_block_group take fs_info instead of root
>   btrfs-progs: check: Drop trans/root arguments from free_extent_hook
>   btrfs-progs: Remove root argument from __free_extent
>   btrfs-progs: Remove root argument from alloc_reserved_tree_block
>   btrfs-progs: Always pass 0 for offset when calling btrfs_free_extent
>     for btree blocks.
>   btrfs-progs: Add boolean to signal whether we are re-initing extent
>     tree
>   btrfs-progs: Add delayed refs infrastructure
>   btrfs-progs: Add __free_extent2 function
>   btrfs-progs: Add alloc_reserved_tree_block2 function
>   btrfs-progs: Wire up delayed refs
>   btrfs-progs: Remove old delayed refs infrastructure
> 
>  Makefile              |   3 +-
>  btrfs-corrupt-block.c |   2 +-
>  check/main.c          |   8 +-
>  ctree.c               |  29 ++-
>  ctree.h               |  11 +-
>  delayed-ref.c         | 608 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  delayed-ref.h         | 225 +++++++++++++++++++
>  extent-tree.c         | 604 +++++++++++++++++++++++++++++--------------------
>  file-item.c           |  20 +-
>  kerncompat.h          |   8 +
>  transaction.c         |  25 +++
>  transaction.h         |   5 +
>  12 files changed, 1280 insertions(+), 268 deletions(-)
>  create mode 100644 delayed-ref.c
>  create mode 100644 delayed-ref.h
> 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727595AbeGPQID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 12:08:03 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E9F5AED4
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:40:03 +0000 (UTC)
Date: Mon, 16 Jul 2018 17:39:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] Add delayed-refs support to btrfs-progs
Message-ID: <20180716153956.GL3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 08, 2018 at 03:47:43PM +0300, Nikolay Borisov wrote:
> Hello,                                                                          
>                                                                                 
> Here is a series which adds support for delayed refs. This is needed to enable  
> later work on adding freespace tree repair code. Additionally, it results in  
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

Added to devel. There were some patch-to-patch compilation issues,
function alloc_reserved_tree_block2 used earlier than defined so I
reordered the patches to fix that.

The CI fails at test check/020-extent-ref-cases but it works on my
machine so it's not caused by the patchset.

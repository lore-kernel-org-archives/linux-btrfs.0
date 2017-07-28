Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751991AbdG1Ozv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 10:55:51 -0400
Date: Fri, 28 Jul 2017 16:54:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v3 00/13] use rbtrees for preliminary backrefs
Message-ID: <20170728145433.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712222011.26705-1-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712222011.26705-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:20:05PM -0600, Edmund Nadolski wrote:
> This patch series attempts to improve the performance of backref
> searches by changing the prelim_refs implementation to use
> rbtrees instead of lists.  This also aims to reduce the soft
> lockup occurences that can result when a backref search consumes
> too much cpu time.
> 
> Test runs of btrfs/130 show an improvement in the overall
> run time of the test (shown below in seconds) as a function of
> the number of extents:
> 
>     nr_extents:    256    512    640    1024     2048
>     ------------+-------+-----+-------+-------+------
>      unpatched:     20    186    375    2204    40419
>        patched:     12     93    203    1060    22007
> 
> (Note, the current default value for nr_extents in btrfs/130 is
> 4096, which takes a very long time to complete.)
> 
> Changes for v3:
> 
> Patch 08/13:
>  - Update changelog and comments for third rbtree.
>  - Fixed issue in resolve_indirect_refs() which prevented
>    module load when sanity checking was enabled.
> 
> Patch 10/13:
>  - Fix TP_printk_btrfs format string per coding standards.
> 
> Changes for v2:
> 
> Patch 06/13:
>  - Added changelog description.
> 
> Patch 07/13:
>  - Updated changelog description.
>  - Removed 'TODO' comment.
> 
> Patch 08/13:
>  - Added code for proper iteration of missing keys. This adds
>    a third rbtree (.indirect_missing_keys in struct preftrees)
>    plus the requisite code in add_prelim_ref(), add_missing_keys(),
>    resolve_indirect_refs(), and find_parent_nodes().
>  - Rename release_pref() to free_pref().
>  - Replace WARN() with BUG_ON().
>  - Remove 'TODO' comments and the unused 'merge_mode' enum.
> 
> The other patches have no functional changes. Some have diff
> context changes due to the above modifications.
> 
> Edmund Nadolski (6):
>   btrfs: btrfs_check_shared should manage its own transaction
>   btrfs: remove ref_tree implementation from backref.c
>   btrfs: convert prelimary reference tracking to use rbtrees
>   btrfs: add cond_resched() calls when resolving backrefs
>   btrfs: allow backref search checks for shared extents
>   btrfs: clean up extraneous computations in add_delayed_refs
> 
> Jeff Mahoney (7):
>   btrfs: struct-funcs, constify readers
>   btrfs: constify tracepoint arguments
>   btrfs: backref, constify some arguments
>   btrfs: backref, add unode_aux_to_inode_list helper
>   btrfs: backref, cleanup __ namespace abuse
>   btrfs: add a node counter to each of the rbtrees
>   btrfs: backref, add tracepoints for prelim_ref insertion and merging

FYI, the whole patchset is now queued for 4.14. It's been in for-next
for a long time and I haven't seen any problems related to it.

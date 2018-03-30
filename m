Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750764AbeC3HBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 03:01:52 -0400
Date: Fri, 30 Mar 2018 15:01:46 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] btrfs-progs: extent buffer related refactor and
 cleanup
Message-ID: <20180330070146.GC548@fnst.localdomain>
References: <20180330054857.6106-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 01:48:52PM +0800, Qu Wenruo wrote:
>The patchset can be fetched from github:
>https://github.com/adam900710/btrfs-progs/tree/eb_cleanup
>
>Just like kernel cleanup and refactors, this patchset will embed
>btrfs_fs_info structure into extent_buffer.
>
>And fixes several possible NULL pointer dereference (although not
>utilized in btrfs-progs yet).
>
>Changelog:
>v2:
>  Embarrassingly, I forgot to install reiserfsprogs in my development
>  machine, so the 3rd patch lacks one call site in
>  convert/source-reiserfs.c.
>
>Qu Wenruo (5):
>  btrfs-progs: extent_io: Fix NULL pointer dereference in
>    free_extent_buffer_final()
>  btrfs-progs: extent_io: Init eb->lru to avoid NULL pointer dereference
>  btrfs-progs: extent_io: Refactor alloc_extent_buffer() to follow
>    kernel parameters
>  btrfs-progs: Unify btrfs_leaf_free_psace() parameter with kernel
>  btrfs-progs: print-tree: Remove btrfs_root parameter

The patchset looks good to me.

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

>
> btrfs-corrupt-block.c     |  2 +-
> check/main.c              |  2 +-
> check/mode-lowmem.c       |  2 +-
> cmds-inspect-dump-tree.c  | 31 ++++++++++------------
> convert/source-reiserfs.c |  3 +--
> ctree.c                   | 65 +++++++++++++++++++++++++----------------------
> ctree.h                   |  3 ++-
> disk-io.c                 |  3 +--
> extent-tree.c             |  8 +++---
> extent_io.c               | 17 ++++++++-----
> extent_io.h               |  3 ++-
> print-tree.c              | 20 ++++++++-------
> print-tree.h              |  4 +--
> 13 files changed, 85 insertions(+), 78 deletions(-)
>
>-- 
>2.16.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-- 
Thanks,
Lu



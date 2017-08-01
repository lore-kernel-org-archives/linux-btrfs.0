Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:59548 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751496AbdHARub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 13:50:31 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
Date: Tue, 1 Aug 2017 19:42:14 +0200
MIME-Version: 1.0
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

On 2017-08-01 18:14, Liu Bo wrote:
> This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> separate disk as a journal (aka raid5/6 log), so that after unclean
> shutdown we can make sure data and parity are consistent on the raid
> array by replaying the journal.
> 

it would be possible to have more information ?
- what is logged ? data, parity or data + parity ?
- in the past I thought that it would be sufficient to log only the stripe position involved by a RMW cycle, and then start a scrub on these stripes in case of an unclean shutdown: do you think that it is feasible ?
- does this journal disk also host other btrfs log ?

> The idea and the code are similar to the write-through mode of md
> raid5-cache, so ppl(partial parity log) is also feasible to implement.
> (If you've been familiar with md, you may find this patch set is
> boring to read...)
> 
> Patch 1-3 are about adding a log disk, patch 5-8 are the main part of
> the implementation, the rest patches are improvements and bugfixes,
> eg. readahead for recovery, checksum.
> 
> Two btrfs-progs patches are required to play with this patch set, one
> is to enhance 'btrfs device add' to add a disk as raid5/6 log with the
> option '-L', the other is to teach 'btrfs-show-super' to show
> %journal_tail.
> 
> This is currently based on 4.12-rc3.
> 
> The patch set is tagged with RFC, and comments are always welcome,
> thanks.
> 
> Known limitations:
> - Deleting a log device is not implemented yet.
> 
> 
> Liu Bo (14):
>   Btrfs: raid56: add raid56 log via add_dev v2 ioctl
>   Btrfs: raid56: do not allocate chunk on raid56 log
>   Btrfs: raid56: detect raid56 log on mount
>   Btrfs: raid56: add verbose debug
>   Btrfs: raid56: add stripe log for raid5/6
>   Btrfs: raid56: add reclaim support
>   Btrfs: raid56: load r5log
>   Btrfs: raid56: log recovery
>   Btrfs: raid56: add readahead for recovery
>   Btrfs: raid56: use the readahead helper to get page
>   Btrfs: raid56: add csum support
>   Btrfs: raid56: fix error handling while adding a log device
>   Btrfs: raid56: initialize raid5/6 log after adding it
>   Btrfs: raid56: maintain IO order on raid5/6 log
> 
>  fs/btrfs/ctree.h                |   16 +-
>  fs/btrfs/disk-io.c              |   16 +
>  fs/btrfs/ioctl.c                |   48 +-
>  fs/btrfs/raid56.c               | 1429 ++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/raid56.h               |   82 +++
>  fs/btrfs/transaction.c          |    2 +
>  fs/btrfs/volumes.c              |   56 +-
>  fs/btrfs/volumes.h              |    7 +-
>  include/uapi/linux/btrfs.h      |    3 +
>  include/uapi/linux/btrfs_tree.h |    4 +
>  10 files changed, 1487 insertions(+), 176 deletions(-)
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

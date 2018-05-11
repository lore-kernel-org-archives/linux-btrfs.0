Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36113 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbeEKJxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:53:39 -0400
Subject: Re: [PATCH 0/3] Btrfs: stop abusing current->journal_info for direct
 I/O
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: kernel-team@fb.com
References: <cover.1525933432.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <16e0b655-3778-990d-2cb9-abf34ea9e3ad@suse.com>
Date: Fri, 11 May 2018 12:53:36 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.05.2018 09:30, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Hi, everyone,
> 
> Btrfs currently abuses current->journal_info in btrfs_direct_IO() in
> order to pass around some state to get_block() and submit_io(). This
> hack is ugly and unnecessary because the data we pass around is only
> used in one call frame. Robbie Ko also pointed out [1] that it could
> potentially cause a crash if we happen to end up in start_transaction()
> (e.g., from memory reclaim calling into btrfs_evict_inode(), which can
> start a transaction). I'm not convinced that Robbie's case can happen in
> practice since we are using GFP_NOFS for allocations during direct I/O,
> but either way it's fragile and nasty.

When I worked initially on btrfs-over-swap I managed to hit a case where
ext4 stacked on top of btrfs would crash since btrfs will overwrite
journal_info which was set by ext4. So this change is indeed welcome :)

> 
> This series stops using current->journal_info and instead adds some
> extra arguments to the generic direct I/O code so that we can pass
> things around like sane people.
> 
> Based on Linus' master.
> 
> Thanks!
> 
> 1: https://patchwork.kernel.org/patch/10389077/
> 
> Omar Sandoval (3):
>   fs: add initial bh_result->b_private value to __blockdev_direct_IO()
>   fs: add private argument to dio_submit_t
>   Btrfs: stop abusing current->journal_info in btrfs_direct_IO()
> 
>  fs/btrfs/inode.c   | 39 ++++++++++-----------------------------
>  fs/direct-io.c     | 12 +++++++-----
>  fs/ext4/inode.c    |  6 +++---
>  fs/gfs2/aops.c     |  2 +-
>  fs/ocfs2/aops.c    |  5 ++---
>  include/linux/fs.h | 10 +++++-----
>  6 files changed, 28 insertions(+), 46 deletions(-)
> 

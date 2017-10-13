Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753497AbdJNQsw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:48:52 -0400
Date: Fri, 13 Oct 2017 19:10:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 19/21] btrfs: don't call btrfs_start_delalloc_roots in
 flushoncommit
Message-ID: <20171013171004.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-20-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-20-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:44:03PM -0400, Josef Bacik wrote:
> We're holding the sb_start_intwrite lock at this point, and doing async
> filemap_flush of the inodes will result in a deadlock if we freeze the
> fs during this operation.  This is because we could do a
> btrfs_join_transaction() in the thread we are waiting on which would
> block at sb_start_intwrite, and thus deadlock.  Using
> writeback_inodes_sb() side steps the problem by not introducing all of
> these extra locking dependencies.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 68c3e1c04bca..9fed8c67b6e8 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1917,7 +1917,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
>  static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
>  {
>  	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> -		return btrfs_start_delalloc_roots(fs_info, 1, -1);
> +		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);

This really needs a comment in the code, it's calling an external
interface to do some internal stuff. I was not able to trace it from
writeback_inodes_sb back to the dealloc in a reasonable time, so some
pointers in the comment are highly appreciated. The changelog sort of
explains what's going on, but it's still hard to find it in the code.

With writeback_inodes_sb, the function does not return any error and can
be moved to the single caller.

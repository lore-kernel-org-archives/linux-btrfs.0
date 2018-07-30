Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbeG3Jkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:40:32 -0400
Subject: Re: [PATCH 09/16] btrfs: IS_ERR(p) && PTR_ERR(p) == n is a weird way
 to spell p == ERR_PTR(n)
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180729220317.GB30522@ZenIV.linux.org.uk>
 <20180729220453.13431-1-viro@ZenIV.linux.org.uk>
 <20180729220453.13431-9-viro@ZenIV.linux.org.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a15c7158-bc61-e2f2-0904-2cb637238b04@suse.com>
Date: Mon, 30 Jul 2018 11:06:42 +0300
MIME-Version: 1.0
In-Reply-To: <20180729220453.13431-9-viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


[ADDED David Sterba and Linux-btrfs mailing list]

On 30.07.2018 01:04, Al Viro wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> Cc: Chris Mason <clm@fb.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

David, yout might want to pull this immediately, it's a nice cleanup.

> ---
>  fs/btrfs/transaction.c | 2 +-
>  fs/btrfs/tree-log.c    | 5 ++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ff5f6c719976..feb0348dbcbf 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -680,7 +680,7 @@ btrfs_attach_transaction_barrier(struct btrfs_root *root)
>  
>  	trans = start_transaction(root, 0, TRANS_ATTACH,
>  				  BTRFS_RESERVE_NO_FLUSH, true);
> -	if (IS_ERR(trans) && PTR_ERR(trans) == -ENOENT)
> +	if (trans == ERR_PTR(-ENOENT))
>  		btrfs_wait_for_commit(root->fs_info, 0);
>  
>  	return trans;
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index fcfbe1d8584a..2c13e8155ff1 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2116,7 +2116,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
>  						     dir_key->offset,
>  						     name, name_len, 0);
>  		}
> -		if (!log_di || (IS_ERR(log_di) && PTR_ERR(log_di) == -ENOENT)) {
> +		if (!log_di || log_di ==  ERR_PTR(-ENOENT)) {
>  			btrfs_dir_item_key_to_cpu(eb, di, &location);
>  			btrfs_release_path(path);
>  			btrfs_release_path(log_path);
> @@ -5090,8 +5090,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>  				 * we don't need to do more work nor fallback to
>  				 * a transaction commit.
>  				 */
> -				if (IS_ERR(other_inode) &&
> -				    PTR_ERR(other_inode) == -ENOENT) {
> +				if (other_inode == ERR_PTR(-ENOENT)) {
>  					goto next_key;
>  				} else if (IS_ERR(other_inode)) {
>  					err = PTR_ERR(other_inode);
> 

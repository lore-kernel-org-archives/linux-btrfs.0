From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix missing mutex_unlock in
 btrfs_del_dir_entries_in_log()
Date: Fri, 22 Apr 2011 14:45:56 +0200
Message-ID: <20110422124556.GV31675@twin.jikos.cz>
References: <201104220905.AA00017@T-ITOH1.jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104220905.AA00017@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Apr 22, 2011 at 06:05:40PM +0900, Tsutomu Itoh wrote:
> It is necessary to unlock mutex_lock before it return an error when
> btrfs_alloc_path() fails.

good catch! however I suggest to move the mutex_lock after the
allocation and check, it'll be semantically equivalent to your change,
but a bit readable. quick grep for btrfs_alloc_path usage showed that
it's quite common to do path allocation/check before any real work is
started.


david

> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index c50271a..f997ec0 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2209,8 +2209,10 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
>  
>  	log = root->log_root;
>  	path = btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> +	if (!path) {
> +		err = -ENOMEM;
> +		goto out_unlock;
> +	}

        mutex_lock(...);
>  
>  	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
>  				   name, name_len, -1);
> @@ -2271,6 +2273,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
>  	}
>  fail:
>  	btrfs_free_path(path);
> +out_unlock:
>  	mutex_unlock(&BTRFS_I(dir)->log_mutex);
>  	if (ret == -ENOSPC) {
>  		root->fs_info->last_trans_log_full_commit = trans->transid;

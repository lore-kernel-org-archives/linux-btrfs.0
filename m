From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [PATCH] Btrfs: optimize how we account for space in truncate
Date: Mon, 31 Oct 2011 18:15:07 -0400
Message-ID: <4EAF1DEB.2080405@suse.de>
References: <1312827886-16568-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312827886-16568-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/08/2011 02:24 PM, Josef Bacik wrote:
> Currently we're starting and stopping a transaction for no real
> reason, so kill that and just reserve enough space as if we can
> truncate all in one transaction. Also use btrfs_block_rsv_check()
> for our reserve to minimize the amount of space we may have to
> allocate for our slack space.  Thanks,

Sorry for the late review, but I ran into an Oops with this one today.
Before the patch, the while loop is guaranteed to exit with a valid
transaction handle. With btrfs_block_rsv_check call's error cases, if
it fails on the second time through the loop, it'll exit the loop with
trans = NULL.

> Signed-off-by: Josef Bacik <josef@redhat.com> --- fs/btrfs/inode.c
> |   58 +++++++++++++++++++++++++++--------------------------- 1
> files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c index
> 4aa4ea9..808ad07 100644 --- a/fs/btrfs/inode.c +++
> b/fs/btrfs/inode.c @@ -6452,6 +6452,7 @@ static int
> btrfs_truncate(struct inode *inode) struct btrfs_trans_handle
> *trans; unsigned long nr; u64 mask = root->sectorsize - 1; +	u64
> min_size = btrfs_calc_trans_metadata_size(root, 2);
> 
> ret = btrfs_truncate_page(inode->i_mapping, inode->i_size); if
> (ret) @@ -6500,17 +6501,21 @@ static int btrfs_truncate(struct
> inode *inode) if (!rsv) return -ENOMEM;
> 
> -	trans = btrfs_start_transaction(root, 4); +	/* +	 * 2 for the
> truncate slack space +	 * 1 for the orphan item we're going to add 
> +	 * 1 for the orphan item deletion +	 * 1 for updating the inode. 
> +	 */ +	trans = btrfs_start_transaction(root, 5); if
> (IS_ERR(trans)) { err = PTR_ERR(trans); goto out; }
> 
> -	/* -	 * Reserve space for the truncate process.  Truncate should
> be adding -	 * space, but if there are snapshots it may end up
> using space. -	 */ -	ret = btrfs_truncate_reserve_metadata(trans,
> root, rsv); +	/* Migrate the slack space for the truncate to our
> reserve */ +	ret =
> btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv, +
> min_size); BUG_ON(ret);
> 
> ret = btrfs_orphan_add(trans, inode); @@ -6519,21 +6524,6 @@ static
> int btrfs_truncate(struct inode *inode) goto out; }
> 
> -	nr = trans->blocks_used; -	btrfs_end_transaction(trans, root); -
> btrfs_btree_balance_dirty(root, nr); - -	/* -	 * Ok so we've
> already migrated our bytes over for the truncate, so here -	 * just
> reserve the one slot we need for updating the inode. -	 */ -	trans
> = btrfs_start_transaction(root, 1); -	if (IS_ERR(trans)) { -		err =
> PTR_ERR(trans); -		goto out; -	} -	trans->block_rsv = rsv; - /* *
> setattr is responsible for setting the ordered_data_close flag, *
> but that is only tested during the last file release.  That @@
> -6555,20 +6545,30 @@ static int btrfs_truncate(struct inode
> *inode) btrfs_add_ordered_operation(trans, root, inode);
> 
> while (1) { +		ret = btrfs_block_rsv_check(trans, root, rsv,
> min_size, 0); +		if (ret) { +			/* +			 * This can only happen with
> the original transaction we +			 * started above, every other time
> we shouldn't have a +			 * transaction started yet. +			 */ +			if
> (ret == -EAGAIN) +				goto end_trans; +			err = ret; +			break; +
> } +

If we bail out for either of these conditions here and it's the second
loop around...


> if (!trans) { -			trans = btrfs_start_transaction(root, 3); +			/*
> Just need the 1 for updating the inode */ +			trans =
> btrfs_start_transaction(root, 1); if (IS_ERR(trans)) { err =
> PTR_ERR(trans); goto out; } - -			ret =
> btrfs_truncate_reserve_metadata(trans, root, -							      rsv); -
> BUG_ON(ret); - -			trans->block_rsv = rsv; }
> 
> +		trans->block_rsv = rsv; + ret =
> btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 
> BTRFS_EXTENT_DATA_KEY); @@ -6583,7 +6583,7 @@ static int
> btrfs_truncate(struct inode *inode) err = ret; break; } - 
> +end_trans:

... then trans will already be NULL here.

> nr = trans->blocks_used; btrfs_end_transaction(trans, root); trans
> = NULL;


... and in and/or after the if statement block following the white loop.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOrx3rAAoJEB57S2MheeWyR50QAKbZjI1DUNMknmmzRXaeyANw
SBjjd85c2qtRvmbDDq6Zmabdi0aTKo6d7Z1sorpHKOY8lKYaytVMZ1TvMpvuVt97
Cvpn94JIjWF/6PXw/cALJfXf3rM96hqE7zA8DGC9gDg8k/UX56iSi3y+UcN+S0d5
KXYRs/rXlbrJSgkLHxK2e2dBuJzQyIf6KZHj0dYlQu6/XlVoQpyJ/PtchLUBXij2
Phx8XzPLIads1g6iX1ZiYvpiQYvYsThuts0YottoCczCTvnRdhEI35DQF7XaDVTr
0DI/iQM+eM37e54ULAMgYMFUsnEDC8O69Z1PU+nj52TByTYMvxNQWQqVUF4P2e2D
LbqY5ZNtKykJSF29UWVxG4cCzoJ2bjlJSMjf70e4iTzEUo7d36Ox4qd9OpY5EapU
nkQL3uHANsXC8IJ9MRcbvYTsNZNkVih8F216cs1FEyeYZUMWBz84/rvKB4n7abF5
qPfvFcWa3APBID5VRYmvjUfDrWJ9fRR58oK7WsdJHsYuaXNSCsVCzHtFxi9zw4gH
3oswoLn2J5gSClQsvU5ZrrUsApuNnRyVTQHUest1yqgUFCUUqFeB2xsKLsFdVwKT
qKq9x5CNQLEGwYmuDVDJbQkTLyW61W4Isd+nLlWZ23XAJ6l8ODIMqkO0PrMOiNiN
m+4VjlpOdNfBylfSSj1d
=bSEq
-----END PGP SIGNATURE-----

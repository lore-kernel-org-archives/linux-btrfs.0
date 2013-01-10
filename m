Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3AJRiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 12:38:02 -0500
Date: Thu, 10 Jan 2013 18:38:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 11/11] Btrfs: Add ACCESS_ONCE() to transaction->abort
 accesses
Message-ID: <20130110173800.GH20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50EEB9AF.2010301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EEB9AF.2010301@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 08:53:03PM +0800, Miao Xie wrote:
> We may access and update transaction->abort on the different CPUs without lock,
> so we need ACCESS_ONCE() wrapper to make sure we can get the new value.

ACCESS_ONCE is not the right synchronization primitive to be used here,
it is a way to force compiler to generate a single access to the data
through out the varaible scope, this does not have impact on inter-cpu
synchronization. This does not give a guarantee of the latest value of
abort.

> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -267,7 +267,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>  			     function, line, errstr);
>  		return;
>  	}
> -	trans->transaction->aborted = errno;
> +	ACCESS_ONCE(trans->transaction->aborted) = errno;
>  	__btrfs_std_error(root->fs_info, function, line, errno, NULL);

I don't think it's possible to reach 2 transaction aborts at the same
time so that the 'aborted' value gets silently overwritten. The error
message uses the 'errno' value passed to the function and thus this will
be visible in the syslog. I don't see a better way how to decide which
of the multiple 'aborted' values should win. A non-zero will abort, all
of them are in syslog. Enough information for further debugging.

>  }
>  /*
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a950d48..ee6cf27 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1468,11 +1468,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  		goto cleanup_transaction;
>  	}
>  
> -	if (cur_trans->aborted) {
> -		ret = cur_trans->aborted;
> -		goto cleanup_transaction;
> -	}

This is called early in the function and stops commit actions in case
the transaction has been aborted. Continuing despite that does not seem
right, the filesystem is RO already.

> -
>  	/* make a pass through all the delayed refs we have so far
>  	 * any runnings procs may add more while we are here
>  	 */
> @@ -1574,6 +1569,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	wait_event(cur_trans->writer_wait,
>  		   atomic_read(&cur_trans->num_writers) == 1);
>  
> +	if (ACCESS_ONCE(cur_trans->aborted)) {
> +		ret = cur_trans->aborted;
> +		goto cleanup_transaction;
> +	}
>  	/*
>  	 * the reloc mutex makes sure that we stop
>  	 * the balancing code from coming in and moving


david

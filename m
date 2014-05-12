Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31154 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbaELNuz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 09:50:55 -0400
Message-ID: <5370D21C.6000009@fb.com>
Date: Mon, 12 May 2014 09:52:28 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
References: <cover.1397572052.git.dsterba@suse.cz> <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
In-Reply-To: <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/15/2014 10:41 AM, David Sterba wrote:
> The patch "Btrfs: fix protection between send and root deletion"
> (18f687d538449373c37c) does not actually prevent to delete the snapshot
> and just takes care during background cleaning, but this seems rather
> user unfriendly, this patch implements the idea presented in
>
> https://urldefense.proofpoint.com/v1/url?u=http://www.spinics.net/lists/linux-btrfs/msg30813.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=oPq3jsCvKlZXohAj%2B1Mz9EvxoJ1iqsxD4%2Fkm%2By17esY%3D%0A&s=b820d70b0984d1e875bf8e22adadef7d6c2a6e0c1cdb4c3e0913f8f1521fc966
>
> - add an internal root_item flag to denote a dead root
> - check if the send_in_progress is set and refuse to delete, otherwise
>    set the flag and proceed
> - check the flag in send similar to the btrfs_root_readonly checks, for
>    all involved roots
>
> The root lookup in send via btrfs_read_fs_root_no_name will check if the
> root is really dead or not. If it is, ENOENT, aborted send. If it's
> alive, it's protected by send_in_progress, send can continue.
>

> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 9dde9717c1b9..80ec4fdc0b40 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5263,7 +5263,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>
>   	/*
>   	 * The subvolume must remain read-only during send, protect against
> -	 * making it RW.
> +	 * making it RW. This also protects against deletion.
>   	 */
>   	spin_lock(&send_root->root_item_lock);
>   	send_root->send_in_progress++;
> @@ -5284,6 +5284,15 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>   		goto out;
>   	}
>
> +	/*
> +	 * Unlikely but possible, if the subvolume is marked for deletion but
> +	 * is slow to remove the directory entry, send can still be started
> +	 */
> +	if (btrfs_root_dead(sctx->parent_root)) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +

This should be sctx->send_root and it should be lower right?  At this 
point the sctx hasn't been allocated yet.

I've changed it here and it'll go into integration shortly, but I can 
rebase in something different if required.

-chris

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39056 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbaA1QBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 11:01:17 -0500
Message-ID: <52E7D436.4060100@fb.com>
Date: Tue, 28 Jan 2014 11:00:54 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 2/4] Btrfs: don't get the lock when adding a csum into
 a ordered extent
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com> <1389702712-26638-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-3-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/14/2014 07:31 AM, Miao Xie wrote:
> We are sure that:
> - one ordered extent just has one csum calculation worker, and no one
>    access the csum list during the csum calculation except the worker.
> - we don't change the list and free the csum until no one reference
>    to the ordered extent
> So it is safe to add csum without the lock.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/ordered-data.c |    5 -----
>   1 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index e4c3d56..396c6d1 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -280,16 +280,11 @@ void btrfs_add_ordered_sum(struct inode *inode,
>   			   struct btrfs_ordered_extent *entry,
>   			   struct btrfs_ordered_sum *sum)
>   {
> -	struct btrfs_ordered_inode_tree *tree;
> -
> -	tree = &BTRFS_I(inode)->ordered_tree;
> -	spin_lock_irq(&tree->lock);
>   	list_add_tail(&sum->list, &entry->list);
>   	WARN_ON(entry->csum_bytes_left < sum->len);
>   	entry->csum_bytes_left -= sum->len;
>   	if (entry->csum_bytes_left == 0)
>   		wake_up(&entry->wait);
> -	spin_unlock_irq(&tree->lock);
>   }
>   
>   /*
This blew up in xfstests so one of your assumptions is incorrect. Thanks,

Josef

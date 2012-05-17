Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2EQFvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 01:51:24 -0400
Message-ID: <4FB4917D.1030501@cn.fujitsu.com>
Date: Thu, 17 May 2012 13:49:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>, Chris Mason <chris.mason@oracle.com>,
        Josef Bacik <josef@redhat.com>, Jeff Mahoney <jeffm@suse.com>
CC: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.4-rc6: delayed alloc deadlock...
References: <CAMVG2st1p8xkgOj7dknGSNtX5y42tv_tmnsUjZFQkMP3dXa9rw@mail.gmail.com> <4FA9E6F8.3030703@cn.fujitsu.com>
In-Reply-To: <4FA9E6F8.3030703@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comment for the following patch?

On wed, 09 May 2012 11:39:36 +0800, Miao Xie wrote:
> On tue, 8 May 2012 16:56:27 +0800, Daniel J Blueman wrote:
>> Delayed allocation ref mutexes are taken [1] inside
>> btrfs_commit_transaction. A later call fails and jumps to the
>> cleanup_transaction label (transaction.c:1501) with these mutexes
>> still held causing deadlock [2] when they are reacquired.
>>
>> Either we can introduce an earlier label (cleanup_transaction_lock)
>> and function to unlock these mutexes or can tweak
>> btrfs_destroy_delayed_refs to conditionally use mutex_try_lock.
>>
>> What is the suggested approach?
> 
> I think we can unlock those mutexes at the suitable place.
> Could you try this patch?
> 
> Title:[PATCH] Btrfs: fix deadlock when the process of delayed refs fails
> 
> Delayed ref mutexes are taken inside btrfs_commit_transaction. A later call
> fails and jumps to the cleanup_transaction label with these mutexes still held
> causing deadlock when they are reacquired.
> 
> Fix this problem by unlocking those mutexes at the suitable place.
> 
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-ref.c |    8 ++++++++
>  fs/btrfs/delayed-ref.h |    7 +++++++
>  fs/btrfs/extent-tree.c |   24 ++++++++++++++++++------
>  3 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 69f22e3..bc43c89 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -310,6 +310,14 @@ again:
>  	return 1;
>  }
>  
> +void btrfs_release_ref_cluster(struct list_head *cluster)
> +{
> +	struct list_head *pos, *q;
> +
> +	list_for_each_safe(pos, q, cluster)
> +		list_del_init(pos);
> +}
> +
>  /*
>   * helper function to update an extent delayed ref in the
>   * rbtree.  existing and update must both have the same
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index d8f244d..bd9c316 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -192,8 +192,15 @@ struct btrfs_delayed_ref_head *
>  btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
>  int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>  			   struct btrfs_delayed_ref_head *head);
> +static inline void btrfs_delayed_ref_unlock(struct btrfs_trans_handle *trans,
> +					    struct btrfs_delayed_ref_head *head)
> +{
> +	mutex_unlock(&head->mutex);
> +}
> +
>  int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
>  			   struct list_head *cluster, u64 search_start);
> +void btrfs_release_ref_cluster(struct list_head *cluster);
>  
>  struct seq_list {
>  	struct list_head list;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 49fd7b6..973379a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2157,7 +2157,6 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  						      node->num_bytes);
>  			}
>  		}
> -		mutex_unlock(&head->mutex);
>  		return ret;
>  	}
>  
> @@ -2302,14 +2301,13 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  				if (ret) {
>  					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
>  					spin_lock(&delayed_refs->lock);
> +					btrfs_delayed_ref_unlock(trans,
> +								 locked_ref);
>  					return ret;
>  				}
>  
>  				goto next;
>  			}
> -
> -			list_del_init(&locked_ref->cluster);
> -			locked_ref = NULL;
>  		}
>  
>  		ref->in_tree = 0;
> @@ -2325,11 +2323,24 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  
>  		ret = run_one_delayed_ref(trans, root, ref, extent_op,
>  					  must_insert_reserved);
> -
> -		btrfs_put_delayed_ref(ref);
>  		kfree(extent_op);
>  		count++;
>  
> +		/*
> +		 * If this node is a head, we will pick the next head to deal
> +		 * with. If there is something wrong when we process the
> +		 * delayed ref, we will end our operation. So in these two
> +		 * cases, we have to unlock the head and drop it from the
> +		 * cluster list before we release it though the code is ugly.
> +		 */
> +		if (btrfs_delayed_ref_is_head(ref) || ret) {
> +			btrfs_delayed_ref_unlock(trans, locked_ref);
> +			list_del_init(&locked_ref->cluster);
> +			locked_ref = NULL;
> +		}
> +
> +		btrfs_put_delayed_ref(ref);
> +
>  		if (ret) {
>  			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
>  			spin_lock(&delayed_refs->lock);
> @@ -2450,6 +2461,7 @@ again:
>  
>  		ret = run_clustered_refs(trans, root, &cluster);
>  		if (ret < 0) {
> +			btrfs_release_ref_cluster(&cluster);
>  			spin_unlock(&delayed_refs->lock);
>  			btrfs_abort_transaction(trans, root, ret);
>  			return ret;


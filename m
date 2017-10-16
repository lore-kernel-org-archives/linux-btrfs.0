Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdJPOlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:41:23 -0400
Subject: Re: [PATCH 13/21] btrfs: remove delayed_ref_node from ref_head
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-14-git-send-email-jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <884d9654-e189-99e7-9451-18e57a580c53@suse.com>
Date: Mon, 16 Oct 2017 17:41:21 +0300
MIME-Version: 1.0
In-Reply-To: <1506714245-23072-14-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.09.2017 22:43, Josef Bacik wrote:
> This is just excessive information in the ref_head, and makes the code
> complicated.  It is a relic from when we had the heads and the refs in
> the same tree, which is no longer the case.  With this removal I've
> cleaned up a bunch of the cruft around this old assumption as well.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/backref.c           |   4 +-
>  fs/btrfs/delayed-ref.c       | 126 +++++++++++++++++++------------------------
>  fs/btrfs/delayed-ref.h       |  49 ++++++-----------
>  fs/btrfs/disk-io.c           |  12 ++---
>  fs/btrfs/extent-tree.c       |  90 ++++++++++++-------------------
>  include/trace/events/btrfs.h |  15 +++---
>  6 files changed, 120 insertions(+), 176 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index b517ef1477ea..33cba1abf8b6 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1178,7 +1178,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  		head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
>  		if (head) {
>  			if (!mutex_trylock(&head->mutex)) {
> -				refcount_inc(&head->node.refs);
> +				refcount_inc(&head->refs);
>  				spin_unlock(&delayed_refs->lock);
>  
>  				btrfs_release_path(path);
> @@ -1189,7 +1189,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  				 */
>  				mutex_lock(&head->mutex);
>  				mutex_unlock(&head->mutex);
> -				btrfs_put_delayed_ref(&head->node);
> +				btrfs_put_delayed_ref_head(head);
>  				goto again;
>  			}
>  			spin_unlock(&delayed_refs->lock);
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 93ffa898df6d..b9b41c838da4 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -96,15 +96,15 @@ static struct btrfs_delayed_ref_head *htree_insert(struct rb_root *root,
>  	u64 bytenr;
>  
>  	ins = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
> -	bytenr = ins->node.bytenr;
> +	bytenr = ins->bytenr;
>  	while (*p) {
>  		parent_node = *p;
>  		entry = rb_entry(parent_node, struct btrfs_delayed_ref_head,
>  				 href_node);
>  
> -		if (bytenr < entry->node.bytenr)
> +		if (bytenr < entry->bytenr)
>  			p = &(*p)->rb_left;
> -		else if (bytenr > entry->node.bytenr)
> +		else if (bytenr > entry->bytenr)
>  			p = &(*p)->rb_right;
>  		else
>  			return entry;
> @@ -133,15 +133,15 @@ find_ref_head(struct rb_root *root, u64 bytenr,
>  	while (n) {
>  		entry = rb_entry(n, struct btrfs_delayed_ref_head, href_node);
>  
> -		if (bytenr < entry->node.bytenr)
> +		if (bytenr < entry->bytenr)
>  			n = n->rb_left;
> -		else if (bytenr > entry->node.bytenr)
> +		else if (bytenr > entry->bytenr)
>  			n = n->rb_right;
>  		else
>  			return entry;
>  	}
>  	if (entry && return_bigger) {
> -		if (bytenr > entry->node.bytenr) {
> +		if (bytenr > entry->bytenr) {
>  			n = rb_next(&entry->href_node);
>  			if (!n)
>  				n = rb_first(root);
> @@ -164,17 +164,17 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>  	if (mutex_trylock(&head->mutex))
>  		return 0;
>  
> -	refcount_inc(&head->node.refs);
> +	refcount_inc(&head->refs);
>  	spin_unlock(&delayed_refs->lock);
>  
>  	mutex_lock(&head->mutex);
>  	spin_lock(&delayed_refs->lock);
> -	if (!head->node.in_tree) {
> +	if (RB_EMPTY_NODE(&head->href_node)) {
>  		mutex_unlock(&head->mutex);
> -		btrfs_put_delayed_ref(&head->node);
> +		btrfs_put_delayed_ref_head(head);
>  		return -EAGAIN;
>  	}
> -	btrfs_put_delayed_ref(&head->node);
> +	btrfs_put_delayed_ref_head(head);
>  	return 0;
>  }
>  
> @@ -183,15 +183,10 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
>  				    struct btrfs_delayed_ref_head *head,
>  				    struct btrfs_delayed_ref_node *ref)
>  {
> -	if (btrfs_delayed_ref_is_head(ref)) {
> -		head = btrfs_delayed_node_to_head(ref);
> -		rb_erase(&head->href_node, &delayed_refs->href_root);
> -	} else {
> -		assert_spin_locked(&head->lock);
> -		list_del(&ref->list);
> -		if (!list_empty(&ref->add_list))
> -			list_del(&ref->add_list);
> -	}
> +	assert_spin_locked(&head->lock);

lockdep_assert_held


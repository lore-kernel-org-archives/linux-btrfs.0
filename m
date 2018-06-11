Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:37281 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752735AbeFKFFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 01:05:40 -0400
Subject: Re: [PATCH 09/15] btrfs-progs: Always pass 0 for offset when calling
 btrfs_free_extent for btree blocks.
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-10-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d6a85c64-e6f8-a55a-ddad-339a8e1b4e0d@gmx.com>
Date: Mon, 11 Jun 2018 13:05:26 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-10-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> Currently some instances of btrfs_free_extent are called with the
> last parameter ("offset") being set to 1. This makes no sense, since
> offset is used for data extents. I suspect this is a left-over from
> 95d3f20b51e9 ("Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)")
> since this commit changed the signature of the function from :
> 
> -int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
> -                     *root, u64 bytenr, u64 num_bytes, u64 parent,
> -                     u64 root_objectid, u64 ref_generation,
> -                     u64 owner_objectid, int pin);
> 
> to
> 
> +int btrfs_free_extent(struct btrfs_trans_handle *trans,
> +                     struct btrfs_root *root,
> +                     u64 bytenr, u64 num_bytes, u64 parent,
> +                     u64 root_objectid, u64 owner, u64 offset);
> 
> I.e the last parameter was "pin" and not offset. So these are just
> leftovers with no semantic meaning. Fix this by passing 0.

And indeed, for tree blocks the @offset parameter is not used at all.

The call sites involving the offset is:
btrfs_free_extent()
|- __free_extent()
   |- lookup_extent_backref()
      |- lookup_inline_extent_backref() <<<
      |- lookup_extent_data_ref()       <<<

And in lookup_inline_extent_backref() we won't use @offset for tree
blocks anyway.

The the 1 passed as @offset should be a left-over.

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  ctree.c       | 4 ++--
>  extent-tree.c | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/ctree.c b/ctree.c
> index 8f3338b4693a..d8a6883aa85f 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -334,7 +334,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  		WARN_ON(btrfs_header_generation(parent) != trans->transid);
>  
>  		btrfs_free_extent(trans, root, buf->start, buf->len,
> -				  0, root->root_key.objectid, level, 1);
> +				  0, root->root_key.objectid, level, 0);
>  	}
>  	if (!list_empty(&buf->recow)) {
>  		list_del_init(&buf->recow);
> @@ -738,7 +738,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
>  
>  		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
>  					0, root->root_key.objectid,
> -					level, 1);
> +					level, 0);
>  		/* once for the root ptr */
>  		free_extent_buffer(mid);
>  		return ret;
> diff --git a/extent-tree.c b/extent-tree.c
> index 079204ed290f..ab57c20d9dee 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2961,7 +2961,7 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
>  			path->slots[*level]++;
>  			ret = btrfs_free_extent(trans, root, bytenr, blocksize,
>  						parent->start, root_owner,
> -						root_gen, *level - 1, 1);
> +						root_gen, *level - 1, 0);
>  			BUG_ON(ret);
>  			continue;
>  		}
> @@ -3003,7 +3003,7 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
>  	root_gen = btrfs_header_generation(parent);
>  	ret = btrfs_free_extent(trans, root, path->nodes[*level]->start,
>  				path->nodes[*level]->len, parent->start,
> -				root_owner, root_gen, *level, 1);
> +				root_owner, root_gen, *level, 0);
>  	free_extent_buffer(path->nodes[*level]);
>  	path->nodes[*level] = NULL;
>  	*level += 1;
> @@ -3054,7 +3054,7 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
>  						path->nodes[*level]->start,
>  						path->nodes[*level]->len,
>  						parent->start, root_owner,
> -						root_gen, *level, 1);
> +						root_gen, *level, 0);
>  			BUG_ON(ret);
>  			free_extent_buffer(path->nodes[*level]);
>  			path->nodes[*level] = NULL;
> 

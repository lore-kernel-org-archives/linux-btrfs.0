From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: kill unreachable code in push_node_left
Date: Fri, 27 Apr 2012 17:15:23 +0200
Message-ID: <4F9AB80B.6060604@jan-o-sch.net>
References: <1335539030-17306-1-git-send-email-list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335539030-17306-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Actually, scratch that one.

Sorry,
-Jan

On 27.04.2012 17:03, Jan Schmidt wrote:
> We had the following code in push_node_left:
> 
> 	x = min(y, x);
>         if (x < y) {
> 		/* confusing comment here */
> 		...
> 	}
> 
> That if's condition can't become true, so just kill the entire block. Plus:
> no one will ever need to worry about the removed confusing comment.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index e801f22..0d2f4e5 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1999,19 +1999,9 @@ static int push_node_left(struct btrfs_trans_handle *trans,
>  	if (push_items <= 0)
>  		return 1;
>  
> -	if (empty) {
> +	if (empty)
>  		push_items = min(src_nritems, push_items);

(still, adding an else path with "push_items = src_nritems" would have
been much more obvious)

> -		if (push_items < src_nritems) {
> -			/* leave at least 8 pointers in the node if
> -			 * we aren't going to empty it
> -			 */
> -			if (src_nritems - push_items < 8) {
> -				if (push_items <= 8)
> -					return 1;
> -				push_items -= 8;
> -			}
> -		}
> -	} else
> +	else
>  		push_items = min(src_nritems - 8, push_items);
>  
>  	copy_extent_buffer(dst, src,

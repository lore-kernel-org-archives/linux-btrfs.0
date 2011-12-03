From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: Re: [PATCH] Btrfs: protect orphan block rsv with spin_lock
Date: Sat, 03 Dec 2011 20:53:53 +0100
Message-ID: <4EDA7E51.8010809@unilogicnetworks.net>
References: <1322858676-4278-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, sage@newdream.net
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322858676-4278-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

I've tried this patch but I'm still seeing the orphan commit warnings. 
I've tried your patch on 3.2-rc4. After the warnings I restarted the 
OSDs and tried to do a mkcephfs (so I had a clean fs again), but it hung 
on umounting the current btrfs fs on the first OSD (the ceph_osd service 
was started at boot). Doing a dmesg on the first OSD I saw the kernel 
BUG at fs/btrfs/extent-tree.c:2287 again.

I've pasted the whole dmesg ( http://pastebin.com/g4twVNj4), I couldn't 
get a trace. There are also some errors on mounting.

Hope this information will be of some use for you. If I get more 
information in another run I'll send them.

Stefan

On 12/02/2011 09:44 PM, Josef Bacik wrote:
> We've been seeing warnings coming out of the orphan commit stuff forever from
> ceph.  Turns out it's because we're racing with checking if the orphan block
> reserve is set, because we clear it outside of the spin_lock.  So leave the
> normal fastpath checks where they are, but take the spin_lock and _recheck_ to
> make sure we haven't had an orphan block rsv added in the meantime.  Then clear
> the root's orphan block rsv and release the lock.  With this patch a user said
> the warnings went away and they usually showed up pretty soon after he started
> ceph.  Thanks,
>
> Signed-off-by: Josef Bacik<josef@redhat.com>
> ---
>   fs/btrfs/inode.c |   23 +++++++++++++++++++----
>   1 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9ae9c2e..9de15f1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1951,12 +1951,28 @@ enum btrfs_orphan_cleanup_state {
>   void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
>   			      struct btrfs_root *root)
>   {
> +	struct btrfs_block_rsv *block_rsv;
>   	int ret;
>
>   	if (!list_empty(&root->orphan_list) ||
>   	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
>   		return;
>
> +	spin_lock(&root->orphan_lock);
> +	if (!list_empty(&root->orphan_list)) {
> +		spin_unlock(&root->orphan_lock);
> +		return;
> +	}
> +
> +	if (root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE) {
> +		spin_unlock(&root->orphan_lock);
> +		return;
> +	}
> +
> +	block_rsv = root->orphan_block_rsv;
> +	root->orphan_block_rsv = NULL;
> +	spin_unlock(&root->orphan_lock);
> +
>   	if (root->orphan_item_inserted&&
>   	btrfs_root_refs(&root->root_item)>  0) {
>   		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
> @@ -1965,10 +1981,9 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
>   		root->orphan_item_inserted = 0;
>   	}
>
> -	if (root->orphan_block_rsv) {
> -		WARN_ON(root->orphan_block_rsv->size>  0);
> -		btrfs_free_block_rsv(root, root->orphan_block_rsv);
> -		root->orphan_block_rsv = NULL;
> +	if (block_rsv) {
> +		WARN_ON(block_rsv->size>  0);
> +		btrfs_free_block_rsv(root, block_rsv);
>   	}
>   }
>


From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Prevent root_list corruption
Date: Tue, 24 Apr 2012 09:17:59 -0400
Message-ID: <20120424131758.GC1940@localhost.localdomain>
References: <1335244300-6599-1-git-send-email-daniel@quora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335244300-6599-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 01:11:40PM +0800, Daniel J Blueman wrote:
> I was seeing root_list corruption on unmount during fs resize in 3.4-rc4; add
> correct locking to address this.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  fs/btrfs/relocation.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 017281d..5a105a0 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1279,7 +1279,9 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
>  		if (rb_node)
>  			backref_tree_panic(rb_node, -EEXIST, node->bytenr);
>  	} else {
> +		spin_lock(&root->fs_info->trans_lock);
>  		list_del_init(&root->root_list);
> +		spin_unlock(&root->fs_info->trans_lock);
>  		kfree(node);
>  	}
>  	return 0;
> -- 
> 1.7.9.5
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef

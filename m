Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38053 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab2FYNlP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 09:41:15 -0400
Date: Mon, 25 Jun 2012 09:41:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch v2] Btrfs: fix error handling in __add_reloc_root()
Message-ID: <20120625133956.GA2499@localhost.localdomain>
References: <4FE473F6.5000109@fusionio.com>
 <20120625111048.GA10393@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120625111048.GA10393@elgon.mountain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 05:15:23AM -0600, Dan Carpenter wrote:
> We dereferenced "node" in the error message after freeing it.  Also
> btrfs_panic() can return so we should return an error code instead of
> continuing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: in the first version I just deleted the kfree().
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 790f492..4da0865 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1239,10 +1239,11 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
>  			      node->bytenr, &node->rb_node);
>  	spin_unlock(&rc->reloc_root_tree.lock);
>  	if (rb_node) {
> -		kfree(node);
>  		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
>  			    "for start=%llu while inserting into relocation "
>  			    "tree\n", node->bytenr);
> +		kfree(node);
> +		return -EEXIST;
>  	}
>  
>  	list_add_tail(&root->root_list, &rc->reloc_roots);

I'm not sure why but it seems like this patch is wrapped.  At first I thought it
was thunderbird but then I opened it up and saved it from mutt and I got the
same problem.  I will fix it up, but you may want to check your mail client.
Thanks,

Josef

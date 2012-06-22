Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35691 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762054Ab2FVNJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 09:09:12 -0400
Message-ID: <4FE46E70.8070702@fusionio.com>
Date: Fri, 22 Jun 2012 09:09:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] Btrfs: dereferencing free'd memory in panic message
References: <20120622071433.GA27618@elgon.mountain>
In-Reply-To: <20120622071433.GA27618@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2012 03:14 AM, Dan Carpenter wrote:
> We free "node" and then dereference it in the panic message on the next
> line.  I considered moving the kfree() after the panic given that panic
> can return under certain configurations, but in the end I decided it
> doesn't matter if we leak a bit after a panic.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 790f492..c50d80a 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1239,7 +1239,6 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
>   			      node->bytenr, &node->rb_node);
>   	spin_unlock(&rc->reloc_root_tree.lock);
>   	if (rb_node) {
> -		kfree(node);
>   		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
>   			    "for start=%llu while inserting into relocation "
>   			    "tree\n", node->bytenr);

Except btrfs_panic can not panic the box if it's mounted to not panic on 
errors, so we still need to do the kfree afterwards.  Thanks,

Josef

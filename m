Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38209 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751828AbdHYFtO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 01:49:14 -0400
Subject: Re: [PATCH] btrfs: fix NULL pointer dereference from
 free_reloc_roots()
To: Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, dsterba@suse.com
References: <150363811494.24591.5585689547237978902.stgit@naota.dhcp.fujisawa.hgst.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ee561c2e-b998-a264-3f9b-a36b26a3c626@suse.com>
Date: Fri, 25 Aug 2017 08:49:11 +0300
MIME-Version: 1.0
In-Reply-To: <150363811494.24591.5585689547237978902.stgit@naota.dhcp.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.08.2017 08:15, Naohiro Aota wrote:
> __del_reloc_root should be called before freeing up reloc_root->node.
> If not, calling __del_reloc_root() dereference reloc_root->node, causing
> the system BUG.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

This patch should also have:

Fixes: 6bdf131fac23 ("Btrfs: don't leak reloc root nodes on error")
Cc: <stable@vger.kernel.org> # 4.9

With that:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/relocation.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 65661d1aae4e..6445de8e9ece 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2393,11 +2393,11 @@ void free_reloc_roots(struct list_head *list)
>  	while (!list_empty(list)) {
>  		reloc_root = list_entry(list->next, struct btrfs_root,
>  					root_list);
> +		__del_reloc_root(reloc_root);
>  		free_extent_buffer(reloc_root->node);
>  		free_extent_buffer(reloc_root->commit_root);
>  		reloc_root->node = NULL;
>  		reloc_root->commit_root = NULL;
> -		__del_reloc_root(reloc_root);
>  	}
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

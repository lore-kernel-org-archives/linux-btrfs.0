Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:34452 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425461AbdD1JQy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:16:54 -0400
Date: Fri, 28 Apr 2017 14:16:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] Make max_size consistent with nr
Message-ID: <20170428141640.12429352@natsu>
In-Reply-To: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
References: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Apr 2017 11:13:36 +0200
Christophe de Dinechin <dinechin@redhat.com> wrote:

> Since we memset tmpl, max_size==0. This does not seem consistent with nr = 1.
> In check_extent_refs, we will call:
> 
>   set_extent_dirty(root->fs_info->excluded_extents,
>                    rec->start,
>                    rec->start + rec->max_size - 1);
> 
> This ends up with BUG_ON(end < start) in insert_state.
> 
> Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>
> ---
>  cmds-check.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 58e65d6..774e9b6 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6193,6 +6193,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
>  		tmpl.start = bytenr;
>  		tmpl.nr = 1;
>  		tmpl.metadata = 1;
> +                tmpl.max_size = 1;
>  
>  		ret = add_extent_rec_nolookup(extent_cache, &tmpl);
>  		if (ret)

The original code uses Tab characters for indent, but your addition uses
spaces. Also same problem in patch 2/3.

-- 
With respect,
Roman

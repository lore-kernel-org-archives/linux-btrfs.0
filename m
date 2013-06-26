Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57496 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3FZMiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 08:38:24 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 49B7D7C06B2
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 06:38:24 -0600 (MDT)
Date: Wed, 26 Jun 2013 08:38:21 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130626123821.GM4288@localhost.localdomain>
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 12:02:51PM +0800, Liu Bo wrote:
> Several users reported this crash of NULL pointer or general protection,
> the story is that we add a rbtree for speedup ulist iteration, and we
> use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> old data to new memory area, so it's OK for an array as it doesn't use
> pointers while it's not OK for a rbtree as it uses pointers.
> 
> So krealloc() will mess up our rbtree and it ends up with crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ulist.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 7b417e2..69a9c32 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -73,7 +73,6 @@ void ulist_fini(struct ulist *ulist)
>  	if (ulist->nodes_alloced > ULIST_SIZE)
>  		kfree(ulist->nodes);
>  	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
> -	ulist->root = RB_ROOT;

Why this change ^^?

Josef

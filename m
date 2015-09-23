Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbbIWInQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 04:43:16 -0400
Date: Wed, 23 Sep 2015 10:42:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: reada: Fix returned errno code
Message-ID: <20150923084219.GR12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442939007.git.luis@debethencourt.com>
 <c4a7a8023880c4a11326a6f7d9cc07ae37c12b0d.1442939007.git.luis@debethencourt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c4a7a8023880c4a11326a6f7d9cc07ae37c12b0d.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 05:29:39PM +0100, Luis de Bethencourt wrote:
> reada is using -1 instead of the -ENOMEM defined macro to specify that
> a buffer allocation failed. Since the error number is propagated, the
> caller will get a -EPERM which is the wrong error condition.
> 
> Smatch tool warning:
> reada_add_block() warn: returning -1 instead of -ENOMEM is sloppy
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>  fs/btrfs/reada.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 4645cd1..5bfd3cd 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -569,7 +569,7 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
>  	rec = kzalloc(sizeof(*rec), GFP_NOFS);
>  	if (!rec) {
>  		reada_extent_put(root->fs_info, re);
> -		return -1;
> +		return -ENOMEM;

When called from btrfs_reada_add, the return value is ignored and
overriden as ENOMEM. Please also update the caller to return the exact
value from reada_add_block.

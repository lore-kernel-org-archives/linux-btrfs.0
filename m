Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753460AbcHXMDv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 08:03:51 -0400
Date: Wed, 24 Aug 2016 13:49:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v2] Btrfs: check btree node's nritems
Message-ID: <20160824114908.GL16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1470254248-24041-1-git-send-email-bo.li.liu@oracle.com>
 <1471999065-8788-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471999065-8788-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 05:37:45PM -0700, Liu Bo wrote:
> When btree node (level = 1) has nritems which equals to zero,
> we can end up with panic due to insert_ptr()'s
> 
> BUG_ON(slot > nritems);
> 
> where slot is 1 and nritems is 0, as copy_for_split() calls
> insert_ptr(.., path->slots[1] + 1, ...);
> 
> A invalid value results in the whole mess, this adds the check
> for btree's node nritems so that we stop reading block when
> when something is wrong.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> v2: - remove unnecessary "noinline"
>     - fix to do the proper check as BTRFS_NODEPTRS_PER_BLOCK(root) is inclusive and nr is unsigned.
> 
>  fs/btrfs/disk-io.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 90f57fa..682816d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -633,6 +633,19 @@ static noinline int check_leaf(struct btrfs_root *root,
>  	return 0;
>  }
>  
> +static int check_node(struct btrfs_root *root, struct extent_buffer *node)
> +{
> +	unsigned long nr = btrfs_header_nritems(node);
> +
> +	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
> +		btrfs_crit(root->fs_info,
> +			   "corrupt node: block %llu root %llu nritems %lu\n",

I'll drop the newline.

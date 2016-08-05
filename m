Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37010 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbcHEJYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 05:24:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bVbMt-0005rS-0E
	for linux-btrfs@vger.kernel.org; Fri, 05 Aug 2016 11:24:39 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Subject: Re: [PATCH] Btrfs: check btree node's nritems
Date: Fri, 5 Aug 2016 09:24:30 +0000 (UTC)
Message-ID: <pan$98570$4794547a$be51fd77$d2061e3b@applied-asynchrony.com>
References: <1470254248-24041-1-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 03 Aug 2016 12:57:28 -0700, Liu Bo wrote:

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
> ---
>  fs/btrfs/disk-io.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 37d1780..a5a22be 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -612,6 +612,20 @@ static noinline int check_leaf(struct btrfs_root *root,
>  	return 0;
>  }
>  
> +static noinline int check_node(struct btrfs_root *root,
> +			       struct extent_buffer *node)
> +{
> +	unsigned long nr = btrfs_header_nritems(node);
> +
> +	if (nr <= 0 || nr >= BTRFS_NODEPTRS_PER_BLOCK(root)) {
> +		btrfs_crit(root->fs_info,
> +			   "corrupt node: block %llu root %llu nritems %lu\n",

I think the trailing \n can be dropped here, btrfs_crit() already provides
a proper newline.

-h


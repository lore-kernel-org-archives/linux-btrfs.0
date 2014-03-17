Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaCQMzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 08:55:07 -0400
Date: Mon, 17 Mar 2014 13:55:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: abort the transaction when we don't find our
 extent ref
Message-ID: <20140317125506.GD29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394829413-1620-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394829413-1620-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 14, 2014 at 04:36:53PM -0400, Josef Bacik wrote:
> I'm not sure why we weren't aborting here in the first place, it is obviously a
> bad time from the fact that we print the leaf and yell loudly about it.  Fix
> this up, otherwise we panic because our path could be pointing into oblivion.
> Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 696f0b6..0015b02 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5744,6 +5744,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,

Adding context:

5748         } else if (WARN_ON(ret == -ENOENT)) {
5749                 btrfs_print_leaf(extent_root, path->nodes[0]);
5750                 btrfs_err(info,

>  			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
>  			bytenr, parent, root_objectid, owner_objectid,
>  			owner_offset);
> +		btrfs_abort_transaction(trans, extent_root, ret);

Abort prints stacktrace on it's own and with the WARN_ON above it would
be noisy and without any extra benefit, so I suggest to remove it.

> +		goto out;
>  	} else {

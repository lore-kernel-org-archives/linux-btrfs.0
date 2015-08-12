Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56863 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbHLQKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 12:10:05 -0400
Date: Wed, 12 Aug 2015 09:09:36 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org
Message-ID: <20150812160936.GK29259@merlins.org>
References: <20150706212156.GY17274@merlins.org>
 <20150710134348.GB15535@suse.cz>
 <20150712010229.GA5284@merlins.org>
 <20150723115558.GQ6306@suse.cz>
 <20150724162446.GH30815@merlins.org>
 <20150803035130.GL24824@merlins.org>
 <20150811050758.GF29259@merlins.org>
 <55CA177D.1050004@fb.com>
 <20150812144749.GY24824@merlins.org>
 <55CB631B.2080404@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CB631B.2080404@fb.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 12, 2015 at 11:15:39AM -0400, Josef Bacik wrote:
> On 08/12/2015 10:47 AM, Marc MERLIN wrote:
> >On Tue, Aug 11, 2015 at 11:40:45AM -0400, Josef Bacik wrote:
> >> From a48cf7a9ae44a17d927df5542c8b0be287aee9ed Mon Sep 17 00:00:00 2001
> >>From: Josef Bacik <jbacik@fb.com>
> >>Date: Tue, 11 Aug 2015 11:39:37 -0400
> >>Subject: [PATCH] Btrfs: kill BUG_ON() in btrfs_lookup_extent_info()
> >>
> >>Replace it with an ASSERT(0) for the developers and an error for not the
> >>developers.
> >
> >Thanks. We knocked one down and now another BUG has been triggered :)
> >
> >	if (unlikely(wc->refs[level - 1] == 0)) {
> >		btrfs_err(root->fs_info, "Missing references.");
> >		BUG();
> >	}
> >
> 
> This is why you got your own branch, it's never just one.  Here's
> the next bit

Yes, I figured there might be a few more :)
Thanks for this patch, it definitely made things better:

[  165.656408] BTRFS info (device dm-0): disk space caching is enabled
[  205.528199] BTRFS error (device dm-0): Missing references.
[  205.528216] BTRFS: error (device dm-0) in btrfs_drop_snapshot:8652: errno=-5 IO failure
[  205.528225] BTRFS info (device dm-0): forced readonly

That's perfect, thanks much for that.

Now, back to check --repair, does it make sense to fix it too so that it doesn't crash either?

myth:~#  btrfs check --repair /dev/mapper/crypt_sdd1
enabling repair mode
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
btrfs[0x8066a73]
btrfs[0x8066aa4]
btrfs[0x8067991]
btrfs[0x806b4ab]
btrfs[0x806b9a3]
btrfs[0x806c5b2]
btrfs(cmd_check+0x1088)[0x806eddf]
btrfs(main+0x153)[0x80557c6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75784d3]
btrfs[0x80557ec]

Marc
 
> From 07214b5294d2772682aba893de15ef8020994598 Mon Sep 17 00:00:00 2001
> From: Josef Bacik <jbacik@fb.com>
> Date: Wed, 12 Aug 2015 11:06:42 -0400
> Subject: [PATCH] Btrfs: don't BUG() during drop snapshot
> 
> Really there's lots of things that can go wrong here, kill all the
> BUG_ON()'s
> and replace the logic ones with ASSERT()'s and return EIO instead.
> Also fix the
> leak of next in one of the error conditions while we're at it.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f7fb120..6671faf 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8196,12 +8196,15 @@ static noinline int do_walk_down(struct
> btrfs_trans_handle *trans,
>  				       &wc->flags[level - 1]);
>  	if (ret < 0) {
>  		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
>  		return ret;
>  	}
> 
>  	if (unlikely(wc->refs[level - 1] == 0)) {
>  		btrfs_err(root->fs_info, "Missing references.");
> -		BUG();
> +		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
> +		return -EIO;
>  	}
>  	*lookup_info = 0;
> 
> @@ -8253,7 +8256,13 @@ static noinline int do_walk_down(struct
> btrfs_trans_handle *trans,
>  	}
> 
>  	level--;
> -	BUG_ON(level != btrfs_header_level(next));
> +	ASSERT(level == btrfs_header_level(next));
> +	if (level != btrfs_header_level(next)) {
> +		printk(KERN_ERR "Mismatched level\n");
> +		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
> +		return -EIO;
> +	}
>  	path->nodes[level] = next;
>  	path->slots[level] = 0;
>  	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
> @@ -8268,8 +8277,14 @@ skip:
>  		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>  			parent = path->nodes[level]->start;
>  		} else {
> -			BUG_ON(root->root_key.objectid !=
> +			ASSERT(root->root_key.objectid ==
>  			       btrfs_header_owner(path->nodes[level]));
> +			if (root->root_key.objectid !=
> +			    btrfs_header_owner(path->nodes[level])) {
> +				printk(KERN_ERR "Mismatched block owner\n");
> +				btrfs_tree_unlock(next);
> +				free_extent_buffer(next);
> +			}
>  			parent = 0;
>  		}
> 
> @@ -8285,7 +8300,11 @@ skip:
>  		}
>  		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
>  				root->root_key.objectid, level - 1, 0, 0);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret) {
> +			btrfs_tree_unlock(next);
> +			free_extent_buffer(next);
> +			return ret;
> +		}
>  	}
>  	btrfs_tree_unlock(next);
>  	free_extent_buffer(next);
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

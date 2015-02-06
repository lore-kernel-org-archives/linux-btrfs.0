Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbbBFWQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:50 -0500
Date: Fri, 6 Feb 2015 14:16:47 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20150206221647.GK21790@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150201205119.GB29298@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150201205119.GB29298@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 01, 2015 at 11:51:19PM +0300, Dan Carpenter wrote:
> Hello Mark Fasheh,
> 
> The patch 1152651a0817: "btrfs: qgroup: account shared subtrees
> during snapshot delete" from Jul 17, 2014, leads to the following
> static checker warning:

What checker are you using?


> 	fs/btrfs/extent-tree.c:7642 account_shared_subtree()
> 	error: off-by-one overflow 'path->nodes' size 8.  index range = '1-8'
> 
> fs/btrfs/extent-tree.c
>   7611          BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
> 
> At first I thought that I could just change this > to >= to fix this
> warning.

That change would be appropriate as far as I can tell.



>   7612          BUG_ON(root_eb == NULL);
>   7613  
>   7614          if (!root->fs_info->quota_enabled)
>   7615                  return 0;
>   7616  
>   7617          if (!extent_buffer_uptodate(root_eb)) {
>   7618                  ret = btrfs_read_buffer(root_eb, root_gen);
>   7619                  if (ret)
>   7620                          goto out;
>   7621          }
>   7622  
>   7623          if (root_level == 0) {
>   7624                  ret = account_leaf_items(trans, root, root_eb);
>   7625                  goto out;
>   7626          }
>   7627  
>   7628          path = btrfs_alloc_path();
>   7629          if (!path)
>   7630                  return -ENOMEM;
>   7631  
>   7632          /*
>   7633           * Walk down the tree.  Missing extent blocks are filled in as
>   7634           * we go. Metadata is accounted every time we read a new
>   7635           * extent block.
>   7636           *
>   7637           * When we reach a leaf, we account for file extent items in it,
>   7638           * walk back up the tree (adjusting slot pointers as we go)
>   7639           * and restart the search process.
>   7640           */
>   7641          extent_buffer_get(root_eb); /* For path */
>   7642          path->nodes[root_level] = root_eb;
> 
> ->nodes[] has BTRFS_MAX_LEVEL elements.
> 
>   7643          path->slots[root_level] = 0;
>   7644          path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
>   7645  walk_down:
>   7646          level = root_level;
>   7647          while (level >= 0) {
>   7648                  if (path->nodes[level] == NULL) {
>   7649                          int parent_slot;
>   7650                          u64 child_gen;
>   7651                          u64 child_bytenr;
>   7652  
>   7653                          /* We need to get child blockptr/gen from
>   7654                           * parent before we can read it. */
>   7655                          eb = path->nodes[level + 1];
>                                          ^^^^^^^^^^^^^^^^^^
> But when I changed that, then it introduced a warning here because we
> add one.  I'm not sure what to do.

This code here is correct, and we should not be able to over/underflow the
nodes[] array so long as we guard against root_level being a reasonable
value. If you see above, we we set path->nodes[root_level] to a non-NULL
value. Since it is always non-NULL, the code you are worried about here will
never be executed for root_level.

Regarding changing it, I really don't care so long as you don't break the
code. It was extemely difficult and time consuming to test this and get it
all correct (well as correct as it is).

Thanks,
	--Mark

--
Mark Fasheh

From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Proper error handling on NULL pointers
Date: Mon, 19 Oct 2009 12:36:13 +0200
Message-ID: <200910191236.14046.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I recently posted a message that addresses the usage of BUG_ON for memory shortages concerning btrfs_alloc_path() (see [1]):

	...
	path = btrfs_alloc_path();
	BUG_ON(!path);
	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
	...

It seems that this is not the only place where NULL pointers returned by allocation functions are not handled properly. For instance in start_transaction(), errors are not handled at all:

	struct btrfs_trans_handle *h =
		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
	...
	/* Access h without check */
	...
	return h;

Repairing this would sometimes require to review a bunch of functions that directly or indirectly refer to it. As pointed out by Andi Kleen two weeks ago in a reply to message by Diego Calleja (see [2] and [3]), this might not be trivial, because these errors are sometimes not handled at all in highlevel functions.

However, is there any interest in patches fixing these problems? If yes: what would be the best strategy? Should we start fixing this "layer by layer" -- the low-level functions first and the high-level functions later on? Or should use come kind of "vertical approach" -- one low-level function and all of its callers at once?

If these issues currently don't have a very high priority, we could collect them in a TODO section in the Wiki or something. Any suggestions?

	Cheers,
		Andi

[1] http://www.spinics.net/lists/linux-btrfs/msg03221.html
[2] http://www.spinics.net/lists/linux-btrfs/msg03197.html
[3] http://www.spinics.net/lists/linux-btrfs/msg03198.html

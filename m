Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35294 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761074Ab2EQHOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 03:14:51 -0400
Date: Thu, 17 May 2012 10:14:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: re: btrfs: initial readahead code and prototypes
Message-ID: <20120517071446.GI14660@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I'm working on some new Smatch code and it complains about this
patch from last year. -Dan

----
This is a semi-automatic email about new static checker warnings.

The patch 7414a03fbf9e: "btrfs: initial readahead code and 
prototypes" from May 23, 2011, leads to the following Smatch 
complaint:

fs/btrfs/reada.c:147 __readahead_hook()
	 error: we previously assumed 'eb' could be null (see line 122)

fs/btrfs/reada.c
   121	
   122		if (eb)
                   ^^^^
Checked here.

   123			level = btrfs_header_level(eb);
   124	
   125		/* find extent */
   126		spin_lock(&fs_info->reada_lock);
   127		re = radix_tree_lookup(&fs_info->reada_tree, index);
   128		if (re)
   129			kref_get(&re->refcnt);
   130		spin_unlock(&fs_info->reada_lock);
   131	
   132		if (!re)
   133			return -1;
   134	
   135		spin_lock(&re->lock);
   136		/*
   137		 * just take the full list from the extent. afterwards we
   138		 * don't need the lock anymore
   139		 */
   140		list_replace_init(&re->extctl, &list);
   141		for_dev = re->scheduled_for;
   142		re->scheduled_for = NULL;
   143		spin_unlock(&re->lock);
   144	
   145		if (err == 0) {
   146			nritems = level ? btrfs_header_nritems(eb) : 0;
                                  ^^^^^
Checked here again indirectly.

   147			generation = btrfs_header_generation(eb);
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Dereferenced inside function without checking.

   148			/*
   149			 * FIXME: currently we just set nritems to 0 if this is a leaf,

regards,
dan carpenter


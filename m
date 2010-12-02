From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 4/4] btrfs: implement delayed dir index insertion and deletion
Date: Thu, 02 Dec 2010 11:33:40 -0500
Message-ID: <1291307496-sup-6170@think>
References: <4CF602BF.7010805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4CF602BF.7010805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2010-12-01 03:09:35 -0500:
> Compare with Ext3/4, the performance of file creation and deletion on btrfs
> is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
> such as inode item, directory name item, directory name index and so on.
> 
> If we can do some delayed b+ tree insertion or deletion, we can improve the
> performance, so we made this patch which implemented delayed directory name
> index insertion and deletion.

Many thanks for working on this.  It's a difficult problem and these
patches look very clean.

I think you can get more improvement if you also do this delayed scheme
for the inode items themselves.

The hard part of these delayed implementations is always the throttling,

+    if (delayed_root->count >= root->leafsize / sizeof(*dir_item))
+        btrfs_run_delayed_dir_index(trans, root, NULL,
+                        BTRFS_DELAYED_INSERT_ITEM, 0);
+ 

Have you experimented with other values here?

I need to take a hard look at the locking and do some benchmarking on
larger machines.  I'm a little worried about increased lock contention,
but I think we can get around it by breaking up the rbtrees a little
later on if we need to.

-chris

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [3.0-rc1] delayed insertion allocation failing...
Date: Mon, 30 May 2011 15:11:21 -0400
Message-ID: <1306782464-sup-7709@shiny>
References: <BANLkTinv0GDkGy6mhC2DVrt6wW7ZGQPPrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTinv0GDkGy6mhC2DVrt6wW7ZGQPPrQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Daniel J Blueman's message of 2011-05-30 10:24:08 -0400:
> Hi Miao,
> 
> When booting 3.0-rc1 with an existing BTRFS filesystem with a normal
> desktop use pattern, we see btrfs_batch_insert_item() sometimes
> attempt an overly-large kmalloc (>= order 11) [1], which is
> subsequently failed.

Wow, that's a big allocation.  Not really sure how this manages to
compile with a warning.

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 01e2950..790262d 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -678,6 +678,7 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&head);
 
 	next = item;
+	nitems = 0;
 
 	/*
 	 * count the number of the continuous items that we can insert in batch

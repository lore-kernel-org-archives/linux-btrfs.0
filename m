From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 15:36:52 -0400
Message-ID: <20100517193652.GC8635@think>
References: <4BF18525.8080904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jakob Unterwurzacher <jakobunt@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF18525.8080904@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 17, 2010 at 08:04:21PM +0200, Jakob Unterwurzacher wrote:
> Hi!
> 
> Following Ubuntu's dpkg+ext4 problems I wanted to see if btrfs would
> solve them all. And it nearly does! Now I wonder if the remaining 0.2
> seconds window of exposing 0-size files could be closed too.

That should be a zero second window, we try to force things to disk
during renames.

Could you please try this patch:

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c9f1020..9370a71 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -806,7 +806,7 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	 * if this file hasn't been changed since the last transaction
 	 * commit, we can safely return without doing anything
 	 */
-	if (last_mod < root->fs_info->last_trans_committed)
+	if (0 && last_mod < root->fs_info->last_trans_committed)
 		return 0;
 
 	/*

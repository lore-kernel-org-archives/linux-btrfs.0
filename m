From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Single disk performance
Date: Fri, 26 Jun 2009 16:56:59 -0400
Message-ID: <20090626205659.GD3951@think>
References: <4A44DB23.5000400@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A44DB23.5000400@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 26, 2009 at 09:28:51AM -0500, Steven Pratt wrote:
> Upgraded the btrfs tree to 6-17 and all of the stability problems went  
> away on the single disk system, so not sure if this was a code problem  
> or hardware, but at least stable now.
> Performance results updated at:
> http://btrfs.boxacle.net/repository/single-disk/History/History.html
>
> The fixed to the cow path are obvious for random write, although even on  
> single disk the CPU overhead is very noticeable as the efficiency graphs  
> show.
>
> The good news is that now the only workload that Btrfs is not at or near  
> the top in performance for single disk is MailServer.

Thanks Steve, glad to hear the stability problems are gone.

Could you please try this one liner to see if our big CPU problem during
streaming writes goes away?

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 126477e..7c3cd24 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -151,7 +151,10 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 	}
 	if (end_pos > isize) {
 		i_size_write(inode, end_pos);
-		btrfs_update_inode(trans, root, inode);
+		/* we've only changed i_size in ram, and we haven't updated
+		 * the disk i_size.  There is no need to log the inode
+		 * at this time.
+		 */
 	}
 	err = btrfs_end_transaction(trans, root);
 out_unlock:

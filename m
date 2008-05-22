From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH]btrfs delete ordered inode handling fix
Date: Thu, 22 May 2008 10:43:14 -0700
Message-ID: <1211478194.8596.28.camel@BVR-FS.beaverton.ibm.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <200805211452.34891.chris.mason@oracle.com>
	 <1211408996.8596.1.camel@BVR-FS.beaverton.ibm.com>
	 <200805221011.19568.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805221011.19568.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-05-22 at 10:11 -0400, Chris Mason wrote:
> On Wednesday 21 May 2008, Mingming wrote:
> > Hi Chris,  I thought I spotted a few bugs, While looking at how to
> > properly remove inode from ordered tree, let me know if I got it right.
> 
> Hi Mingming, thanks for going through this code.  The i_count rules in the 
> current code should work like this:
> 

Hi Chris, thanks for your detailed clarification.

> * btrfs_add_ordered_inode calls igrab when the inode is inserted into the 
> list.  The whole time the inode is on the list, there's an extra reference on 
> i_count.  There will be no final iput while the inode is on the list.
> 

Ah I missed that. That explains all my confusion of the i_count accounting.

> >
> > * There is possible race with inode delete and
> > btrfs_find_first_ordered_inode(). The inode could possibly in the
> > process of freeing while we are trying to get hold of it during commit
> > transaction. The fix is using igrab() instead, and search for next inode
> > in the tree if the found one is in the middle of being released.
> 
> These kinds of races where the main reason why I had the list take a reference 
> on the inode.  delete_inode won't be called while i_count is increased.
> 
> Over the long term I'd prefer to move the ordered-data list to a model where 
> the list doesn't have a reference and it is magically removed after all the 
> dirty pages are gone (by the end_io_hook handlers in inode.c).  The end_io 
> hooks in inode.c may be sufficient for this.
> 
Make sense.
> >
> > * get rid of btrfs_put_inode(), and move the functionality under the
> > btrfs_del_ordered_inode() directly.
> 
> I like this change, thanks.
> 
> >
> > * Remove the inode from ordered tree at last iput(). Did not do it at
> > file release() time, as it may remove the inode from the ordered tree
> > before ensure the ordering of write to the same inode from other
> > process.
> >
> > Perhaps calling btrfs_del_ordered_inode() under unlink() is enough, but
> > it would not be hurt to do it again at delete_inode() time.
> 
> I'm afraid we'll have to do it at file_release time, at least until the 
> ordered list is changed not to keep a reference.
> 
Yes with the i_count logic delete_inode() is not the right place to call
btrfs_del_ordered_inode.

But I am still not quite sure whether it is safe to remove the inode
from the ordered tree at the file_release() time. i.e. whether the dirty
data already being flushed to disk at last file_close()/file_release()
time and when two process open and write to the same inode ...

Regards,
Mingming


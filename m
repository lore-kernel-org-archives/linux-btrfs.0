From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH]btrfs delete ordered inode handling fix
Date: Thu, 22 May 2008 10:11:19 -0400
Message-ID: <200805221011.19568.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <200805211452.34891.chris.mason@oracle.com> <1211408996.8596.1.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1211408996.8596.1.camel@BVR-FS.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 21 May 2008, Mingming wrote:
> Hi Chris,  I thought I spotted a few bugs, While looking at how to
> properly remove inode from ordered tree, let me know if I got it right.

Hi Mingming, thanks for going through this code.  The i_count rules in the 
current code should work like this:

* btrfs_add_ordered_inode calls igrab when the inode is inserted into the 
list.  The whole time the inode is on the list, there's an extra reference on 
i_count.  There will be no final iput while the inode is on the list.

* btrfs_find_first_ordered_inode and btrfs_find_del_ordered_inode both 
increment i_count before returning the inode.  This gives the caller an extra 
reference on i_count in addition to the one held by the list.

* ordered-data.c never drops i_count.  This allows (and forces) the caller to 
decide when it is safe to call iput because callers have different locks held 
and because the last iput might can in theory trigger delete_inode.

All of the current callers of btrfs_del_ordered_inode already have a i_count 
increased before they call it.  So, they can safely just do an atomic_dec on 
i_count and let their own iputs later do the delete_inode.

>
> * inode->i_count accounting issue
> - remove extra i_count_decrease after calling
> filemap_file_write_and_wait() in btrfs_write_ordered_inodes()

There's an atomic_dec of i_count to drop the reference from 
btrfs_find_del_first_ordered_inode, and an iput to drop the reference added 
by igrab when the inode was put on the list.

>
> - Remove extra i_count decrease after each call
> btrfs_del_ordered_inode(), it decrease the i_count again. I couldn't
> find the where the i_count being increased. The tree_lock should
> protecting it races with btrfs_write_ordered_inodes(), no?

The increase comes from igrab on list insertion

>
> * There is possible race with inode delete and
> btrfs_find_first_ordered_inode(). The inode could possibly in the
> process of freeing while we are trying to get hold of it during commit
> transaction. The fix is using igrab() instead, and search for next inode
> in the tree if the found one is in the middle of being released.

These kinds of races where the main reason why I had the list take a reference 
on the inode.  delete_inode won't be called while i_count is increased.

Over the long term I'd prefer to move the ordered-data list to a model where 
the list doesn't have a reference and it is magically removed after all the 
dirty pages are gone (by the end_io_hook handlers in inode.c).  The end_io 
hooks in inode.c may be sufficient for this.

>
> * get rid of btrfs_put_inode(), and move the functionality under the
> btrfs_del_ordered_inode() directly.

I like this change, thanks.

>
> * Remove the inode from ordered tree at last iput(). Did not do it at
> file release() time, as it may remove the inode from the ordered tree
> before ensure the ordering of write to the same inode from other
> process.
>
> Perhaps calling btrfs_del_ordered_inode() under unlink() is enough, but
> it would not be hurt to do it again at delete_inode() time.

I'm afraid we'll have to do it at file_release time, at least until the 
ordered list is changed not to keep a reference.

>
>
> Here is the patch trying to address above issues... compiled, but not
> tested. Is ordered mode on by default?
>

Yes, there's actually no way to turn it off ;)

-chris

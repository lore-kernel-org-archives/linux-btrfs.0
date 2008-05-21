From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs_put_inode
Date: Wed, 21 May 2008 14:02:26 -0400
Message-ID: <200805211402.26648.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <Pine.LNX.4.64.0805050855250.15314@cobra.newdream.net> <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 21 May 2008, Mingming wrote:
> Hi Chris,
>
> btrfs failed to compile on 2.6.26-rc2 since the put_inode callback
> function is removed from super_operations.
>
> I noticed btrfs_put_inode() seems being actively used, to drop the inode
> from the tree for ordered mode transaction. Any idea where to relocate
> this function? Do we need to call btrfs_del_ordered_inode() for every
> iput()?

The ordered inode list has incremented the inode->i_count, so we can't do the 
iput code inside clear_inode.  But, we should be able to safely move the 
checks to file_release.

This is basically an optimization so that we don't leave clean inodes hanging 
around on the data=ordered list.  It is safe to remove the put_inode call 
completely, it'll just be a little slower.

-chris

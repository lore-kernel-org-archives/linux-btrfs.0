From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: BTRFS && SSD
Date: Wed, 29 Sep 2010 15:59:29 -0400
Message-ID: <20100929195929.GA5588@lelouch.nomadic.ncsu.edu>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
 <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
 <AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, yhxu@wayne.edu, chris.mason@oracle.com
To: Yuehai Xu <yuehaixu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 02:45:29PM -0400, Yuehai Xu wrote:
> On Wed, Sep 29, 2010 at 1:08 PM, Sean Bartell <wingedtachikoma@gmail.com> wrote:
> > On Wed, Sep 29, 2010 at 11:30:14AM -0400, Yuehai Xu wrote:
> >> I know BTRFS is a kind of Log-structured File System, which doesn't do
> >> overwrite. Here is my question, suppose file A is overwritten by A',
> >> instead of writing A' to the original place of A, a new place is
> >> selected to store it. However, we know that the address of a file
> >> should be recorded in its inode. In such case, the corresponding part
> >> in inode of A should update from the original place A to the new place
> >> A', is this a kind of overwrite actually? I think no matter what
> >> design it is for Log-Structured FS, a mapping table is always needed,
> >> such as inode map, DAT, etc. When a update operation happens for this
> >> mapping table, is it actually a kind of over-write? If it is, is it a
> >> bottleneck for the performance of write for SSD?
> >
> > In btrfs, this is solved by doing the same thing for the inode--a new
> > place for the leaf holding the inode is chosen. Then the parent of the
> > leaf must point to the new position of the leaf, so the parent is moved,
> > and the parent's parent, etc. This goes all the way up to the
> > superblocks, which are actually overwritten one at a time.
> 
> You mean that there is no over-write for inode too, once the inode
> need to be updated, this inode is actually written to a new place
> while the only thing to do is to change the point of its parent to
> this new place. However, for the last parent, or the superblock, does
> it need to be overwritten?

Yes. The idea of copy-on-write, as used by btrfs, is that whenever
*anything* is changed, it is simply written to a new location. This
applies to data, inodes, and all of the B-trees used by the filesystem.
However, it's necessary to have *something* in a fixed place on disk
pointing to everything else. So the superblocks can't move, and they are
overwritten instead.

From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Problem during implementing NFS support
Date: Sun, 20 Jul 2008 09:43:50 -0700
Message-ID: <1216572230.2475.106.camel@shinybook.infradead.org>
References: <200807210041.10609.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200807210041.10609.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 00:41 +0530, Balaji Rao wrote:
> Hi,
> 
> There's a problem in btrfs_readdir that tries to lock a root node with one 
> being held. This happens when NFS calls vfs_readdir function with a nfs 
> specific filldir function pointer. This filldir function, called with the 
> lock held calls btrfs_lookup, which tries to take the same lock. So, it keeps 
> waiting on lock_page indefinitely - a deadlock. This is not seen if the inode 
> is RAM in which case, lookup is not called.

We've seen precisely this problem (nfs3 readdirplus calling ->lookup
from within ->readdir and deadlocking) in a number of other file
systems.

I have an evil workaround hack for JFFS2 at
http://lists.infradead.org/pipermail/linux-mtd/2007-March/017663.html

> Why can't we allow multiple readers to read a page ?

In the general case we don't allow that because if there's a writer
waiting, they could end up waiting for _ever_ if you keep letting a
constant stream of new readers take the lock.

The only reason the readdirplus code is calling ->lookup() is so that it
can then generate a file handle. It doesn't really _need_ to pull every
inode into the icache as it does; it only needs the fh.

Perhaps we could extend the file system's readdir() method so it returns
the filehandle directly, instead. That might be a cleaner and more
efficient solution all round. Or we could add a ->lookup_fh() method
which only generates the filehandle, perhaps. Although you'd still have
the locking issues with the latter if it can _ever_ be called other than
from readdir().

The way GFS1 (and also XFS iirc) handles it is to build up a complete
list of responses to readdir() in a buffer, drop the lock, and then
iterate over that buffer calling filldir(). I don't much like that
version either.

-- 
dwmw2


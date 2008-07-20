From: Balaji Rao <balajirrao@gmail.com>
Subject: Re: Problem during implementing NFS support
Date: Mon, 21 Jul 2008 01:06:55 +0530
Message-ID: <200807210106.56056.balajirrao@gmail.com>
References: <200807210041.10609.balajirrao@gmail.com> <1216572230.2475.106.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216572230.2475.106.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 20 July 2008 10:13:50 pm David Woodhouse wrote:
> On Mon, 2008-07-21 at 00:41 +0530, Balaji Rao wrote:
> > Hi,
> >
> > There's a problem in btrfs_readdir that tries to lock a root node with
> > one being held. This happens when NFS calls vfs_readdir function with a
> > nfs specific filldir function pointer. This filldir function, called with
> > the lock held calls btrfs_lookup, which tries to take the same lock. So,
> > it keeps waiting on lock_page indefinitely - a deadlock. This is not seen
> > if the inode is RAM in which case, lookup is not called.
>
> We've seen precisely this problem (nfs3 readdirplus calling ->lookup
> from within ->readdir and deadlocking) in a number of other file
> systems.
>
oh, ok!

> I have an evil workaround hack for JFFS2 at
> http://lists.infradead.org/pipermail/linux-mtd/2007-March/017663.html
>
The idea of the patch seems correct to me, that once we "own" the lock, an 
attempt to take it again should be a nop.

Balaji

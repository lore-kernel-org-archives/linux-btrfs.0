From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Thu, 24 Apr 2008 09:06:54 -0400
Message-ID: <200804240906.54788.chris.mason__37969.1013521098$1209042985$gmane$org@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230923.03752.chris.mason@oracle.com> <20080423235208.GA6120@brong.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080423235208.GA6120@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 23 April 2008, Bron Gondwana wrote:
> On Wed, Apr 23, 2008 at 09:23:03AM -0400, Chris Mason wrote:
> > On Wednesday 23 April 2008, Evgeniy Polyakov wrote:
> > > On Wed, Apr 23, 2008 at 09:07:28AM -0400, Chris Mason
> >
> > (chris.mason@oracle.com) wrote:
> > > > But, userland expects things not to be undone.  Picture two procs
> > > > operating in a directory.  One proc calls fsync and gets assurance
> > > > from the FS that things are on disk.  The other proc calls rollback
> > > > and undoes the fsync.  The posix API isn't built around this.
> > >
> > > Rollback happens on transaction, so first application called fsync in
> > > own trasaction, which flushed data to disk, while second thread has own
> > > trasaction, and that data will be removed, while data written in first
> > > transaction is still on disk.
> >
> > The kind of logging this requires is outside the scope of Btrfs ;)  It is
> > possible if both procs are running in different tree roots, but how
> > about:
> >
> > proc A: mkdir dir1
> > proc A: create dir1/file1
> > proc B: add data to dir1/file1
> > proc B: fsync dir1/file1
> > proc A: rollback
> >
> > Filesystems can be databases, but not with the current APIs.  Userland
> > simply isn't built around these semantics today.
>
> proc A: mkdir dir1
> proc A: create dir1/file1
> proc B: add data to dir1/file1
> proc B: fsync dir1/file1
> proc A: unlink dir1/file1
> proc A: rmdir dir1
>
> I don't see the difference.

The main difference is that in the unlink case, the unlink goes through a 
series of code in the VFS to make sure that open file handles stay viable and 
that all of the other posix rules are followed.  In the rollback case, the 
filesystem has to do all of that on its own.

Here's another:

proc A: mkdir dir1
proc B: open dir1/file1 O_CREATE
proc A: rollback
proc B: close

Doing the same thing with rmdir would fail because the directory wasn't empty.  
In order to provide the rollback, the FS would have to wander through all of 
the dentries and do something sane with them.  It could rename the directory 
to dir1.soontobedead and clean it as soon as proc B was done.

The main point is this kind of thing is littered with corner cases.  You'd 
have to find each file or directory affected by the rollback and make sure 
appropriate actions are taken for each one, and get it done in a VFS friendly 
deadlock free way.

It would definitely be an interesting project.  But, a much more common 
feature request is the ability to do a few small things in an atomic unit 
(like Ceph), and I think that is a much more realistic project for the short 
term.

-chris

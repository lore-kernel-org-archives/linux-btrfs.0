From: "Bron Gondwana" <brong@fastmail.fm>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Sun, 27 Apr 2008 20:55:08 +1000
Message-ID: <1209293708.20552.1250088137@webmail.messagingengine.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
   <200804230923.03752.chris.mason@oracle.com>
   <20080423235208.GA6120@brong.net>
   <200804240906.54788.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	btrfs-devel@oss.oracle.com, "Zach Brown" <zach.brown@oracle.com>,
	linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804240906.54788.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 24 Apr 2008 09:06:54 -0400, "Chris Mason" <chris.mason@oracle.com> said:
> On Wednesday 23 April 2008, Bron Gondwana wrote:
> > On Wed, Apr 23, 2008 at 09:23:03AM -0400, Chris Mason wrote:
> > > proc A: mkdir dir1
> > > proc A: create dir1/file1
> > > proc B: add data to dir1/file1
> > > proc B: fsync dir1/file1
> > > proc A: rollback
> > >
> > > Filesystems can be databases, but not with the current APIs.  Userland
> > > simply isn't built around these semantics today.
> >
> > proc A: mkdir dir1
> > proc A: create dir1/file1
> > proc B: add data to dir1/file1
> > proc B: fsync dir1/file1
> > proc A: unlink dir1/file1
> > proc A: rmdir dir1
> >
> > I don't see the difference.
> 
> The main difference is that in the unlink case, the unlink goes through a 
> series of code in the VFS to make sure that open file handles stay viable
> and that all of the other posix rules are followed.  In the rollback case,
> the filesystem has to do all of that on its own.
> 
> Here's another:
> 
> proc A: mkdir dir1
> proc B: open dir1/file1 O_CREATE
> proc A: rollback
> proc B: close
>
> [... I've trimmed the following a bit, it's only partially quoted...]
> 
> Doing the same thing with rmdir would fail because the directory wasn't
> empty.  In order to provide the rollback, the FS would have to wander
> through all of  the dentries and do something sane with them....
>
> The main point is this kind of thing is littered with corner cases. 
> You'd  have to find each file or directory affected by the rollback
> and make sure appropriate actions are taken for each one, and get
> it done in a VFS friendly deadlock free way.

Yeah, that's a good point.  I suspect my first pass idea for this would
look remarkably like a soft-mounted NFS drive that had been disconnected.
Ooops, your little bit of filesystem went away - EIO, byebye.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm


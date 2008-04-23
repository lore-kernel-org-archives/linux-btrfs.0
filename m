From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Thu, 24 Apr 2008 09:52:08 +1000
Message-ID: <20080423235208.GA6120@brong.net>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230907.28640.chris.mason@oracle.com> <20080423131508.GA19354@2ka.mipt.ru> <200804230923.03752.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804230923.03752.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2008 at 09:23:03AM -0400, Chris Mason wrote:
> On Wednesday 23 April 2008, Evgeniy Polyakov wrote:
> > On Wed, Apr 23, 2008 at 09:07:28AM -0400, Chris Mason 
> (chris.mason@oracle.com) wrote:
> > > But, userland expects things not to be undone.  Picture two procs
> > > operating in a directory.  One proc calls fsync and gets assurance from
> > > the FS that things are on disk.  The other proc calls rollback and undoes
> > > the fsync.  The posix API isn't built around this.
> >
> > Rollback happens on transaction, so first application called fsync in
> > own trasaction, which flushed data to disk, while second thread has own
> > trasaction, and that data will be removed, while data written in first
> > transaction is still on disk.
> 
> The kind of logging this requires is outside the scope of Btrfs ;)  It is 
> possible if both procs are running in different tree roots, but how about:
> 
> proc A: mkdir dir1
> proc A: create dir1/file1
> proc B: add data to dir1/file1
> proc B: fsync dir1/file1
> proc A: rollback
> 
> Filesystems can be databases, but not with the current APIs.  Userland simply 
> isn't built around these semantics today.

proc A: mkdir dir1
proc A: create dir1/file1
proc B: add data to dir1/file1
proc B: fsync dir1/file1
proc A: unlink dir1/file1
proc A: rmdir dir1

I don't see the difference.

Bron.

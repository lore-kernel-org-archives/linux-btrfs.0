From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 13:15:45 -0400
Message-ID: <200804231315.45861.chris.mason__9218.74056007273$1208972110$gmane$org@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230923.03752.chris.mason@oracle.com> <20080423162132.GB3947@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080423162132.GB3947@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 23 April 2008, Evgeniy Polyakov wrote:
> On Wed, Apr 23, 2008 at 09:23:03AM -0400, Chris Mason 
(chris.mason@oracle.com) wrote:
> > The kind of logging this requires is outside the scope of Btrfs ;)  It is
> > possible if both procs are running in different tree roots, but how
> > about:
> >
> > proc A: mkdir dir1
> > proc A: create dir1/file1
> > proc B: add data to dir1/file1
> > proc B: fsync dir1/file1
> > proc A: rollback
>
> Depending on where transaction was started and where it was stopped. If
> there are exactly two transactions started and stopped at the start and
> the end of the 'trace', then rollback of transaction A means rollback of
> the inner transactions too.

Right, these are things that real databases solve that posix doesn't expect or 
understand.  The rollback will make the file disappear, but some other 
process could have the file open, without a transaction running.  So, the 
rollback needs to provide the same semantics you get today with unlink on an 
open file.

Definitely not impossible, but really outside the scope of btrfs.

>
> > Filesystems can be databases, but not with the current APIs.  Userland
> > simply isn't built around these semantics today.
>
> This is a philosiphical disput, I always believed that there is no
> difference between database and filesystem, but only access method
> changes.

We agree there, except that filesystems are able to include a number of 
optimizations that databases can't because they don't have to do rollback or 
private views of the data.

> And having proper API is just a matter of taste: one can create 
> ioctl based one to be private feature of the new filesystem. No one
> argues that XFS operation system should be transformed into XFS
> filesystem and generic VFS helpers (although that could be a good idea).

It isn't just the API, it is the rules surrounding how and when files or 
directories can disappear.  Please, prove me wrong...patches always welcome.

-chris




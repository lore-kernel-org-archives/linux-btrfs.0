From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 20:21:32 +0400
Message-ID: <20080423162132.GB3947@2ka.mipt.ru>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230907.28640.chris.mason@oracle.com> <20080423131508.GA19354@2ka.mipt.ru> <200804230923.03752.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804230923.03752.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2008 at 09:23:03AM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> The kind of logging this requires is outside the scope of Btrfs ;)  It is 
> possible if both procs are running in different tree roots, but how about:
> 
> proc A: mkdir dir1
> proc A: create dir1/file1
> proc B: add data to dir1/file1
> proc B: fsync dir1/file1
> proc A: rollback

Depending on where transaction was started and where it was stopped. If
there are exactly two transactions started and stopped at the start and
the end of the 'trace', then rollback of transaction A means rollback of
the inner transactions too.

> Filesystems can be databases, but not with the current APIs.  Userland simply 
> isn't built around these semantics today.

This is a philosiphical disput, I always believed that there is no
difference between database and filesystem, but only access method
changes. And having proper API is just a matter of taste: one can create
ioctl based one to be private feature of the new filesystem. No one
argues that XFS operation system should be transformed into XFS
filesystem and generic VFS helpers (although that could be a good idea).

-- 
	Evgeniy Polyakov

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 09:07:28 -0400
Message-ID: <200804230907.28640.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230850.55074.chris.mason@oracle.com> <20080423125754.GA31257@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080423125754.GA31257@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 23 April 2008, Evgeniy Polyakov wrote:
> Hi Chris.
>
> On Wed, Apr 23, 2008 at 08:50:54AM -0400, Chris Mason 
(chris.mason@oracle.com) wrote:
> > Transaction rollback from a filesystem point of view is a reboot.  Real
> > database style transactions with rollback and isolation from other procs
> > etc etc are outside the scope of Btrfs.
>
> Why rollback is a reboot? With copy-on-write it could be possible to
> just commit tree state, which was before transaction start, as a current
> one and thus rollback all changes. Having that possibility from
> userspace could be a great benefit, since in case of application error
> it is relly simple to undo all changes.

Oh, from a filesystem point of view it is very simple to undo changes, 
especially with COW.  We've got snapshots and we can pull old copies from an 
old snapshot etc etc.

But, userland expects things not to be undone.  Picture two procs operating in 
a directory.  One proc calls fsync and gets assurance from the FS that things 
are on disk.  The other proc calls rollback and undoes the fsync.  The posix 
API isn't built around this.

There are definitely cases where the admin will want to be able to run a 
command to shift the FS state back to some time in the past.  But, it needs 
to be an admin level tool where the complex interactions between procs are 
well understood (by the admin).

-chris

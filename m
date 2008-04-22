From: Chris Mason <chris.mason@ORACLE.COM>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 16:41:34 -0400
Message-ID: <200804221641.34817.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <480E4AA5.1070700@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Zach Brown <zach.brown@ORACLE.COM>, Sage Weil <sage@newdream.net>,
	linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <480E4AA5.1070700@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 April 2008, Zach Brown wrote:
> > A misbehaving application could also deliberately hold a transaction
> > open, effectively locking up the FS, so it may make sense to restrict
> > something like this to root or something.
>
> I suspect it doesn't have to be deliberate.
>
> Have you tried this under memory pressure?  I wonder if the application
> can get stuck waiting for memory which will only be freed once the
> transaction closes.

This isn't as big an issue, btrfs doesn't pin pages while the transaction is 
running.  There is some accounting rbtrees that grow while the transaction is 
running, but it isn't like a reiserfsv3 or jbd that have physical blocks on 
disk pinned.

>
> I'm reasonably sure that we've discussed this persistent theoretical
> problem with these kinds of interfaces ;).

I do agree is isn't practical for anything other than a tightly controlled 
interface.  It might make sense to create specific ioctls or syscalls for the 
operations you need to combine.  Perhaps a generic mechanism that can link a 
bunch of async syscalls together within a single framework.

Ok, really though, I seem to remember that ceph needed to do file + xattr 
operations in one atomic shot, were there others?

-chris

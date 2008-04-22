From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 16:32:34 -0400
Message-ID: <200804221632.34654.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 April 2008, Sage Weil wrote:
> Hi Chris,
>
> These ioctls let a user application hold a transaction open while it
> performs a series of operations.  A final ioctl does a sync on the fs
> (closing the current transaction).  This is the main requirement for
> Ceph's OSD to be able to keep the data it's storing in a btrfs volume
> consistent, and AFAICS it works just fine.  The application would do
> something like
>

I'm definitely willing to include it for you to experiment with.  Holding a 
transaction from userland can indeed lead to deadlock, but in this case your 
userland basically owns the server anyway.  I'm worried about some nasty 
corner cases still, but btrfs is blissfully ignoring those right now anyway.

One problem will be operations that are basically boundless (truncating a 
file, large writes).  Eventually the ENOSPC support will hook into the 
transaction system to make sure a given operation reserves enough free space.

With your ioctls, the "do a bunch of stuff" will need to honor the same 
accounting rules as the kernel code (which don't exist yet).

I thought your original plan was to do all of this from userland (without a 
kernel filesystem at all)?  The btrfs progs share most of the same code with 
the kernel, so with a little love to the transaction and IO subsystems, you'd 
be able to use it as a library style DB.

-chris

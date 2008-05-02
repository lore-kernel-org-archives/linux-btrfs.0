From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 2 May 2008 16:50:25 -0400
Message-ID: <200805021650.25497.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 24 April 2008, Sage Weil wrote:
> Hi-
>
> I'm working on a clone ioctl that will quickly and efficiently duplicate
> the contents of a file, e.g.

Sage's work has been pushed into the stable and unstable trees, along with a 
small command called bcp to trigger the clone ioctls.  bcp is used like this:

bcp src dst

If src is a directory, it is copied recursively.  If the clone ioctl fails, a 
fallback to buffer copies is done instead.

Sage, I had to make a few small changes to your ioctl code.  One was to skip 
reference count updates if the extent is a hole, and the other was to change 
around mark_inode_dirty a bit to avoid transaction deadlock.  We aren't 
actually making any pages dirty so it is safe to just update the inode.

-chris

From: Christian Parpart <trapni@gentoo.org>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into {libbtrfs,tools,tests}
Date: Thu, 9 Oct 2008 08:47:43 +0200
Message-ID: <200810090847.43559.trapni@gentoo.org>
References: <200810090420.49767.trapni@gentoo.org> <20081009055558.GB24531@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081009055558.GB24531@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 09 October 2008 07:55:58 Christoph Hellwig wrote:
> On Thu, Oct 09, 2008 at 04:20:49AM +0200, Christian Parpart wrote:
> > Hi,
> >
> > this now makes use of autoconf/automake/libtool suite,
> > thus, enabling a wider range of platforms etc.
> > Although, I've split up the build into tools, lib, and tests,
> > making it possible for 3rd-parties to link against libbtrfs now.
>
> I don't think allowing 3rd parties to link against it is a good idea.
> It's basically the kernel code with a few wrappers around it, and will
> change a lot over time.

I already noticed that, and this is another thing:
Why is the kernel module and the userland duplicating so much code?
As of ZFS, they've written a set of libraries (libzfs, libzpool, kernel compat 
libs, ...) that are shared between userland and kernel, thus, making porting 
to other platforms lots of easier.

If btrfs would do the same aproach, it could also benifit from a fuse frontend 
(aside the kernel module) to be used for debugging purposes, think of gdb, 
valgrind (or cachegrind) to mention the most interesting ones.

I talked to yangzheng about this, and he said that this just seems to lag a 
volunteer to do, however, *after* the disk format is completed.

Regards,
Christian Parpart.

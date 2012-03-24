From: Alex <alex@bpmit.com>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Sat, 24 Mar 2012 18:58:16 +0000 (UTC)
Message-ID: <loom.20120324T194951-446@post.gmane.org>
References: <87vclt99tg.fsf@falma.de> <20120324182104.GB14080@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:


>    Basically, the kernel needs to know which devices hold which btrfs
> filesystems (organised by UUID) before it tries to mount them. So,
> there's an ioctl that is used for sending that data to the kernel, and
> a userspace tool (btrfs dev scan) that enumerates all of the block
> devices it can see, looks for a btrfs superblock on them, and tells
> the kernel.
> 
>    Hugo.
> 

If you install the package btrfs-tools (currently dated 5 November 2011 in
unstable), it'll set up the necessary.



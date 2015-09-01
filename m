Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35192 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbIAAjc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 20:39:32 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 1 Sep 2015 10:39:30 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Date: Tue, 01 Sep 2015 06:08:35 +0530
Message-ID: <5223824.Yony0WpzXH@localhost.localdomain>
In-Reply-To: <160121092.hSkPuGCNnN@localhost.localdomain>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com> <20150831181127.GB7642@thunk.org> <160121092.hSkPuGCNnN@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 01 Sep 2015 05:49:14 Chandan Rajendra wrote:
> On Monday 31 Aug 2015 14:11:27 Theodore Ts'o wrote:
> > On Sun, Aug 30, 2015 at 08:16:21PM +0530, Chandan Rajendra wrote:
> > > For small filesystem instances (i.e. size <= 1 GiB), mkfs.btrfs fails
> > > when
> > > "data block size" does not match with the "metadata block size"
> > > specified
> > > on the mkfs.btrfs command line. This commit increases the size of
> > > filesystem instance created so that the test can be executed on
> > > subpagesize-blocksize Btrfs instances which have different values for
> > > data and metadata blocksizes.
> > 
> > Stupid question --- why isn't this considered a bug in mkfs.btrfs?
> > Does btrfs simply not support file systems <= 1 GB?  So if someone has
> > a 1GB USB disk or SD card, what's the official advice from the btrfs
> > developers?  Use xfs or ext4?
> 
> Ted, Btrfs does indeed support filesystem instances <= 1GiB. When creating
> such instances, mixed block groups are created i.e. These block groups hold
> both data and metadata. Hence the requirement of having matching "data block
> size" and "metadata block size" for filesystems <= 1 GiB.
> 
> mkfs.btrfs when invoked on small filesystems by "not" specifying any block
> sizes (i.e. mkfs.btrfs -f /dev/sda1) will automatically create filesystem
> instance with "data block size" == "metadata block size". However in the
> subpagesize-blocksize scenario, we need to specify both data and metadata
> block size on the command line (For e.g. mkfs.btrfs -f -s 4096 -n 16384
> /dev/sda1). In this case, Since the user is forcing the block sizes and it
> is impossible to have mixed block groups with differing data and metadata
> block sizes, mkfs.btrfs will fail.

Also, For small filesystems, "mkfs.btrfs -f /dev/sda1 -s 4096 -n 4096" works
fine since the command is invoked with the same size for both data and
metadata blocks. 

-- 
chandan


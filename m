Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57108 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbbIACee (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 22:34:34 -0400
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 1 Sep 2015 12:34:31 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Date: Tue, 01 Sep 2015 08:03:38 +0530
Message-ID: <2500094.kBUgEuDpMB@localhost.localdomain>
In-Reply-To: <20150901021510.GE7642@thunk.org>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com> <160121092.hSkPuGCNnN@localhost.localdomain> <20150901021510.GE7642@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 31 Aug 2015 22:15:10 Theodore Ts'o wrote:
> On Tue, Sep 01, 2015 at 05:49:14AM +0530, Chandan Rajendra wrote:
> > mkfs.btrfs when invoked on small filesystems by "not" specifying any block
> > sizes (i.e. mkfs.btrfs -f /dev/sda1) will automatically create filesystem
> > instance with "data block size" == "metadata block size". However in the
> > subpagesize-blocksize scenario, we need to specify both data and metadata
> > block size on the command line (For e.g. mkfs.btrfs -f -s 4096 -n 16384
> > /dev/sda1). In this case, Since the user is forcing the block sizes and it
> > is impossible to have mixed block groups with differing data and metadata
> > block sizes, mkfs.btrfs will fail.
> 
> Ok, so the issue is that for this particular test configuration, btrfs
> has a minimum file system size.  What about changing
> _scratch_mkfs_sized so that if MIN_FS_SIZE is set, the file system
> created will be at least MIN_FS_SIZE in size.
> 
> This way it sets the minimum file system size for all tests, not just
> generic/224, and any test configuration, whether it be ext4, xfs, or
> btrfs where the data and metadata block size are the same, don't have
> to take extra time -- only the test configuration of btrfs with
> data_block_size != metadata_block_size.
> 
I agree with the approach you have suggested. I will write up a patch and send
it across the mailing list. Thanks Ted.

-- 
chandan


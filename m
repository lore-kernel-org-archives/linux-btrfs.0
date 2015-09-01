Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57039 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbbIACPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 22:15:16 -0400
Date: Mon, 31 Aug 2015 22:15:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Message-ID: <20150901021510.GE7642@thunk.org>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20150831181127.GB7642@thunk.org>
 <160121092.hSkPuGCNnN@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <160121092.hSkPuGCNnN@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 05:49:14AM +0530, Chandan Rajendra wrote:
> mkfs.btrfs when invoked on small filesystems by "not" specifying any block
> sizes (i.e. mkfs.btrfs -f /dev/sda1) will automatically create filesystem
> instance with "data block size" == "metadata block size". However in the
> subpagesize-blocksize scenario, we need to specify both data and metadata
> block size on the command line (For e.g. mkfs.btrfs -f -s 4096 -n 16384
> /dev/sda1). In this case, Since the user is forcing the block sizes and it is
> impossible to have mixed block groups with differing data and metadata block
> sizes, mkfs.btrfs will fail.

Ok, so the issue is that for this particular test configuration, btrfs
has a minimum file system size.  What about changing
_scratch_mkfs_sized so that if MIN_FS_SIZE is set, the file system
created will be at least MIN_FS_SIZE in size.

This way it sets the minimum file system size for all tests, not just
generic/224, and any test configuration, whether it be ext4, xfs, or
btrfs where the data and metadata block size are the same, don't have
to take extra time -- only the test configuration of btrfs with
data_block_size != metadata_block_size.

Cheers,

						- Ted

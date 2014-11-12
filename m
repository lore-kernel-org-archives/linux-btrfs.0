Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46781 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaKLLqk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 06:46:40 -0500
Received: by mail-wi0-f171.google.com with SMTP id r20so4583047wiv.16
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 03:46:38 -0800 (PST)
Date: Wed, 12 Nov 2014 11:46:31 +0000
From: Steve Capper <steve.capper@linaro.org>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, jcm@redhat.com
Subject: Re: [RFC PATCH V8 00/16] Btrfs: Subpagesize-blocksize: Get rid of
 whole page I/O.
Message-ID: <20141112114630.GA27082@linaro.org>
References: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 12, 2014 at 01:47:32PM +0530, Chandan Rajendra wrote:

[...]

> 
> Chandan Rajendra (14):
>   Btrfs: subpagesize-blocksize: Get rid of whole page reads.
>   Btrfs: subpagesize-blocksize: Get rid of whole page writes.
>   Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release
>     extents aligned to block size.
>   Btrfs: subpagesize-blocksize: Read tree blocks whose size is
>     <PAGE_CACHE_SIZE.
>   Btrfs: subpagesize-blocksize: Write only dirty extent buffers
>     belonging to a page
>   Btrfs: subpagesize-blocksize: Compute and look up csums based on
>     sectorsized blocks.
>   Btrfs: subpagesize-blocksize: __extent_writepage: Write only dirty
>     blocks of a page.
>   Btrfs: subpagesize-blocksize: fallocate: Work with sectorsized units.
>   Btrfs: subpagesize-blocksize: btrfs_page_mkwrite: Reserve space in
>     sectorsized units.
>   Btrfs: subpagesize-blocksize: Search for all ordered extents that
>     could span across a page.
>   Btrfs: subpagesize-blocksize: Deal with partial ordered extent
>     allocations.
>   Btrfs: subpagesize-blocksize: Explicitly Track I/O status of blocks of
>     an ordered extent.
>   Btrfs: subpagesize-blocksize: Revert commit
>     fc4adbff823f76577ece26dcb88bf6f8392dbd43.
>   Btrfs: subpagesize-blocksize: Track blocks of ordered extent submitted
>     for write I/O.
> 
> Chandra Seetharaman (2):
>   Btrfs: subpagesize-blocksize: Define extent_buffer_head.
>   Btrfs: subpagesize-blocksize: Allow mounting filesystems where
>     sectorsize != PAGE_SIZE


Thank you for posting this series Chandan, it's incredibly useful for
us, I'll give it a go on arm64.

For arm64, one can run with a 4KB or 64KB PAGE_SIZE (userspace is 64KB
aligned and can cope with the switch), thus the inability of btrfs to
cope with a change in PAGE_SIZE is close to being a showstopper.

One could, for instance, have an installer running with a 4KB kernel
which installs a server kernel running 64KB, then on reboot.....
Another use case would be to simply move data disks from a machine
running $ARCH to $ANOTHERARCH.

Cheers,
-- 
Steve

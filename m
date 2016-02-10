Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbcBJKjr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 05:39:47 -0500
Date: Wed, 10 Feb 2016 11:39:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: bo.li.liu@oracle.com, clm@fb.com, jbacik@fb.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [RFC PATCH V11 01/21] Btrfs: subpagesize-blocksize: Fix whole
 page read.
Message-ID: <20160210103924.GC30511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-2-git-send-email-chandan@linux.vnet.ibm.com>
 <20150619044536.GA31508@localhost.localdomain>
 <2574653.62sO1fmDVj@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2574653.62sO1fmDVj@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 03:15:01PM +0530, Chandan Rajendra wrote:
> > private->io_lock is not acquired here but not in below.
> > 
> > IIUC, this can be protected by EXTENT_LOCKED.
> >
> 
> private->io_lock plays the same role as BH_Uptodate_Lock (see
> end_buffer_async_read()) i.e. without the io_lock we may end up in the
> following situation,
> 
> NOTE: Assume 64k page size and 4k block size. Also assume that the first 12
> blocks of the page are contiguous while the next 4 blocks are contiguous. When
> reading the page we end up submitting two "logical address space" bios. So
> end_bio_extent_readpage function is invoked twice (once for each bio).
> 
> |-------------------------+-------------------------+-------------|
> | Task A                  | Task B                  | Task C      |
> |-------------------------+-------------------------+-------------|
> | end_bio_extent_readpage |                         |             |
> | process block 0         |                         |             |
> | - clear BLK_STATE_IO    |                         |             |
> | - page_read_complete    |                         |             |
> | process block 1         |                         |             |
> | ...                     |                         |             |
> | ...                     |                         |             |
> | ...                     | end_bio_extent_readpage |             |
> | ...                     | process block 0         |             |
> | ...                     | - clear BLK_STATE_IO    |             |
> | ...                     | - page_read_complete    |             |
> | ...                     | process block 1         |             |
> | ...                     | ...                     |             |
> | process block 11        | process block 3         |             |
> | - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
> | - page_read_complete    | - page_read_complete    |             |
> |   - returns true        |   - returns true        |             |
> |   - unlock_page()       |                         |             |
> |                         |                         | lock_page() |
> |                         |   - unlock_page()       |             |
> |-------------------------+-------------------------+-------------|
> 
> So we end up incorrectly unlocking the page twice and "Task C" ends up working
> on an unlocked page. So private->io_lock makes sure that only one of the tasks
> gets "true" as the return value when page_read_complete() is invoked. As an
> optimization the patch gets the io_lock only when nr_sectors counter reaches
> the value 0 (i.e. when the last block of the bio_vec is being processed).
> Please let me know if my analysis was incorrect.
> 
> Also, I noticed that page_read_complete() and page_write_complete() can be
> replaced by just one function i.e. page_io_complete().

The explanations and the table would be good in the changelog and as
comments. I think we'll need to consider the smaller blocks more often
so some examples and locking rules would be useful, eg. documented in
this file.

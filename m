Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbbCSXQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 19:16:59 -0400
Date: Thu, 19 Mar 2015 16:16:55 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] dm: log writes target
Message-ID: <20150319231655.GA6751@lenny.home.zabbo.net>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com>
 <1426797070-27463-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426797070-27463-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:
> This creates a new target that is meant for file system developers to test file
> system integrity at particular points in the life of a file system.

Hi Josef, just a quick drive-by review for stuff that jumps out at me..

> +	atomic_dec(&lc->io_blocks);
> +	wake_up(&lc->wait);

This waitqueue is only used by the destructor?  Seems worth putting this
off in a helper that tests the waitqueue so that it avoids taking locks
in the common case where nothing is waiting. 

	atomic_dec(&lc->io_blocks);
	smp_mb__after_atomic(); /* see wake_up_bit() comment */
	if (waitqueue_active(&lc->wait))
		wake_up(&lc->wait);


> +	ptr = kmap_atomic(page);
> +	memset(ptr, 0, lc->sectorsize);
> +	memcpy(ptr, entry, entrylen);
> +	if (datalen)
> +		memcpy(ptr + entrylen, data, datalen);
> +	kunmap_atomic(ptr);

Drop the initial zeroing and only zero a remaining tail fragment?

  memset(ptr + entry + data, 0, sector - (entry + data))

> +	entry.sector = cpu_to_le64(block->sector);
> +	entry.nr_sectors = cpu_to_le64(block->nr_sectors);
> +	entry.flags = cpu_to_le64(block->flags);
> +	entry.data_len = block->datalen;

Missing cpu_to_le64?  Build with sparse?

> +	for (i = 0; i < block->vec_cnt; i++) {
> +		ret = bio_add_page(bio, block->vecs[i].bv_page,
> +				   block->vecs[i].bv_len, 0);

It took me a minute to figure out that the offsets are always 0 because
each page starts with a copy of one bvec segment.

> +			sector = lc->next_sector;
> +			if (block->flags & LOG_DISCARD_FLAG)
> +				lc->next_sector++;
> +			else
> +				lc->next_sector += block->nr_sectors + 1;
> +
> +			/*
> +			 * Apparently the size of the device may not be known
> +			 * right away, so handle this properly.
> +			 */
> +			if (!lc->end_sector)
> +				lc->end_sector = logdev_last_sector(lc);
> +			if (lc->end_sector &&
> +			    lc->next_sector > lc->end_sector) {

Does that need to be >= to avoid trying to write to the sector at the
device's i_size?

- z

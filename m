Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756341AbeAROUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:20:04 -0500
Date: Thu, 18 Jan 2018 15:17:53 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix missing inode i_size update after zero
 range operation
Message-ID: <20180118141753.GJ13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180118113420.9776-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180118113420.9776-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 18, 2018 at 11:34:20AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> For a fallocate's zero range operation that targets a range with an end
> that is not aligned to the sector size, we can end up not updating the
> inode's i_size. This happens when the last page of the range maps to an
> unwritten (prealloc) extent and before that last page we have either a
> hole or a written extent. This is because in this scenario we relied
> on a call to btrfs_prealloc_file_range() to update the inode's i_size,
> however it can only update the i_size to the "down aligned" end of the
> range.
> 
> Example:
> 
>  $ mkfs.btrfs -f /dev/sdc
>  $ mount /dev/sdc /mnt
>  $ xfs_io -f -c "pwrite -S 0xff 0 428K" /mnt/foobar
>  $ xfs_io -c "falloc -k 428K 4K" /mnt/foobar
>  $ xfs_io -c "fzero 0 430K" /mnt/foobar
>  $ du --bytes /mnt/foobar
>  438272	/mnt/foobar
> 
> The inode's i_size was left as 428Kb (438272 bytes) when it should have
> been updated to 430Kb (440320 bytes).
> Fix this by always updating the inode's i_size explicitly after zeroing
> the range.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to 4.16 queue, thanks.

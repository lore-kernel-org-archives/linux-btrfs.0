Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754905AbdKOP3c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:29:32 -0500
Date: Wed, 15 Nov 2017 16:27:38 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Btrfs: fix reported number of inode blocks after
 buffered append writes
Message-ID: <20171115152738.GO28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171104041956.9674-1-fdmanana@kernel.org>
 <20171104042007.9724-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171104042007.9724-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 04, 2017 at 04:20:07AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The patch from commit a7e3b975a0f9 ("Btrfs: fix reported number of inode
> blocks") introduced a regression where if we do a buffered write starting
> at position equal to or greater than the file's size and then stat(2) the
> file before writeback is triggered, the number of used blocks does not
> change (unless there's a prealloc/unwritten extent). Example:
> 
>   $ xfs_io -f -c "pwrite -S 0xab 0 64K" foobar
>   $ du -h foobar
>   0	foobar
>   $ sync
>   $ du -h foobar
>   64K	foobar
> 
> The first version of that patch didn't had this regression and the second
> version, which was the one committed, was made only to address some
> performance regression detected by the intel test robots using fs_mark.
> 
> This fixes the regression by setting the new delaloc bit in the range, and
> doing it at btrfs_dirty_pages() while setting the regular dealloc bit as
> well, so that this way we set both bits at once avoiding navigation of the
> inode's io tree twice. Doing it at btrfs_dirty_pages() is also the most
> meaninful place, as we should set the new dellaloc bit when if we set the
> delalloc bit, which happens only if we copied bytes into the pages at
> __btrfs_buffered_write().
> 
> This was making some of LTP's du tests fail, which can be quickly run
> using a command line like the following:
> 
>   $ ./runltp -q -p -l /ltp.log -f commands -s du -d /mnt
> 
> Fixes: a7e3b975a0f9 ("Btrfs: fix reported number of inode blocks")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

FYI, I'm going to add the two patches to a 4.15 queue.

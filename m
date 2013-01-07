Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab3AGQUw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 11:20:52 -0500
Date: Mon, 7 Jan 2013 17:20:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130107162050.GJ20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 11:53:08AM +0800, Liu Bo wrote:
> Lock end is inclusive.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/file.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 77061bf..1e16b6d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2241,6 +2241,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
>  	if (lockend <= lockstart)
>  		lockend = lockstart + root->sectorsize;
>  
> +	lockend--;
>  	len = lockend - lockstart + 1;
>  
>  	len = max_t(u64, len, root->sectorsize);

Fix looks ok. I think this should be caught at runtime as well, the
number of ways how the lock start and end are passed is not small and it
need not be always possible to catch it from reading sources. The range
is inclusive, so it's 'lock end % 2 == 1' right? (in the bit
manipulating primitives).

david

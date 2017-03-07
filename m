Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3508 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753129AbdCGA3n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 19:29:43 -0500
Subject: Re: [PATCH v2] Btrfs: fix unexpected file hole after disk errors
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
 <1488831810-26684-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9b5da944-13ec-ed01-5ff1-2cb813886e49@cn.fujitsu.com>
Date: Tue, 7 Mar 2017 08:28:58 +0800
MIME-Version: 1.0
In-Reply-To: <1488831810-26684-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/07/2017 04:23 AM, Liu Bo wrote:
> Btrfs creates hole extents to cover any unwritten section right before
> doing buffer writes after commit 3ac0d7b96a26 ("btrfs: Change the expanding
> write sequence to fix snapshot related bug.").
>
> However, that takes the start position of the buffered write to compare
> against the current EOF, hole extents would be created only if (EOF <
> start).
>
> If the EOF is at the middle of the buffered write, no hole extents will be
> created and a file hole without a hole extent is left in this file.
>
> This bug was revealed by generic/019 in fstests.  'fsstress' in this test
> may create the above situation and the test then fails all requests
> including writes, so the buffer write which is supposed to cover the
> hole (without the hole extent) couldn't make it on disk.  Running fsck
> against such btrfs ends up with detecting file extent holes.
>
> Things could be more serious, some stale data would be exposed to
> userspace if files with this kind of hole are truncated to a position of
> the hole, because the on-disk inode size is beyond the last extent in the
> file.
>
> This fixes the bug by comparing the end position against the EOF.
>
> Cc: David Sterba <dsterba@suse.cz>
> Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Looks good.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
> v2: update comments to be precise.
>
>  fs/btrfs/file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 520cb72..dcf0286 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1865,11 +1865,13 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	pos = iocb->ki_pos;
>  	count = iov_iter_count(from);
>  	start_pos = round_down(pos, fs_info->sectorsize);
> +	end_pos = round_up(pos + count, fs_info->sectorsize);
>  	oldsize = i_size_read(inode);
> -	if (start_pos > oldsize) {
> -		/* Expand hole size to cover write data, preventing empty gap */
> -		end_pos = round_up(pos + count,
> -				   fs_info->sectorsize);
> +	if (end_pos > oldsize) {
> +		/*
> +		 * Expand hole size to cover write data in order to prevent an
> +		 * empty gap in case of a write failure.
> +		 */
>  		err = btrfs_cont_expand(inode, oldsize, end_pos);
>  		if (err) {
>  			inode_unlock(inode);
>



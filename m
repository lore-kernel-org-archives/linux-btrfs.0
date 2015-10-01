Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54953 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbbJAOlz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:41:55 -0400
Subject: Re: [PATCH V5 01/13] Btrfs: __btrfs_buffered_write: Reserve/release
 extents aligned to block size
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608912-31667-2-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D4540.9090101@fb.com>
Date: Thu, 1 Oct 2015 10:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <1443608912-31667-2-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
> units. Fix this by doing reservation/releases in block size units.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>   fs/btrfs/file.c | 44 +++++++++++++++++++++++++++++++-------------
>   1 file changed, 31 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index b823fac..12ce401 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -499,7 +499,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
>   	loff_t isize = i_size_read(inode);
>
>   	start_pos = pos & ~((u64)root->sectorsize - 1);
> -	num_bytes = ALIGN(write_bytes + pos - start_pos, root->sectorsize);
> +	num_bytes = round_up(write_bytes + pos - start_pos, root->sectorsize);
>
>   	end_of_last_block = start_pos + num_bytes - 1;
>   	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
> @@ -1362,16 +1362,19 @@ fail:
>   static noinline int
>   lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
>   				size_t num_pages, loff_t pos,
> +				size_t write_bytes,
>   				u64 *lockstart, u64 *lockend,
>   				struct extent_state **cached_state)
>   {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	u64 start_pos;
>   	u64 last_pos;
>   	int i;
>   	int ret = 0;
>
> -	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
> -	last_pos = start_pos + ((u64)num_pages << PAGE_CACHE_SHIFT) - 1;
> +	start_pos = round_down(pos, root->sectorsize);
> +	last_pos = start_pos
> +		+ round_up(pos + write_bytes - start_pos, root->sectorsize) - 1;
>
>   	if (start_pos < inode->i_size) {
>   		struct btrfs_ordered_extent *ordered;
> @@ -1489,6 +1492,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>
>   	while (iov_iter_count(i) > 0) {
>   		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
> +		size_t sector_offset;
>   		size_t write_bytes = min(iov_iter_count(i),
>   					 nrptrs * (size_t)PAGE_CACHE_SIZE -
>   					 offset);
> @@ -1497,6 +1501,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>   		size_t reserve_bytes;
>   		size_t dirty_pages;
>   		size_t copied;
> +		size_t dirty_sectors;
> +		size_t num_sectors;
>
>   		WARN_ON(num_pages > nrptrs);
>
> @@ -1509,8 +1515,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>   			break;
>   		}
>
> -		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> +		sector_offset = pos & (root->sectorsize - 1);
> +		reserve_bytes = round_up(write_bytes + sector_offset,
> +				root->sectorsize);
> +
>   		ret = btrfs_check_data_free_space(inode, reserve_bytes, write_bytes);
> +
>   		if (ret == -ENOSPC &&
>   		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>   					      BTRFS_INODE_PREALLOC))) {
> @@ -1523,7 +1533,10 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>   				 */
>   				num_pages = DIV_ROUND_UP(write_bytes + offset,
>   							 PAGE_CACHE_SIZE);
> -				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> +				reserve_bytes = round_up(write_bytes
> +							+ sector_offset,
> +							root->sectorsize);
> +
>   				ret = 0;
>   			} else {
>   				ret = -ENOSPC;
> @@ -1558,8 +1571,8 @@ again:
>   			break;
>
>   		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
> -						      pos, &lockstart, &lockend,
> -						      &cached_state);
> +						pos, write_bytes, &lockstart,
> +						&lockend, &cached_state);
>   		if (ret < 0) {
>   			if (ret == -EAGAIN)
>   				goto again;
> @@ -1595,9 +1608,14 @@ again:
>   		 * we still have an outstanding extent for the chunk we actually
>   		 * managed to copy.
>   		 */
> -		if (num_pages > dirty_pages) {
> -			release_bytes = (num_pages - dirty_pages) <<
> -				PAGE_CACHE_SHIFT;
> +		num_sectors = reserve_bytes >> inode->i_blkbits;
> +		dirty_sectors = round_up(copied + sector_offset,
> +					root->sectorsize);
> +		dirty_sectors >>= inode->i_blkbits;
> +
> +		if (num_sectors > dirty_sectors) {
> +			release_bytes = (write_bytes - copied)
> +				& ~((u64)root->sectorsize - 1);
>   			if (copied > 0) {
>   				spin_lock(&BTRFS_I(inode)->lock);
>   				BTRFS_I(inode)->outstanding_extents++;
> @@ -1611,7 +1629,8 @@ again:
>   							     release_bytes);
>   		}
>
> -		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
> +		release_bytes = round_up(copied + sector_offset,
> +					root->sectorsize);
>
>   		if (copied > 0)
>   			ret = btrfs_dirty_pages(root, inode, pages,
> @@ -1632,8 +1651,7 @@ again:
>
>   		if (only_release_metadata && copied > 0) {
>   			lockstart = round_down(pos, root->sectorsize);
> -			lockend = lockstart +
> -				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
> +			lockend = round_up(pos + copied, root->sectorsize) - 1;
>
>   			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
>   				       lockend, EXTENT_NORESERVE, NULL,
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

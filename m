Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59381 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbHGERk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 00:17:40 -0400
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 7 Aug 2015 14:17:31 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id B777B2BB0060
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 14:17:28 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t774HJSM21102718
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 14:17:27 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t774Gtuq026755
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 14:16:56 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: Re: [PATCH 01/11] Btrfs: __btrfs_buffered_write: Reserve/release extents aligned to block size
Date: Fri, 07 Aug 2015 09:46:37 +0530
Message-ID: <11805820.gzp5AJPmpI@localhost.localdomain>
In-Reply-To: <55C4212E.90609@cn.fujitsu.com>
References: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com> <1438855819-4328-2-git-send-email-chandan@linux.vnet.ibm.com> <55C4212E.90609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 07 Aug 2015 11:08:30 Qu Wenruo wrote:
> Hi Chanda,
> 
> Thanks for your effort to implement sub pagesize block size.
> 
> These cleanups look quite good, but still some small readablity
> recommendation inlined below.
> 
> Chandan Rajendra wrote on 2015/08/06 15:40 +0530:
> > Currently, the code reserves/releases extents in multiples of
> > PAGE_CACHE_SIZE units. Fix this by doing reservation/releases in block
> > size units.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> >   fs/btrfs/file.c | 40 ++++++++++++++++++++++++++++------------
> >   1 file changed, 28 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 795d754..e3b2b3c 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > 
> > @@ -1362,16 +1362,19 @@ fail:
> >   static noinline int
> >   lock_and_cleanup_extent_if_need(struct inode *inode, struct page
> >   **pages,
> >   
> >   				size_t num_pages, loff_t pos,
> > 
> > +				size_t write_bytes,
> > 
> >   				u64 *lockstart, u64 *lockend,
> >   				struct extent_state **cached_state)
> >   
> >   {
> > 
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > 
> >   	u64 start_pos;
> >   	u64 last_pos;
> >   	int i;
> >   	int ret = 0;
> > 
> > -	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
> > -	last_pos = start_pos + ((u64)num_pages << PAGE_CACHE_SHIFT) - 1;
> > +	start_pos = pos & ~((u64)root->sectorsize - 1);
> 
> Why not just roundown(pos, root->sectorisze)
> Hard coded align is never that easy to read.

Qu Wenruo, Thanks for pointing it out. I will replace them with
round_[down,up] calls and post V2. 

> 
> > +	last_pos = start_pos
> > +		+ ALIGN(pos + write_bytes - start_pos, root->sectorsize) - 1;
> 
> Maybe just a preference problem, I'd prefer to use round_down other than
> ALIGN, as sometimes I still need to figure out if it is round_down or
> round_down.
> 
> >   	if (start_pos < inode->i_size) {
> >   	
> >   		struct btrfs_ordered_extent *ordered;
> > 
> > @@ -1489,6 +1492,7 @@ static noinline ssize_t
> > __btrfs_buffered_write(struct file *file,> 
> >   	while (iov_iter_count(i) > 0) {
> >   	
> >   		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
> > 
> > +		size_t sector_offset;
> > 
> >   		size_t write_bytes = min(iov_iter_count(i),
> >   		
> >   					 nrptrs * (size_t)PAGE_CACHE_SIZE -
> >   					 offset);
> > 
> > @@ -1497,6 +1501,8 @@ static noinline ssize_t
> > __btrfs_buffered_write(struct file *file,> 
> >   		size_t reserve_bytes;
> >   		size_t dirty_pages;
> >   		size_t copied;
> > 
> > +		size_t dirty_sectors;
> > +		size_t num_sectors;
> > 
> >   		WARN_ON(num_pages > nrptrs);
> > 
> > @@ -1509,8 +1515,12 @@ static noinline ssize_t
> > __btrfs_buffered_write(struct file *file,> 
> >   			break;
> >   		
> >   		}
> > 
> > -		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> > +		sector_offset = pos & (root->sectorsize - 1);
> 
> Same here.
> 
> Thanks,
> Qu
> 
> > +		reserve_bytes = ALIGN(write_bytes + sector_offset,
> > +				root->sectorsize);
> > +
> > 
> >   		ret = btrfs_check_data_free_space(inode, reserve_bytes, 
write_bytes);
> > 
> > +
> > 
> >   		if (ret == -ENOSPC &&
> >   		
> >   		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> >   		    
> >   					      BTRFS_INODE_PREALLOC))) {
> > 
> > @@ -1523,7 +1533,9 @@ static noinline ssize_t
> > __btrfs_buffered_write(struct file *file,> 
> >   				 */
> >   				
> >   				num_pages = DIV_ROUND_UP(write_bytes + offset,
> >   				
> >   							 PAGE_CACHE_SIZE);
> > 
> > -				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> > +				reserve_bytes = ALIGN(write_bytes + 
sector_offset,
> > +						root->sectorsize);
> > +
> > 
> >   				ret = 0;
> >   			
> >   			} else {
> >   			
> >   				ret = -ENOSPC;
> > 
> > @@ -1558,8 +1570,8 @@ again:
> >   			break;
> >   		
> >   		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
> > 
> > -						      pos, &lockstart, 
&lockend,
> > -						      &cached_state);
> > +						pos, write_bytes, &lockstart,
> > +						&lockend, &cached_state);
> > 
> >   		if (ret < 0) {
> >   		
> >   			if (ret == -EAGAIN)
> >   			
> >   				goto again;
> > 
> > @@ -1595,9 +1607,14 @@ again:
> >   		 * we still have an outstanding extent for the chunk we 
actually
> >   		 * managed to copy.
> >   		 */
> > 
> > -		if (num_pages > dirty_pages) {
> > -			release_bytes = (num_pages - dirty_pages) <<
> > -				PAGE_CACHE_SHIFT;
> > +		num_sectors = reserve_bytes >> inode->i_blkbits;
> > +		dirty_sectors = round_up(copied + sector_offset,
> > +					root->sectorsize);
> > +		dirty_sectors >>= inode->i_blkbits;
> > +
> > +		if (num_sectors > dirty_sectors) {
> > +			release_bytes = (write_bytes - copied)
> > +				& ~((u64)root->sectorsize - 1);
> > 
> >   			if (copied > 0) {
> >   			
> >   				spin_lock(&BTRFS_I(inode)->lock);
> >   				BTRFS_I(inode)->outstanding_extents++;
> > 
> > @@ -1611,7 +1628,7 @@ again:
> >   							     release_bytes);
> >   		
> >   		}
> > 
> > -		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
> > +		release_bytes = ALIGN(copied + sector_offset, root-
>sectorsize);
> > 
> >   		if (copied > 0)
> >   		
> >   			ret = btrfs_dirty_pages(root, inode, pages,
> > 
> > @@ -1632,8 +1649,7 @@ again:
> >   		if (only_release_metadata && copied > 0) {
> >   		
> >   			lockstart = round_down(pos, root->sectorsize);
> > 
> > -			lockend = lockstart +
> > -				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
> > +			lockend = round_up(pos + copied, root->sectorsize) - 
1;
> > 
> >   			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> >   			
> >   				       lockend, EXTENT_NORESERVE, NULL,

-- 
chandan


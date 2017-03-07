Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:47117 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755877AbdCGVb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 16:31:26 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27L18mM020673
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 21:01:08 GMT
Date: Tue, 7 Mar 2017 12:59:38 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
Message-ID: <20170307205937.GF12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170306025547.1858-1-quwenruo@cn.fujitsu.com>
 <20170307204958.GD12408@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307204958.GD12408@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 12:49:58PM -0800, Liu Bo wrote:
> On Mon, Mar 06, 2017 at 10:55:46AM +0800, Qu Wenruo wrote:
> > [BUG]
> > When btrfs_reloc_clone_csum() reports error, it can underflow metadata
> > and leads to kernel assertion on outstanding extents in
> > run_delalloc_nocow() and cow_file_range().
> > 
> >  BTRFS info (device vdb5): relocating block group 12582912 flags data
> >  BTRFS info (device vdb5): found 1 extents
> >  assertion failed: inode->outstanding_extents >= num_extents, file: fs/btrfs//extent-tree.c, line: 5858
> > 
> > Currently, due to another bug blocking ordered extents, the bug is only
> > reproducible under certain block group layout and using error injection.
> > 
> > a) Create one data block group with one 4K extent in it.
> >    To avoid the bug that hangs btrfs due to ordered extent which never
> >    finishes
> > b) Make btrfs_reloc_clone_csum() always fail
> > c) Relocate that block group
> > 
> > [CAUSE]
> > run_delalloc_nocow() and cow_file_range() handles error from
> > btrfs_reloc_clone_csum() wrongly:
> > 
> > (The ascii chart shows a more generic case of this bug other than the
> > bug mentioned above)
> > 
> > |<------------------ delalloc range --------------------------->|
> > | OE 1 | OE 2 | ... | OE n |
> >                     |<----------- cleanup range --------------->|
> > |<-----------  ----------->|
> >              \/
> >  btrfs_finish_ordered_io() range
> > 
> > So error handler, which calls extent_clear_unlock_delalloc() with
> > EXTENT_DELALLOC and EXTENT_DO_ACCOUNT bits, and btrfs_finish_ordered_io()
> > will both cover OE n, and free its metadata, causing metadata under flow.
> > 
> > [Fix]
> > The fix is to ensure after calling btrfs_add_ordered_extent(), we only
> > call error handler after increasing the iteration offset, so that
> > cleanup range won't cover any created ordered extent.
> > 
> > |<------------------ delalloc range --------------------------->|
> > | OE 1 | OE 2 | ... | OE n |
> > |<-----------  ----------->|<---------- cleanup range --------->|
> >              \/
> >  btrfs_finish_ordered_io() range
> > 
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > ---
> > changelog:
> > v6:
> >   New, split from v5 patch, as this is a separate bug.
> > ---
> >  fs/btrfs/inode.c | 51 +++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 39 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index b2bc07aad1ae..1d83d504f2e5 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -998,15 +998,24 @@ static noinline int cow_file_range(struct inode *inode,
> >  		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
> >  			ret = btrfs_reloc_clone_csums(inode, start,
> >  						      cur_alloc_size);
> > +			/*
> > +			 * Only drop cache here, and process as normal.
> > +			 *
> > +			 * We must not allow extent_clear_unlock_delalloc()
> > +			 * at out_unlock label to free meta of this ordered
> > +			 * extent, as its meta should be freed by
> > +			 * btrfs_finish_ordered_io().
> > +			 *
> > +			 * So we must continue until @start is increased to
> > +			 * skip current ordered extent.
> > +			 */
> >  			if (ret)
> > -				goto out_drop_extent_cache;
> > +				btrfs_drop_extent_cache(BTRFS_I(inode), start,
> > +						start + ram_size - 1, 0);
> >  		}
> >  
> >  		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> >  
> > -		if (disk_num_bytes < cur_alloc_size)
> > -			break;
> > -
> >  		/* we're not doing compressed IO, don't unlock the first
> >  		 * page (which the caller expects to stay locked), don't
> >  		 * clear any dirty bits and don't set any writeback bits
> > @@ -1022,10 +1031,21 @@ static noinline int cow_file_range(struct inode *inode,
> >  					     delalloc_end, locked_page,
> >  					     EXTENT_LOCKED | EXTENT_DELALLOC,
> >  					     op);
> > -		disk_num_bytes -= cur_alloc_size;
> > +		if (disk_num_bytes > cur_alloc_size)
> > +			disk_num_bytes = 0;
> > +		else
> > +			disk_num_bytes -= cur_alloc_size;
> 
> I don't get the logic here, why do we 'break' if disk_num_bytes > cur_alloc_size?

I assume that you've run fstests against this patch, if so, I actually
start worrying about that no fstests found this problem.

Thanks,

-liubo

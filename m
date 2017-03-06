Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20729 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbdCFWVc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 17:21:32 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26LB5xp030608
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Mar 2017 21:11:06 GMT
Date: Mon, 6 Mar 2017 13:09:29 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/2] Btrfs: remove start_pos
Message-ID: <20170306210929.GE13180@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
 <1488330280-22678-2-git-send-email-bo.li.liu@oracle.com>
 <48a869a9-86fc-188f-58bf-8132138f94a2@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48a869a9-86fc-188f-58bf-8132138f94a2@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 01, 2017 at 04:48:20PM +0800, Qu Wenruo wrote:
> 
> 
> At 03/01/2017 09:04 AM, Liu Bo wrote:
> > @pos, not aligned @start_pos, should be used to check whether the eof page
> > needs to be marked as readonly, thus @start_pos can be removed.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/file.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 0be837b..ef88e6d 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1814,7 +1814,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  	struct inode *inode = file_inode(file);
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> > -	u64 start_pos;
> >  	u64 end_pos;
> >  	ssize_t num_written = 0;
> >  	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
> > @@ -1822,7 +1821,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  	loff_t pos;
> >  	size_t count;
> >  	loff_t oldsize;
> > -	int clean_page = 0;
> > 
> >  	inode_lock(inode);
> >  	err = generic_write_checks(iocb, from);
> > @@ -1860,7 +1858,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> > 
> >  	pos = iocb->ki_pos;
> >  	count = iov_iter_count(from);
> > -	start_pos = round_down(pos, fs_info->sectorsize);
> >  	end_pos = round_up(pos + count, fs_info->sectorsize);
> >  	oldsize = i_size_read(inode);
> >  	if (end_pos > oldsize) {
> > @@ -1870,8 +1867,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  			inode_unlock(inode);
> >  			goto out;
> >  		}
> > -		if (start_pos > round_up(oldsize, fs_info->sectorsize))
> > -			clean_page = 1;
> >  	}
> > 
> >  	if (sync)
> > @@ -1883,7 +1878,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  		num_written = __btrfs_buffered_write(file, from, pos);
> >  		if (num_written > 0)
> >  			iocb->ki_pos = pos + num_written;
> > -		if (clean_page)
> > +		if (oldsize < pos)
> >  			pagecache_isize_extended(inode, oldsize,
> >  						i_size_read(inode));
> 
> Not familiar with page cache, so I can be totally wrong here.
> 
> But what will happen if @oldsize and @pos are in the same page?
> 
> For example:
> Page start                                    Page start + 4K
> |             |                |              |
>               old size         pos
> 
> Do we still need to call pagecache_iszie_extented() since we will dirty that
> page anyway?

Yes, isize has changed, if blocksize < pagesize, so it's still possible that the
next write access to the new isize doesn't own an block since no page_mkwrite()
has been called to allocate it, then a following writepage() may fail silently
from userspace's view (unless they run fsync and check its ret).

Thanks,

-liubo

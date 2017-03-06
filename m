Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:44015 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdCGE6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 23:58:24 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26JSsDQ017891
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Mar 2017 19:28:54 GMT
Date: Mon, 6 Mar 2017 11:27:16 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] Btrfs: fix unexpected file hole after disk errors
Message-ID: <20170306192715.GB13180@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
 <4e9c24e7-1d44-47ec-4246-07171c2544f0@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4e9c24e7-1d44-47ec-4246-07171c2544f0@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 01, 2017 at 10:44:53AM +0800, Qu Wenruo wrote:
> 
> 
> At 03/01/2017 09:04 AM, Liu Bo wrote:
> > Btrfs creates hole extents to cover any unwritten section right before
> > doing buffer writes after commit 3ac0d7b96a26 ("btrfs: Change the expanding
> > write sequence to fix snapshot related bug.").
> > 
> > However, that takes the start position of the buffered write to compare
> > against the current EOF, hole extents would be created only if (EOF <
> > start).
> > 
> > If the EOF is at the middle of the buffered write, no hole extents will be
> > created and a file hole without a hole extent is left in this file.
> > 
> > This bug was revealed by generic/019 in fstests.  'fsstress' in this test
> > may create the above situation and the test then fails all requests
> > including writes, so the buffer write which is supposed to cover the
> > hole (without the hole extent) couldn't make it on disk.  Running fsck
> > against such btrfs ends up with detecting file extent holes.
> > 
> > Things could be more serious, some stale data would be exposed to
> > userspace if files with this kind of hole are truncated to a position of
> > the hole, because the on-disk inode size is beyond the last extent in the
> > file.
> > 
> > This fixes the bug by comparing the end position against the EOF.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Patch looks good to me.
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> > ---
> >  fs/btrfs/file.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index b5c5da2..0be837b 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1861,11 +1861,10 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  	pos = iocb->ki_pos;
> >  	count = iov_iter_count(from);
> >  	start_pos = round_down(pos, fs_info->sectorsize);
> > +	end_pos = round_up(pos + count, fs_info->sectorsize);
> >  	oldsize = i_size_read(inode);
> > -	if (start_pos > oldsize) {
> > +	if (end_pos > oldsize) {
> >  		/* Expand hole size to cover write data, preventing empty gap */
> 
> The comment still makes sense here, but it could be better to explain why to
> insert the hole to cover the whole write range (in case write fails)
>

Sounds good, I'll update.

Thanks,

-liubo

> Thanks,
> Qu
> 
> > -		end_pos = round_up(pos + count,
> > -				   fs_info->sectorsize);
> >  		err = btrfs_cont_expand(inode, oldsize, end_pos);
> >  		if (err) {
> >  			inode_unlock(inode);
> > 
> 
> 

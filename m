Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751120AbdINMuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 08:50:35 -0400
Date: Thu, 14 Sep 2017 14:49:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not backup tree roots when fsync
Message-ID: <20170914124903.GU29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
 <a89cb387-732a-199e-5589-828c7e68b2a3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <a89cb387-732a-199e-5589-828c7e68b2a3@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 14, 2017 at 09:55:48AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月14日 02:25, Liu Bo wrote:
> > It doens't make sense to backup tree roots when doing fsync, since
> > during fsync those tree roots have not been consistent on disk.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> 
> With a pit can be improved.
> > ---
> >   fs/btrfs/disk-io.c | 9 ++++++++-
> >   1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 79ac228..a145a88 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3668,7 +3668,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >   	u64 flags;
> >   
> >   	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
> > -	backup_super_roots(fs_info);
> > +
> > +	/*
> > +	 * max_mirrors == 0 indicates we're from commit_transaction,
> > +	 * not from fsync where the tree roots in fs_info have not
> > +	 * been consistent on disk.
> > +	 */
> > +	if (max_mirrors == 0)
> > +		backup_super_roots(fs_info);
> 
> BTW, the @max_mirrors naming here is really confusing.
> Normally I would expect max_mirrors == 0 means we don't need to backup 
> super roots...

Agreed it's confusing, could be something like "bool write_backups" (in a
separate patch).

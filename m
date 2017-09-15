Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24976 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdIOWKi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 18:10:38 -0400
Date: Fri, 15 Sep 2017 15:09:05 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not backup tree roots when fsync
Message-ID: <20170915210905.GC16835@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
 <a89cb387-732a-199e-5589-828c7e68b2a3@gmx.com>
 <20170914124903.GU29043@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170914124903.GU29043@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 14, 2017 at 02:49:03PM +0200, David Sterba wrote:
> On Thu, Sep 14, 2017 at 09:55:48AM +0800, Qu Wenruo wrote:
> > 
> > 
> > On 2017年09月14日 02:25, Liu Bo wrote:
> > > It doens't make sense to backup tree roots when doing fsync, since
> > > during fsync those tree roots have not been consistent on disk.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> > 
> > With a pit can be improved.
> > > ---
> > >   fs/btrfs/disk-io.c | 9 ++++++++-
> > >   1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > > index 79ac228..a145a88 100644
> > > --- a/fs/btrfs/disk-io.c
> > > +++ b/fs/btrfs/disk-io.c
> > > @@ -3668,7 +3668,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> > >   	u64 flags;
> > >   
> > >   	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
> > > -	backup_super_roots(fs_info);
> > > +
> > > +	/*
> > > +	 * max_mirrors == 0 indicates we're from commit_transaction,
> > > +	 * not from fsync where the tree roots in fs_info have not
> > > +	 * been consistent on disk.
> > > +	 */
> > > +	if (max_mirrors == 0)
> > > +		backup_super_roots(fs_info);
> > 
> > BTW, the @max_mirrors naming here is really confusing.
> > Normally I would expect max_mirrors == 0 means we don't need to backup 
> > super roots...
> 
> Agreed it's confusing, could be something like "bool write_backups" (in a
> separate patch).

Good point, will do in a separate one, thanks to both for the
comments.

Thanks,

-liubo

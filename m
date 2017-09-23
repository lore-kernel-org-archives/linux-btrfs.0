Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16399 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdIWAwZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 20:52:25 -0400
Date: Fri, 22 Sep 2017 17:48:37 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use self-explaining variable
Message-ID: <20170923004837.GD8109@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
 <20170922233618.20034-1-bo.li.liu@oracle.com>
 <4d9fe9dd-ccde-964c-ea88-bce4eeafc81a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4d9fe9dd-ccde-964c-ea88-bce4eeafc81a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 23, 2017 at 08:46:55AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月23日 07:36, Liu Bo wrote:
> > This uses a bool 'do_backup' to help understand this piece of code.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > This is based on a patch "Btrfs: do not backup tree roots when fsync".
> > 
> >   fs/btrfs/disk-io.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index cdb7043..9811b9d 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3691,6 +3691,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >   	int max_errors;
> >   	int total_errors = 0;
> >   	u64 flags;
> > +	bool do_backup = (max_mirrors == 0);
> 
> Why not replacing @max_mirrors with @do_backup as parameter?

If I read the code correctly, max_mirrors is not just for deciding
backup.

thanks,

-liubo

> 
> Thanks,
> Qu
> >   	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
> > @@ -3699,7 +3700,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >   	 * not from fsync where the tree roots in fs_info have not
> >   	 * been consistent on disk.
> >   	 */
> > -	if (max_mirrors == 0)
> > +	if (do_backup)
> >   		backup_super_roots(fs_info);
> >   	sb = fs_info->super_for_commit;
> > 

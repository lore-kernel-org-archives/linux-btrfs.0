Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16957 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbdJKSE0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 14:04:26 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9BI4PZm009316
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:04:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9BI4PoW016802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:04:25 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9BI4PXN004381
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 18:04:25 GMT
Date: Wed, 11 Oct 2017 11:02:49 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove rcu_barrier in btrfs_close_devices
Message-ID: <20171011170249.GC16979@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171010215103.20828-1-bo.li.liu@oracle.com>
 <ad0d4003-ef66-1da7-a27f-03837d839c11@oracle.com>
 <82a3be82-f2a9-d0bd-b34c-71f98df0e571@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <82a3be82-f2a9-d0bd-b34c-71f98df0e571@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 03:41:23PM +0800, Anand Jain wrote:
> 
> 
> On 10/11/2017 02:11 PM, Anand Jain wrote:
> > 
> > 
> > On 10/11/2017 05:51 AM, Liu Bo wrote:
> > > It was introduced because btrfs used to do blkdev_put in a deferred
> > > work, now that btrfs has put blkdev in place, this rcu_barrier can be
> > > removed.
> 
>  On the 2nd thought, modprobe -r btrfs would still need rcu_barrier(), some
> where else outside of umount context ?

Thanks a lot for the comments.

modprobe -r btrfs will do btrfs_cleanup_fs_uuids(), where it cleanup
every %fs_devices on the list, but when we do btrfs_close_devices(), we
have replaced the devices on the list with dummy ones which only have
the same name and uuid, so modprobe -r btrfs will free those instead
of what we were using, this change won't cause a problem for it.

Thanks,

-liubo
> 
> Thanks, Anand
> 
> 
> >   Reviewed-by: Anand Jain <anand.jain@oracle.com>
> > 
> > Thanks, Anand
> > 
> > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > >   fs/btrfs/volumes.c | 6 ------
> > >   1 file changed, 6 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > > index 0e8f16c..d983cea 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -958,12 +958,6 @@ int btrfs_close_devices(struct btrfs_fs_devices
> > > *fs_devices)
> > >           __btrfs_close_devices(fs_devices);
> > >           free_fs_devices(fs_devices);
> > >       }
> > > -    /*
> > > -     * Wait for rcu kworkers under __btrfs_close_devices
> > > -     * to finish all blkdev_puts so device is really
> > > -     * free when umount is done.
> > > -     */
> > > -    rcu_barrier();
> > >       return ret;
> > >   }
> > > 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45001 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754075AbcLXD2H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 22:28:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBO3Nkj9014021
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 22:28:06 -0500
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [125.16.236.2])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27ha0v4yh8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 22:28:06 -0500
Received: from localhost
        by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 24 Dec 2016 08:58:02 +0530
Received: from d28relay10.in.ibm.com (d28relay10.in.ibm.com [9.184.220.161])
        by d28dlp01.in.ibm.com (Postfix) with ESMTP id 22487E0045
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 08:58:45 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
        by d28relay10.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBO3RIuu27525264
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 08:57:18 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
        by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBO3Rx0t002554
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 08:57:59 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Date: Sat, 24 Dec 2016 08:57:57 +0530
In-Reply-To: <20161224001800.GA11160@localhost.localdomain>
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com> <2606394.PBVynvYKAF@localhost.localdomain> <20161224001800.GA11160@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2187945.uQQICUOxo6@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 23, 2016 04:18:00 PM Liu Bo wrote:
> On Fri, Dec 23, 2016 at 05:27:55PM +0530, Chandan Rajendra wrote:
> > On Friday, December 23, 2016 03:57:40 PM Chandan Rajendra wrote:
> > > On Friday, December 23, 2016 03:00:18 PM Chandan Rajendra wrote:
> > > > The following deadlock is seen when executing generic/113 test,
> > > > 
> > > >  ---------------------------------------------------------+----------------------------------------------------
> > > >   Direct I/O task                                           Fast fsync task
> > > >  ---------------------------------------------------------+----------------------------------------------------
> > > >   btrfs_direct_IO
> > > >     __blockdev_direct_IO
> > > >      do_blockdev_direct_IO
> > > >       do_direct_IO
> > > >        btrfs_get_blocks_direct
> > > >         while (blocks needs to written)
> > > >          get_more_blocks (first iteration)
> > > >           btrfs_get_blocks_direct
> > > >            btrfs_create_dio_extent
> > > >              down_read(&BTRFS_I(inode) >dio_sem)
> > > >              Create and add extent map and ordered extent
> > > >              up_read(&BTRFS_I(inode) >dio_sem)
> > > >                                                             btrfs_sync_file
> > > >                                                               btrfs_log_dentry_safe
> > > >                                                                btrfs_log_inode_parent
> > > >                                                                 btrfs_log_inode
> > > >                                                                  btrfs_log_changed_extents
> > > >                                                                   down_write(&BTRFS_I(inode) >dio_sem)
> > > >                                                                    Collect new extent maps and ordered extents
> > > >                                                                     wait for ordered extent completion
> > > >          get_more_blocks (second iteration)
> > > >           btrfs_get_blocks_direct
> > > >            btrfs_create_dio_extent
> > > >              down_read(&BTRFS_I(inode) >dio_sem)
> > > >  --------------------------------------------------------------------------------------------------------------
> > > > 
> > > > In the above description, Btrfs direct I/O code path has not yet started
> > > > submitting bios for file range covered by the initial ordered
> > > > extent. Meanwhile, The fast fsync task obtains the write semaphore and
> > > > waits for I/O on the ordered extent to get completed. However, the
> > > > Direct I/O task is now blocked on obtaining the read semaphore.
> > > > 
> > > > To resolve the deadlock, this commit modifies the Direct I/O code path
> > > > to obtain the read semaphore before invoking
> > > > __blockdev_direct_IO(). The semaphore is then given up after
> > > > __blockdev_direct_IO() returns. This allows the Direct I/O code to
> > > > complete I/O on all the ordered extents it creates.
> > > >
> > > 
> > > Btw, I was able to reproduce the issue on kdave/for-next branch with "Merge
> > > branch 'for-next-next-4.9-20161125' into for-next-20161125" as the topmost
> > > commit. The issue cannot be reproduced yet on latest code available from
> > > kdave/for-next branch.
> > > 
> > >
> > 
> > Maybe changes in upstream might have masked the issue in the recent
> > kdave/for-next branch. I say that because 'git bisect' resulted in the
> > following commit ...
> 
> I guess that the for-next branch didn't revert this patch[1] as upstream
> did, so that generic/113 would complain, however, even w/o that patch,
> this fix is still required since the deadlock could be reproduced by
> running generic/113 with '-ofragment=data' and in fact Filipe has
> proposed a almost same fix but not a real patch in this thread [2].
> 
> [1]: Btrfs: adjust len of writes if following a preallocated extent
> https://patchwork.kernel.org/patch/9413129/
> [2]: https://patchwork.kernel.org/patch/9445231/
>

Ah ok. Thanks for pointing it out.

-- 
chandan


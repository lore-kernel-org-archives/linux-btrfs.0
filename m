Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751500AbcLWL6O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 06:58:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBNBrtR8106769
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 06:58:13 -0500
Received: from e28smtp01.in.ibm.com (e28smtp01.in.ibm.com [125.16.236.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27guk8fkv0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 06:58:13 -0500
Received: from localhost
        by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 23 Dec 2016 17:28:09 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
        by d28dlp02.in.ibm.com (Postfix) with ESMTP id D79FB394005C
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 17:28:06 +0530 (IST)
Received: from d28av07.in.ibm.com (d28av07.in.ibm.com [9.184.220.146])
        by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBNBvxkv27984012
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 17:28:00 +0530
Received: from d28av07.in.ibm.com (localhost [127.0.0.1])
        by d28av07.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBNBvw1L022976
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 17:27:58 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Date: Fri, 23 Dec 2016 17:27:55 +0530
In-Reply-To: <25132456.GqS7QuRSzf@localhost.localdomain>
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com> <25132456.GqS7QuRSzf@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2606394.PBVynvYKAF@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 23, 2016 03:57:40 PM Chandan Rajendra wrote:
> On Friday, December 23, 2016 03:00:18 PM Chandan Rajendra wrote:
> > The following deadlock is seen when executing generic/113 test,
> > 
> >  ---------------------------------------------------------+----------------------------------------------------
> >   Direct I/O task                                           Fast fsync task
> >  ---------------------------------------------------------+----------------------------------------------------
> >   btrfs_direct_IO
> >     __blockdev_direct_IO
> >      do_blockdev_direct_IO
> >       do_direct_IO
> >        btrfs_get_blocks_direct
> >         while (blocks needs to written)
> >          get_more_blocks (first iteration)
> >           btrfs_get_blocks_direct
> >            btrfs_create_dio_extent
> >              down_read(&BTRFS_I(inode) >dio_sem)
> >              Create and add extent map and ordered extent
> >              up_read(&BTRFS_I(inode) >dio_sem)
> >                                                             btrfs_sync_file
> >                                                               btrfs_log_dentry_safe
> >                                                                btrfs_log_inode_parent
> >                                                                 btrfs_log_inode
> >                                                                  btrfs_log_changed_extents
> >                                                                   down_write(&BTRFS_I(inode) >dio_sem)
> >                                                                    Collect new extent maps and ordered extents
> >                                                                     wait for ordered extent completion
> >          get_more_blocks (second iteration)
> >           btrfs_get_blocks_direct
> >            btrfs_create_dio_extent
> >              down_read(&BTRFS_I(inode) >dio_sem)
> >  --------------------------------------------------------------------------------------------------------------
> > 
> > In the above description, Btrfs direct I/O code path has not yet started
> > submitting bios for file range covered by the initial ordered
> > extent. Meanwhile, The fast fsync task obtains the write semaphore and
> > waits for I/O on the ordered extent to get completed. However, the
> > Direct I/O task is now blocked on obtaining the read semaphore.
> > 
> > To resolve the deadlock, this commit modifies the Direct I/O code path
> > to obtain the read semaphore before invoking
> > __blockdev_direct_IO(). The semaphore is then given up after
> > __blockdev_direct_IO() returns. This allows the Direct I/O code to
> > complete I/O on all the ordered extents it creates.
> >
> 
> Btw, I was able to reproduce the issue on kdave/for-next branch with "Merge
> branch 'for-next-next-4.9-20161125' into for-next-20161125" as the topmost
> commit. The issue cannot be reproduced yet on latest code available from
> kdave/for-next branch.
> 
>

Maybe changes in upstream might have masked the issue in the recent
kdave/for-next branch. I say that because 'git bisect' resulted in the
following commit ...

e3597e6090ddf40904dce6d0a5a404e2c490cac6
Author:     Chris Mason <clm@fb.com>
AuthorDate: Tue Nov 1 12:54:45 2016 -0700
Commit:     Chris Mason <clm@fb.com>
CommitDate: Tue Nov 1 12:54:45 2016 -0700

Parent:     570dd45 btrfs: fix races on root_log_ctx lists
Parent:     9d1032c btrfs: fix WARNING in btrfs_select_ref_head()
Merged:     btrfs-next-for-linus-4.8 kdave-master linus-v4.7-rc6 local-v4.7-rc4
Containing: direct-io-fsync-deadlock kdave-for-next
Follows:    v4.8-rc8 (57)
Precedes:   next-20161219 (30006)

Merge branch 'for-4.9-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.9

5 files changed, 29 insertions(+), 9 deletions(-)
fs/btrfs/extent-tree.c |  3 +++
fs/btrfs/extent_io.c   |  8 ++++----
fs/btrfs/inode.c       | 13 +++++++++----
fs/btrfs/ioctl.c       |  5 +++++
fs/btrfs/relocation.c  |  9 ++++++++-

-- 
chandan


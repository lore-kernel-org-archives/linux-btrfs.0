Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58621 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758335AbcLWK1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 05:27:51 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBNANwLE092918
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 05:27:50 -0500
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27gwmmhdcq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 05:27:50 -0500
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 23 Dec 2016 20:27:47 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp01.au.ibm.com (Postfix) with ESMTP id 84DE82CE8046
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 21:27:44 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBNARiP150987188
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 21:27:44 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBNARiQ3030822
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 21:27:44 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Date: Fri, 23 Dec 2016 15:57:40 +0530
In-Reply-To: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <25132456.GqS7QuRSzf@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 23, 2016 03:00:18 PM Chandan Rajendra wrote:
> The following deadlock is seen when executing generic/113 test,
> 
>  ---------------------------------------------------------+----------------------------------------------------
>   Direct I/O task                                           Fast fsync task
>  ---------------------------------------------------------+----------------------------------------------------
>   btrfs_direct_IO
>     __blockdev_direct_IO
>      do_blockdev_direct_IO
>       do_direct_IO
>        btrfs_get_blocks_direct
>         while (blocks needs to written)
>          get_more_blocks (first iteration)
>           btrfs_get_blocks_direct
>            btrfs_create_dio_extent
>              down_read(&BTRFS_I(inode) >dio_sem)
>              Create and add extent map and ordered extent
>              up_read(&BTRFS_I(inode) >dio_sem)
>                                                             btrfs_sync_file
>                                                               btrfs_log_dentry_safe
>                                                                btrfs_log_inode_parent
>                                                                 btrfs_log_inode
>                                                                  btrfs_log_changed_extents
>                                                                   down_write(&BTRFS_I(inode) >dio_sem)
>                                                                    Collect new extent maps and ordered extents
>                                                                     wait for ordered extent completion
>          get_more_blocks (second iteration)
>           btrfs_get_blocks_direct
>            btrfs_create_dio_extent
>              down_read(&BTRFS_I(inode) >dio_sem)
>  --------------------------------------------------------------------------------------------------------------
> 
> In the above description, Btrfs direct I/O code path has not yet started
> submitting bios for file range covered by the initial ordered
> extent. Meanwhile, The fast fsync task obtains the write semaphore and
> waits for I/O on the ordered extent to get completed. However, the
> Direct I/O task is now blocked on obtaining the read semaphore.
> 
> To resolve the deadlock, this commit modifies the Direct I/O code path
> to obtain the read semaphore before invoking
> __blockdev_direct_IO(). The semaphore is then given up after
> __blockdev_direct_IO() returns. This allows the Direct I/O code to
> complete I/O on all the ordered extents it creates.
>

Btw, I was able to reproduce the issue on kdave/for-next branch with "Merge
branch 'for-next-next-4.9-20161125' into for-next-20161125" as the topmost
commit. The issue cannot be reproduced yet on latest code available from
kdave/for-next branch.

-- 
chandan


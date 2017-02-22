Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59455 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754569AbdBVJcZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 04:32:25 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1M9Spv2070330
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 04:32:23 -0500
Received: from e28smtp04.in.ibm.com (e28smtp04.in.ibm.com [125.16.236.4])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28s6qeba0a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 04:32:23 -0500
Received: from localhost
        by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 22 Feb 2017 15:02:20 +0530
Received: from d28relay07.in.ibm.com (d28relay07.in.ibm.com [9.184.220.158])
        by d28dlp03.in.ibm.com (Postfix) with ESMTP id D6D72125805C
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 15:02:23 +0530 (IST)
Received: from d28av07.in.ibm.com (d28av07.in.ibm.com [9.184.220.146])
        by d28relay07.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1M9VDiS18874566
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 15:01:13 +0530
Received: from d28av07.in.ibm.com (localhost [127.0.0.1])
        by d28av07.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1M9WF1D025734
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 15:02:16 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/311: Disable dmesg check
Date: Wed, 22 Feb 2017 15:02:10 +0530
In-Reply-To: <44614455-beac-5191-59c8-2bda3cd14881@oracle.com>
References: <1437109003-2357-1-git-send-email-chandan@linux.vnet.ibm.com> <44614455-beac-5191-59c8-2bda3cd14881@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2485150.WmAGPpieTt@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, February 20, 2017 11:03:11 PM Anand Jain wrote:
> 
> Hi Chandan,
> 
> On 07/17/15 12:56, Chandan Rajendra wrote:
> > When running generic/311 on Btrfs' subpagesize-blocksize patchset (on ppc64
> > with 4k sectorsize and 16k node/leaf size) I noticed the following call trace,
> >
> > BTRFS (device dm-0): parent transid verify failed on 29720576 wanted 160 found 158
> > BTRFS (device dm-0): parent transid verify failed on 29720576 wanted 160 found 158
> > BTRFS: Transaction aborted (error -5)
> >
> > WARNING: at /root/repos/linux/fs/btrfs/super.c:260
> > Modules linked in:
> > CPU: 3 PID: 30769 Comm: umount Tainted: G        W    L 4.0.0-rc5-11671-g8b82e73e #63
> > task: c000000079aaddb0 ti: c000000079a48000 task.ti: c000000079a48000
> > NIP: c000000000499aa0 LR: c000000000499a9c CTR: c000000000779630
> > REGS: c000000079a4b480 TRAP: 0700   Tainted: G        W   L   (4.0.0-rc5-11671-g8b82e73e)
> > MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 28008828  XER: 20000000
> > CFAR: c000000000a23914 SOFTE: 1
> > GPR00: c000000000499a9c c000000079a4b700 c00000000103bdf8 0000000000000025
> > GPR04: 0000000000000001 0000000000000502 c00000000107e918 0000000000000cda
> > GPR08: 0000000000000007 0000000000000007 0000000000000001 c0000000010f5044
> > GPR12: 0000000028008822 c00000000fdc0d80 0000000020000000 0000000010152e00
> > GPR16: 0000010002979380 0000000010140724 0000000000000000 0000000000000000
> > GPR20: ffffffffffffffff 0000000000000000 0000000000000000 0000000000000000
> > GPR24: c0000000151f61a8 0000000000000000 c000000055e5e800 c000000000aac270
> > GPR28: 00000000000004a4 fffffffffffffffb c000000055e5e800 c0000000679204d0
> > NIP [c000000000499aa0] .__btrfs_abort_transaction+0x180/0x190
> > LR [c000000000499a9c] .__btrfs_abort_transaction+0x17c/0x190
> > Call Trace:
> > [c000000079a4b700] [c000000000499a9c] .__btrfs_abort_transaction+0x17c/0x190 (unreliable)
> > [c000000079a4b7a0] [c000000000541678] .__btrfs_run_delayed_items+0xe8/0x220
> > [c000000079a4b850] [c0000000004d5b3c] .btrfs_commit_transaction+0x37c/0xca0
> > [c000000079a4b960] [c00000000049824c] .btrfs_sync_fs+0x6c/0x1a0
> > [c000000079a4ba00] [c000000000255270] .sync_filesystem+0xd0/0x100
> > [c000000079a4ba80] [c000000000218070] .generic_shutdown_super+0x40/0x170
> > [c000000079a4bb10] [c000000000218598] .kill_anon_super+0x18/0x30
> > [c000000079a4bb90] [c000000000498418] .btrfs_kill_super+0x18/0xc0
> > [c000000079a4bc10] [c000000000218ac8] .deactivate_locked_super+0x98/0xe0
> > [c000000079a4bc90] [c00000000023e744] .cleanup_mnt+0x54/0xa0
> > [c000000079a4bd10] [c0000000000b7d14] .task_work_run+0x114/0x150
> > [c000000079a4bdb0] [c000000000015f84] .do_notify_resume+0x74/0x80
> > [c000000079a4be30] [c000000000009838] .ret_from_except_lite+0x64/0x68
> > Instruction dump:
> > ebc1fff0 ebe1fff8 4bfffb28 60000000 3ce2ffcd 38e7e818 4bffffbc 3c62ffd2
> > 7fa4eb78 3863b808 48589e1d 60000000 <0fe00000> 4bfffedc 60000000 60000000
> > BTRFS: error (device dm-0) in __btrfs_run_delayed_items:1188: errno=-5 IO failure
> >
> >
> > The call trace is seen when executing _run_test() for the 8th time.
> > The above trace is actually a false-positive failure as indicated below,
> >  fsync-tester
> >    fsync(fd)
> >    Write delayed inode item to fs tree
> >      (assume transid to be 160)
> >      (assume tree block to start at logical address 29720576)
> >  md5sum $testfile
> >    This causes a delayed inode to be added
> >  Load flakey table
> >    i.e. drop writes that are initiated from now onwards
> >  Unmount filesystem
> >    btrfs_sync_fs is invoked
> >      Write 29720576 metadata block to disk
> >      free_extent_buffer(29720576)
> >        release_extent_buffer(29720576)
> >    Start writing delayed inode
> >      Traverse the fs tree
> >        (assume the parent tree block of 29720576 is still in memory)
> >        When reading 29720576 from disk, parent's blkptr will have generation
> >        set to 160. But the on-disk tree block will have an older
> >        generation (say, 158). Transid verification fails and hence the
> >        transaction gets aborted
> >
> > The test only cares about the FS instance before the unmount
> > operation (i.e. the synced FS). Hence to get the test to pass, ignore the
> > false-positive trace that could be generated.
> 
>   Looks like this patch didn't make it, is there any kernel patch
>   which fixed this bug ? Or any hints on how to reproduce this bug ?
> 

Hi Anand,

This bug is easily recreated when executing the test on Btrfs with
subpage-blocksize patchset applied. I haven't been able to test the recently
rebased subpage-blocksize patchset yet.

Coming back to the issue ... The problem exists because the test code uses
dm-flakey. Josef had suggested that using dm-log-writes instead of dm-flakey
should fix the problem. I will work on this and post a patch soon.

-- 
chandan


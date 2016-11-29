Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38109 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755789AbcK2GhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 01:37:22 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT6XXWH073457
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 01:37:18 -0500
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0a-001b2d01.pphosted.com with ESMTP id 270ygtwaff-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 01:37:17 -0500
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 29 Nov 2016 16:37:15 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id DEAF03578052
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 17:37:11 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uAT6bBvE54591552
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 17:37:11 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uAT6bBsp005378
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 17:37:11 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: Qgroup accounting issue on kdave/for-next branch
Date: Tue, 29 Nov 2016 12:06:18 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <19009351.7ILlWBP2dy@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When executing btrfs/126 test on kdave/for-next branch on a ppc64 guest, I
noticed the following call trace.

[   77.335887] ------------[ cut here ]------------
[   77.336115] WARNING: CPU: 0 PID: 8325 at /root/repos/linux/fs/btrfs/qgroup.c:2443 .btrfs_qgroup_free_refroot+0x188/0x220
[   77.336303] Modules linked in:
[   77.336393] CPU: 0 PID: 8325 Comm: umount Not tainted 4.9.0-rc5-00062-g6b74e43 #22
[   77.336526] task: c00000062b8d4880 task.stack: c00000062b9a4000
[   77.336638] NIP: c0000000005cf018 LR: c0000000005ceff8 CTR: c0000000005390c0
[   77.336771] REGS: c00000062b9a7450 TRAP: 0700   Not tainted  (4.9.0-rc5-00062-g6b74e43)
[   77.336908] MSR: 800000000282b032
[   77.336960] <
[   77.337027] SF
[   77.337053] ,VEC
[   77.337087] ,VSX
[   77.337114] ,EE
[   77.337146] ,FP
[   77.337173] ,ME
[   77.337207] ,IR
[   77.337233] ,DR
[   77.337267] ,RI
[   77.337294] >
[   77.337330]   CR: 88000842  XER: 00000000
[   77.337392] CFAR: c0000000005c9b5c
[   77.337443] SOFTE: 1
[   77.337477]
               GPR00:
[   77.337517] c0000000005cefcc
[   77.337575] c00000062b9a76d0
[   77.337626] c000000001103a00
[   77.337714] c00000063e058d40
[   77.337765]
               GPR04:
[   77.337817] c00000062b9a7740
[   77.337868] 0000000000000008
[   77.337927] 000000000005f000
[   77.337978] 000000063eed0000
[   77.338037]
               GPR08:
[   77.338080] c00000062f9629c8
[   77.338138] 0000000000000001
[   77.338191] fffffffffffff000
[   77.338248] c00000063e058e80
[   77.338300]
               GPR12:
[   77.338384] 0000000000000000
[   77.338435] c00000000fe00000
[   77.338498] 0000000020000000
[   77.338548] 0000000000000000
[   77.338605]
               GPR16:
[   77.338645] 0000000000000008
[   77.338703] 000000004d5906fc
[   77.338754] 000000004d5a6c08
[   77.338811] 000000004d54b3d0
[   77.338866]
               GPR20:
[   77.338921] 000001000bcf8440
[   77.338972] 0000000000000000
[   77.339030] 0000000000000000
[   77.339080] c00000062523b078
[   77.339138]
               GPR24:
[   77.339178] c00000062523b080
[   77.339240] c000000000da2b58
[   77.339290] 0000000000000000
[   77.339347] c00000062e539600
[   77.339398]
               GPR28:
[   77.339485] 0000000000060000
[   77.339536] c00000062523b000
[   77.339594] c00000062e539600
[   77.339644] c00000062e539688

[   77.339740] NIP [c0000000005cf018] .btrfs_qgroup_free_refroot+0x188/0x220
[   77.339852] LR [c0000000005ceff8] .btrfs_qgroup_free_refroot+0x168/0x220
[   77.339959] Call Trace:
[   77.339998] [c00000062b9a76d0] [c0000000005cefcc] .btrfs_qgroup_free_refroot+0x13c/0x220
[   77.340123]  (unreliable)
[   77.340193] [c00000062b9a7790] [c00000000054210c] .commit_fs_roots+0x19c/0x240
[   77.340355] [c00000062b9a78a0] [c0000000005451a0] .btrfs_commit_transaction.part.5+0x480/0xbe0
[   77.340554] [c00000062b9a7970] [c000000000503bd4] .btrfs_sync_fs+0x74/0x1c0
[   77.340725] [c00000062b9a7a10] [c0000000002d6ce0] .sync_filesystem+0xd0/0x100
[   77.340891] [c00000062b9a7a90] [c000000000294f88] .generic_shutdown_super+0x38/0x1a0
[   77.341052] [c00000062b9a7b10] [c000000000295508] .kill_anon_super+0x18/0x30
[   77.342243] [c00000062b9a7b90] [c000000000503db8] .btrfs_kill_super+0x18/0xd0
[   77.342411] [c00000062b9a7c10] [c0000000002958c8] .deactivate_locked_super+0x98/0xe0
[   77.342573] [c00000062b9a7c90] [c0000000002be114] .cleanup_mnt+0x54/0xa0
[   77.342723] [c00000062b9a7d10] [c0000000000d7e74] .task_work_run+0x124/0x180
[   77.342862] [c00000062b9a7db0] [c00000000001c354] .do_notify_resume+0xa4/0xb0
[   77.343030] [c00000062b9a7e30] [c00000000000c344] .ret_from_except_lite+0x70/0x74
[   77.343187] Instruction dump:
[   77.343276] 3b400000 e87d0c78 38810070 4bffab1d 60000000 2c230000 4182ff40 e8dfffc8
[   77.343522] eb630008 7d5c3010 7d294910 7d2900d0 <0b090000> 7fbc3040 41dd0070 f95fffc8
[   77.343771] ---[ end trace 8130fb71377d4ff8 ]---
[   77.343857] BTRFS warning (device loop1): qgroup 5 reserved space underflow, have: 389120, to free: 393216
[   77.735193] BTRFS info (device loop1): disabling disk space caching
[   77.736629] BTRFS info (device loop1): has skinny extents


The above call trace happens because of the following:

 |--------------------------------+-----------------------------------|
 | Task A                         | Task B                            |
 |--------------------------------+-----------------------------------|
 | Write 4k bytes to a file       |                                   |
 | at offset range [0, 4095]      |                                   |
 | - __btrfs_buffered_write       |                                   |
 | -- btrfs_check_data_free_space |                                   |
 | --- Set EXTENT_QGROUP_RESERVED |                                   |
 |     bit for range [0, 64k-1]   |                                   |
 | -- Copy 4k data from userspace |                                   |
 |    to page cache               |                                   |
 |                                | Write 4k bytes to the file        |
 |                                | at offset range [4096, 8191]      |
 |                                | - __btrfs_buffered_write          |
 |                                | -- btrfs_check_data_free_space    |
 |                                | --- Since EXTENT_QGROUP_RESERVED  |
 |                                | is already set we don't           |
 |                                | reserve qgroup space              |
 |                                | -- Assume the call to             |
 |                                | btrfs_delalloc_reserve_metadata() |
 |                                | fails                             |
 |                                | -- btrfs_free_reserved_data_space |
 |                                | --- Clear EXTENT_QGROUP_RESERVED  |
 |                                |     file range [4096, 8191]       |
 |--------------------------------+-----------------------------------|

On x86_64, It has been almost impossible to get the call to
btrfs_delalloc_reserve_metadata() in __btrfs_buffered_write() to fail. Hence I
have the following change in __btrfs_buffered_write() ...

if (pos != 2048)
   ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);                                                                                                                
else                                                                                                                                                                                
   ret = 1;                                                                                                                                                                    
if (ret) {                                                                                                                                                                          
   if (!only_release_metadata)                                                                                                                                                 
        btrfs_free_reserved_data_space(inode, pos,                                                                                                                          
                                       write_bytes);                                                                                                                        
   else
        btrfs_end_write_no_snapshoting(root);
   break;                                                                                                                                                                      
} 


With the above change and by using max_inline=0 mount option, the following
command line will reproduce the call trace on an x86_64 machine,
$ xfs_io -f -c 'pwrite -b 2048 0 8192' -c sync /mnt/file-0.bin

-- 
chandan


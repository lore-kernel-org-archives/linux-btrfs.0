Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754303AbcKYJDh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:03:37 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAP8wh1U057957
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 04:03:31 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26xh7rch8d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 04:03:31 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 25 Nov 2016 09:03:29 -0000
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: btrfs: still lockdep splat for 4.9-rc5+ (btrfs_log_inode)
Date: Fri, 25 Nov 2016 10:03:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <b9063be2-8c01-2c15-ca2d-8460594128cf@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW, I still see the lockdep splat in btrfs in 4.9-rc5+

[  159.698343] =============================================
[  159.698345] [ INFO: possible recursive locking detected ]
[  159.698347] 4.9.0-rc5+ #136 Tainted: G        W      
[  159.698348] ---------------------------------------------
[  159.698349] vim/6913 is trying to acquire lock:
[  159.698350]  (
[  159.698351] &ei->log_mutex
[  159.698352] ){+.+...}
[  159.698353] , at: 
[  159.698445] [<000003ff8202c3f4>] btrfs_log_inode+0x124/0x1048 [btrfs]
[  159.698447] 
               but task is already holding lock:
[  159.698448]  (
[  159.698449] &ei->log_mutex
[  159.698449] ){+.+...}
[  159.698450] , at: 
[  159.698469] [<000003ff8202c3f4>] btrfs_log_inode+0x124/0x1048 [btrfs]
[  159.698470] 
               other info that might help us debug this:
[  159.698471]  Possible unsafe locking scenario:

[  159.698472]        CPU0
[  159.698473]        ----
[  159.698474]   lock(
[  159.698475] &ei->log_mutex
[  159.698476] );
[  159.698476]   lock(
[  159.698477] &ei->log_mutex
[  159.698478] );
[  159.698479] 
                *** DEADLOCK ***

[  159.698480]  May be due to missing lock nesting notation

[  159.698482] 3 locks held by vim/6913:
[  159.698483]  #0: 
[  159.698483]  (
[  159.698484] &sb->s_type->i_mutex_key
[  159.698508] #15
[  159.698509] ){+.+.+.}
[  159.698509] , at: 
[  159.698528] [<000003ff81ff66f8>] btrfs_sync_file+0x1b8/0x560 [btrfs]
[  159.698529]  #1: 
[  159.698530]  (
[  159.698531] sb_internal
[  159.698531] #2
[  159.698532] ){.+.+..}
[  159.698532] , at: 
[  159.698551] [<000003ff81fdad2a>] start_transaction+0x312/0x600 [btrfs]
[  159.698552]  #2: 
[  159.698552]  (
[  159.698553] &ei->log_mutex
[  159.698554] ){+.+...}
[  159.698555] , at: 
[  159.698573] [<000003ff8202c3f4>] btrfs_log_inode+0x124/0x1048 [btrfs]
[  159.698574] 
               stack backtrace:
[  159.698577] CPU: 22 PID: 6913 Comm: vim Tainted: G        W       4.9.0-rc5+ #136
[  159.698578] Hardware name: IBM              2964 NC9              704              (LPAR)
[  159.698580] Stack:
[  159.698581]        000000fae55635f0 000000fae5563680 0000000000000003 0000000000000000
[  159.698584]        000000fae5563720 000000fae5563698 000000fae5563698 0000000000000020
[  159.698587]        0000000000000000 000000fa00000020 000000fa0000000a 000000000000000a
[  159.698589]        000000000000000c 000000fae55636e8 0000000000000000 0000000000000000
[  159.698592]        04000000037e5c40 00000000001127a4 000000fae5563680 000000fae55636d8
[  159.698594] Call Trace:
[  159.698599] ([<000000000011266a>] show_trace+0xea/0xf0)
[  159.698601]  [<0000000000112748>] show_stack+0x68/0xe0 
[  159.698605]  [<00000000004ef502>] dump_stack+0x9a/0xd8 
[  159.698609]  [<00000000001a6078>] validate_chain.isra.22+0xbd8/0xd48 
[  159.698611]  [<00000000001a741c>] __lock_acquire+0x304/0x7f0 
[  159.698613]  [<00000000001a7fe6>] lock_acquire+0xfe/0x2d8 
[  159.698617]  [<00000000008c5216>] mutex_lock_nested+0x86/0x3e8 
[  159.698636]  [<000003ff8202c3f4>] btrfs_log_inode+0x124/0x1048 [btrfs] 
[  159.698655]  [<000003ff8202cfcc>] btrfs_log_inode+0xcfc/0x1048 [btrfs] 
[  159.698674]  [<000003ff8202d5bc>] btrfs_log_inode_parent+0x1fc/0x918 [btrfs] 
[  159.698693]  [<000003ff8202ef22>] btrfs_log_dentry_safe+0x7a/0xa0 [btrfs] 
[  159.698712]  [<000003ff81ff68fc>] btrfs_sync_file+0x3bc/0x560 [btrfs] 
[  159.698715]  [<0000000000349ade>] do_fsync+0x5e/0x90 
[  159.698716]  [<0000000000349e6a>] SyS_fsync+0x32/0x40 
[  159.698718]  [<00000000008cae8e>] system_call+0xd6/0x270 
[  159.698719] INFO: lockdep is turned off.


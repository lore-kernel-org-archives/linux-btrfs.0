Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59967 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751792AbcIHLsJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 07:48:09 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u88BhQLl052502
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Sep 2016 07:48:09 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25axe6y2sx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Sep 2016 07:48:09 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 8 Sep 2016 12:48:06 +0100
Subject: lockdep warning in btrfs in 4.8-rc3
To: Chris Mason <clm@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Thu, 8 Sep 2016 13:48:02 +0200
MIME-Version: 1.0
In-Reply-To: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Message-Id: <6a3eed93-fb4d-817a-6a59-7e7f91c8ea6d@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

with 4.8-rc3 I get the following on an s390 box:


[ 1094.009172] =============================================
[ 1094.009174] [ INFO: possible recursive locking detected ]
[ 1094.009177] 4.8.0-rc3 #126 Tainted: G        W      
[ 1094.009179] ---------------------------------------------
[ 1094.009180] vim/12891 is trying to acquire lock:
[ 1094.009182]  (&ei->log_mutex){+.+...}, at: [<000003ff817e83c6>] btrfs_log_inode+0x126/0x1010 [btrfs]
[ 1094.009256] 
               but task is already holding lock:
[ 1094.009258]  (&ei->log_mutex){+.+...}, at: [<000003ff817e83c6>] btrfs_log_inode+0x126/0x1010 [btrfs]
[ 1094.009276] 
               other info that might help us debug this:
[ 1094.009278]  Possible unsafe locking scenario:

[ 1094.009280]        CPU0
[ 1094.009281]        ----
[ 1094.009282]   lock(&ei->log_mutex);
[ 1094.009284]   lock(&ei->log_mutex);
[ 1094.009286] 
                *** DEADLOCK ***

[ 1094.009288]  May be due to missing lock nesting notation

[ 1094.009290] 3 locks held by vim/12891:
[ 1094.009291]  #0:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<000003ff817afbd6>] btrfs_sync_file+0x1de/0x5e8 [btrfs]
[ 1094.009311]  #1:  (sb_internal#2){.+.+..}, at: [<000000000035e0ba>] __sb_start_write+0x122/0x138
[ 1094.009320]  #2:  (&ei->log_mutex){+.+...}, at: [<000003ff817e83c6>] btrfs_log_inode+0x126/0x1010 [btrfs]
[ 1094.009370] 
               stack backtrace:
[ 1094.009375] CPU: 14 PID: 12891 Comm: vim Tainted: G        W       4.8.0-rc3 #126
[ 1094.009377] Hardware name: IBM              2964 NC9              704              (LPAR)
[ 1094.009380]        000000f061367608 000000f061367698 0000000000000002 0000000000000000 
                      000000f061367738 000000f0613676b0 000000f0613676b0 00000000001133ec 
                      0000000000000000 0000000000000000 000000f70000000a 000000f70000000a 
                      000000f0613676f8 000000f061367698 0000000000000000 0000000000000000 
                      0400000001d821c8 00000000001133ec 000000f061367698 000000f0613676e8 
[ 1094.009396] Call Trace:
[ 1094.009401] ([<0000000000113334>] show_trace+0xec/0xf0)
[ 1094.009403] ([<000000000011339a>] show_stack+0x62/0xe8)
[ 1094.009406] ([<000000000055211c>] dump_stack+0x9c/0xe0)
[ 1094.009411] ([<00000000001d9930>] validate_chain.isra.22+0xc00/0xd70)
[ 1094.009413] ([<00000000001dad9c>] __lock_acquire+0x39c/0x7d8)
[ 1094.009414] ([<00000000001db8d0>] lock_acquire+0x108/0x320)
[ 1094.009420] ([<00000000008845c6>] mutex_lock_nested+0x86/0x3f8)
[ 1094.009440] ([<000003ff817e83c6>] btrfs_log_inode+0x126/0x1010 [btrfs])
[ 1094.009457] ([<000003ff817e8fb2>] btrfs_log_inode+0xd12/0x1010 [btrfs])
[ 1094.009474] ([<000003ff817e95b4>] btrfs_log_inode_parent+0x244/0x980 [btrfs])
[ 1094.009490] ([<000003ff817eafea>] btrfs_log_dentry_safe+0x7a/0xa0 [btrfs])
[ 1094.009506] ([<000003ff817afe1a>] btrfs_sync_file+0x422/0x5e8 [btrfs])
[ 1094.009512] ([<000000000039e64e>] do_fsync+0x5e/0x90)
[ 1094.009514] ([<000000000039e9e2>] SyS_fsync+0x32/0x40)
[ 1094.009517] ([<000000000088a336>] system_call+0xd6/0x270)
[ 1094.009518] INFO: lockdep is turned off.


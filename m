Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53731 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbcGKF6K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 01:58:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6B5rg4J057298
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 01:58:09 -0400
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
	by mx0a-001b2d01.pphosted.com with ESMTP id 243es43cp1-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 01:58:09 -0400
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 11 Jul 2016 15:58:06 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id ED2A23578057
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 15:58:03 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6B5w3Ad20578472
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 15:58:03 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6B5w3tM007138
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 15:58:03 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Gabriel C <nix.or.die@gmail.com>, linux-btrfs@vger.kernel.org,
        quwenruo@cn.fujitsu.com
Subject: Re: A lot warnings in dmesg while running thunderbird
Date: Mon, 11 Jul 2016 11:28:01 +0530
In-Reply-To: <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com> <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com> <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <35812568.Zn4Yz0rfXf@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, July 08, 2016 12:02:35 PM Chris Mason wrote:
> 
> On 07/08/2016 11:02 AM, Gabriel C wrote:
> > On 08.07.2016 14:41, Chris Mason wrote:
> >
> >>
> >>
> >> On 07/08/2016 05:57 AM, Gabriel C wrote:
> >>> 2016-07-07 21:21 GMT+02:00 Chris Mason <clm@fb.com>:
> >>>>
> >>>>
> >>>> On 07/07/2016 06:24 AM, Gabriel C wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
> >>>>> other versions )
> >>>>> I trigger the following :
> >>>>
> >>>>
> >>>> I definitely thought we had this fixed in v4.7-rc.  Can you easily
> >>>> fsck this filesystem?  Something strange is going on.
> >>>
> >>> Yes , btrfs check and btrfs check  --check-data-csum are fine , no
> >>> errors found.
> >>>
> >>> If you want me to test any patches let me know.
> >>>
> >>
> >> Can you please try a v4.5 stable kernel?  I'm curious if this really
> >> is the same regression that I tried to fix in v4.7
> >>
> >
> > I'm on linux 4.5.7 now and everything is fine. I'm writing this email
> > from thunderbird.. which was not
> > possible in 4.6.3 or 4.7.-rc.
> >
> > Let me know you want me to test other kernels or whatever else may help
> > fixing this problem.
> >
> 
> Can you please run the attached test program:
> 
> gcc -o short-write short-write.c -lpthread
> ./short-write some-new-file-on-btrfs
> 
> I want to see if you're triggering the same problem we've tried to fix, 
> or something else.
>

Hi Chris,

I am able to reproduce the issue with the 'short-write' program. But before
the call trace associated with btrfs_destroy_inode(), I see the following call
trace ...

------------[ cut here ]------------
WARNING: CPU: 2 PID: 2311 at /home/chandan/repos/linux/fs/btrfs/extent-tree.c:4303 btrfs_free_reserved_data_space_noquota+0xe8/0x100
Modules linked in:
CPU: 2 PID: 2311 Comm: short-write Not tainted 4.7.0-rc6-ga99cde4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 0000000000000000 ffff8818ceb8ba30 ffffffff8145c2a1 0000000000000000
 0000000000000000 ffff8818ceb8ba70 ffffffff81056a7c 000010cf81346936
 ffff8818bdba4800 0000000000001000 ffff8818bdd5ee00 ffff8818bf1bbd84
Call Trace:
 [<ffffffff8145c2a1>] dump_stack+0x4d/0x6c
 [<ffffffff81056a7c>] __warn+0xcc/0xf0
 [<ffffffff81056b58>] warn_slowpath_null+0x18/0x20
 [<ffffffff8134a3c8>] btrfs_free_reserved_data_space_noquota+0xe8/0x100
 [<ffffffff81368b39>] btrfs_clear_bit_hook+0x2f9/0x370
 [<ffffffff813830e5>] clear_state_bit+0x55/0x1b0
 [<ffffffff81383460>] __clear_extent_bit+0x220/0x3b0
 [<ffffffff813cb5f2>] ? __btrfs_qgroup_release_data+0x82/0x110
 [<ffffffff81383bc5>] clear_extent_bit+0x25/0x30
 [<ffffffff8136eb53>] btrfs_invalidatepage+0x273/0x2c0
 [<ffffffff81131223>] truncate_inode_page+0x83/0x90
 [<ffffffff811313da>] truncate_inode_pages_range+0x17a/0x6c0
 [<ffffffff811319c2>] truncate_pagecache+0x42/0x60
 [<ffffffff81131a0d>] truncate_setsize+0x2d/0x40
 [<ffffffff81370d7f>] btrfs_setattr+0x1ef/0x320
 [<ffffffff8119680c>] notify_change+0x1dc/0x380
 [<ffffffff811788b1>] do_truncate+0x61/0xa0
 [<ffffffff81178c09>] do_sys_ftruncate.constprop.17+0xf9/0x160
 [<ffffffff81178c99>] SyS_ftruncate+0x9/0x10
 [<ffffffff81a27d1b>] entry_SYSCALL_64_fastpath+0x13/0x8f
---[ end trace 5682b0d8e8a631ed ]---


I will continue to debug and find out the root cause.

-- 
chandan


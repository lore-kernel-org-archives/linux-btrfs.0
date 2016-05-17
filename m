Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55884 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbcEQQYE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 12:24:04 -0400
Date: Tue, 17 May 2016 12:23:44 -0400
From: Chris Mason <clm@fb.com>
To: Adam Borowski <kilobyte@angband.pl>
CC: <linux-btrfs@vger.kernel.org>, <dsj@fb.com>,
        Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] Btrfs: fix handling of faults from btrfs_copy_from_user
Message-ID: <20160517162344.3znjdtgvfke2ouke@floor.thefacebook.com>
References: <20160516210655.sfsjtj5oleeksaxq@floor.thefacebook.com>
 <20160517151451.GA3882@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160517151451.GA3882@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 05:14:51PM +0200, Adam Borowski wrote:
> On Mon, May 16, 2016 at 05:06:55PM -0400, Chris Mason wrote:
> > Hi everyone,
> > 
> > I've tried to cc most of the recent reports of this warning.  It was
> > pretty hard to track down, but I've got a test program for it now.  My
> > goal is to change xfs_io to add the madvise loop under
> > --do-horrible-things, instead of adding yet another special doio.c
> > function to xfstests.
> [...]
> > And now for the patch:
> [...]
> 
> 
> I've applied the patch and hammered it with real workloads (mostly sbuild).
> They used to trigger the warning nearly immediately, with the patch all
> seemed ok -- so there is an improvement.

Thanks for trying these out.

> 
> I then tried your test case, and alas:
> 
> Here's another run on an untainted kernel built with frame pointers etc:
> 
> ./dammitdave foo
> [  236.500257] ------------[ cut here ]------------
> [  236.500280] WARNING: CPU: 3 PID: 2940 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xdd/0x160
> [  236.500285] Modules linked in:
> [  236.500295] CPU: 3 PID: 2940 Comm: dammit Not tainted 4.6.0debug+ #1
> [  236.500301] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
> [  236.500306]  0000000000000000 0000000042ec2fb0 ffff88022d5ffbd8 ffffffff816b1920
> [  236.500315]  ffffffff81f86e3f 0000000042ec2fb0 0000000000000000 0000000000000000
> [  236.500322]  ffff88022d5ffc20 ffffffff81118c2c ffff88022dfd4000 0000108900000000
> [  236.500330] Call Trace:
> [  236.500342]  [<ffffffff816b1920>] dump_stack+0x60/0xa0
> [  236.500352]  [<ffffffff81118c2c>] __warn+0x10c/0x150
> [  236.500360]  [<ffffffff81118d78>] warn_slowpath_null+0x18/0x20
> [  236.500368]  [<ffffffff814e389d>] btrfs_free_reserved_data_space_noquota+0xdd/0x160
> [  236.500376]  [<ffffffff814e3942>] btrfs_free_reserved_data_space+0x22/0x40
> [  236.500385]  [<ffffffff8152eb78>] __btrfs_buffered_write+0x748/0xa20
> [  236.500394]  [<ffffffff81624bdc>] ? security_inode_need_killpriv+0x3c/0x60
> [  236.500401]  [<ffffffff815345ef>] btrfs_file_write_iter+0x4ff/0xb90
> [  236.500410]  [<ffffffff81341847>] __vfs_write+0x117/0x1d0
> [  236.500417]  [<ffffffff8134317d>] vfs_write+0xdd/0x290
> [  236.500425]  [<ffffffff813748bd>] ? __fget_light+0x4d/0x120
> [  236.500432]  [<ffffffff813453ee>] SyS_pwrite64+0x9e/0xc0
> [  236.500441]  [<ffffffff81db989f>] entry_SYSCALL_64_fastpath+0x17/0x93
> [  236.500446] ---[ end trace 7df747a6a0962ae6 ]---
> rm foo
> [  323.851851] BTRFS info (device sda1): btrfs_destroy_inode: leftover csum_bytes

Hmmm, some of your traces mentioned compression, do you have compression
enabled?  I'll try to reproduce here, but could you try the same test on
v4.5?

Also, if you can gdb your vmlinux (or btrfs.ko) and find this line:

gdb> list *__btrfs_buffered_write+0x748

It'll help.

Thanks!

-chris

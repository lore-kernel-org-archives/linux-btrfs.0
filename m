Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9250 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751991AbbCYDgu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 23:36:50 -0400
Message-ID: <55122D40.8020201@cn.fujitsu.com>
Date: Wed, 25 Mar 2015 11:36:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] btrfs-progs: Record and report every file extent
 hole.
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com> <1420182753-2724-3-git-send-email-quwenruo@cn.fujitsu.com> <551225F6.4030208@redhat.com>
In-Reply-To: <551225F6.4030208@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I'll investigate it soon.

Thanks,
Qu

> On 1/2/15 1:12 AM, Qu Wenruo wrote:
>> Record every file extent discontinuous hole in inode_record using a
>> rb_tree member.
>>
>> Before the patch, btrfsck will only record the first file extent hole by
>> using first_extent_gap, that's good for detecting error, but not
>> suitable for fixing it.
>>
>> This patch provides the ability to record every file extent hole and
>> report it.
>
> This is causing use after free and segfaults in my testing, running
> xfstests btrfs/078 with multiple devices defined:
>
> SCRATCH_DEV_POOL="/dev/sdc5 /dev/sdc6 /dev/sdc7 /dev/sdc8 /dev/sdc9 /dev/sdc10 /dev/sdc11 /dev/sdc12"
>
> -Eric
>
> # valgrind ./btrfsck /dev/sdc5
> ==31620== Memcheck, a memory error detector
> ==31620== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
> ==31620== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
> ==31620== Command: ./btrfsck /dev/sdc5
> ==31620==
> Checking filesystem on /dev/sdc5
> UUID: ab91fc96-549b-4048-a68b-73c5190e6265
> checking extents
> checking free space cache
> checking fs roots
> ==31620== Invalid read of size 8
> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
> ==31620==    by 0x41E609: first_extent_gap (cmds-check.c:182)
> ==31620==    by 0x427D43: merge_inode_recs (cmds-check.c:950)
> ==31620==    by 0x42827B: splice_shared_node (cmds-check.c:1032)
> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==
> ==31620== Invalid read of size 8
> ==31620==    at 0x41E60A: first_extent_gap (cmds-check.c:183)
> ==31620==    by 0x427D43: merge_inode_recs (cmds-check.c:950)
> ==31620==    by 0x42827B: splice_shared_node (cmds-check.c:1032)
> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==  Address 0x4e5dc68 is 24 bytes inside a block of size 40 free'd
> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==
> ==31620== Invalid read of size 8
> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
> ==31620==    by 0x41E609: first_extent_gap (cmds-check.c:182)
> ==31620==    by 0x427421: maybe_free_inode_rec (cmds-check.c:768)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==
> ==31620== Invalid read of size 8
> ==31620==    at 0x41E60A: first_extent_gap (cmds-check.c:183)
> ==31620==    by 0x427421: maybe_free_inode_rec (cmds-check.c:768)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==  Address 0x4e5dc68 is 24 bytes inside a block of size 40 free'd
> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==
> ==31620== Invalid read of size 8
> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
> ==31620==    by 0x42186C: free_file_extent_holes (cmds-check.c:355)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
> ==31620==    by 0x40C089: main (btrfs.c:245)
>
> ... etc ...
>

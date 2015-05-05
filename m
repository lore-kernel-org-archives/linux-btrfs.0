Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3803 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbbEEAzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 20:55:35 -0400
Message-ID: <55481503.9090305@cn.fujitsu.com>
Date: Tue, 5 May 2015 08:55:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] btrfs-progs: Record and report every file extent
 hole.
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>	<1420182753-2724-3-git-send-email-quwenruo@cn.fujitsu.com>	<551225F6.4030208@redhat.com>	<55122D40.8020201@cn.fujitsu.com> <CAL3q7H69-Y8UbzmY1PXwj=eh39k+Ur8dwhMMVvc0cqb0rZzGrg@mail.gmail.com>
In-Reply-To: <CAL3q7H69-Y8UbzmY1PXwj=eh39k+Ur8dwhMMVvc0cqb0rZzGrg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I was busy making another patchset for offline fsid/chunk tree 
uuid change, and didn't have time investigating it.

But now the patchset is finished and I'll begin investigate it.

Thanks for your valgrind output.
Qu

-------- Original Message  --------
Subject: Re: [PATCH v2 3/5] btrfs-progs: Record and report every file 
extent hole.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月03日 00:36

> On Wed, Mar 25, 2015 at 3:36 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Thanks, I'll investigate it soon.
>>
>> Thanks,
>> Qu
>
> Qu, did you end up finding anything?
>
> Just upgraded to btrfs-progs 4.0 and getting pretty much the same as
> Eric all the time I run btrfs/078.
> Valgrind should give you some nice clues.
>
> E.g.
>
> (...)
> checking free space cache
> checking fs roots
> ==11808== Invalid read of size 8
> ==11808==    at 0x4611C2: rb_first (rbtree.c:420)
> ==11808==    by 0x41B694: first_extent_gap (cmds-check.c:184)
> ==11808==    by 0x42020E: merge_inode_recs (cmds-check.c:954)
> ==11808==    by 0x42020E: splice_shared_node (cmds-check.c:1036)
> ==11808==    by 0x4205B8: enter_shared_node (cmds-check.c:1142)
> ==11808==    by 0x420F6E: walk_down_tree (cmds-check.c:1758)
> ==11808==    by 0x429555: check_fs_root (cmds-check.c:3382)
> ==11808==    by 0x429555: check_fs_roots (cmds-check.c:3518)
> ==11808==    by 0x429555: cmd_check (cmds-check.c:9465)
> ==11808==    by 0x409BEC: main (btrfs.c:245)
> ==11808==  Address 0x6057d10 is 16 bytes inside a block of size 40 free'd
> ==11808==    at 0x4C29E90: free (vg_replace_malloc.c:473)
> ==11808==    by 0x41C118: free_file_extent_holes (cmds-check.c:363)
> ==11808==    by 0x41C118: free_inode_rec (cmds-check.c:722)
> ==11808==    by 0x41F9CA: maybe_free_inode_rec (cmds-check.c:790)
> ==11808==    by 0x42036C: splice_shared_node (cmds-check.c:1042)
> ==11808==    by 0x4205B8: enter_shared_node (cmds-check.c:1142)
> ==11808==    by 0x420F6E: walk_down_tree (cmds-check.c:1758)
> ==11808==    by 0x429555: check_fs_root (cmds-check.c:3382)
> ==11808==    by 0x429555: check_fs_roots (cmds-check.c:3518)
> ==11808==    by 0x429555: cmd_check (cmds-check.c:9465)
> ==11808==    by 0x409BEC: main (btrfs.c:245)
> ==11808==
> ==11808==
> ==11808== Process terminating with default action of signal 11 (SIGSEGV)
> ==11808==  General Protection Fault
> ==11808==    at 0x4611C2: rb_first (rbtree.c:420)
> ==11808==    by 0x41B694: first_extent_gap (cmds-check.c:184)
> ==11808==    by 0x42020E: merge_inode_recs (cmds-check.c:954)
> ==11808==    by 0x42020E: splice_shared_node (cmds-check.c:1036)
> ==11808==    by 0x4205B8: enter_shared_node (cmds-check.c:1142)
> ==11808==    by 0x420F6E: walk_down_tree (cmds-check.c:1758)
> ==11808==    by 0x429555: check_fs_root (cmds-check.c:3382)
> ==11808==    by 0x429555: check_fs_roots (cmds-check.c:3518)
> ==11808==    by 0x429555: cmd_check (cmds-check.c:9465)
> ==11808==    by 0x409BEC: main (btrfs.c:245)
> (....)
>
> Thanks.
>
>
>>
>>
>>> On 1/2/15 1:12 AM, Qu Wenruo wrote:
>>>>
>>>> Record every file extent discontinuous hole in inode_record using a
>>>> rb_tree member.
>>>>
>>>> Before the patch, btrfsck will only record the first file extent hole by
>>>> using first_extent_gap, that's good for detecting error, but not
>>>> suitable for fixing it.
>>>>
>>>> This patch provides the ability to record every file extent hole and
>>>> report it.
>>>
>>>
>>> This is causing use after free and segfaults in my testing, running
>>> xfstests btrfs/078 with multiple devices defined:
>>>
>>> SCRATCH_DEV_POOL="/dev/sdc5 /dev/sdc6 /dev/sdc7 /dev/sdc8 /dev/sdc9
>>> /dev/sdc10 /dev/sdc11 /dev/sdc12"
>>>
>>> -Eric
>>>
>>> # valgrind ./btrfsck /dev/sdc5
>>> ==31620== Memcheck, a memory error detector
>>> ==31620== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
>>> ==31620== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright
>>> info
>>> ==31620== Command: ./btrfsck /dev/sdc5
>>> ==31620==
>>> Checking filesystem on /dev/sdc5
>>> UUID: ab91fc96-549b-4048-a68b-73c5190e6265
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> ==31620== Invalid read of size 8
>>> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
>>> ==31620==    by 0x41E609: first_extent_gap (cmds-check.c:182)
>>> ==31620==    by 0x427D43: merge_inode_recs (cmds-check.c:950)
>>> ==31620==    by 0x42827B: splice_shared_node (cmds-check.c:1032)
>>> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
>>> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
>>> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
>>> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
>>> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
>>> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
>>> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==
>>> ==31620== Invalid read of size 8
>>> ==31620==    at 0x41E60A: first_extent_gap (cmds-check.c:183)
>>> ==31620==    by 0x427D43: merge_inode_recs (cmds-check.c:950)
>>> ==31620==    by 0x42827B: splice_shared_node (cmds-check.c:1032)
>>> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
>>> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
>>> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==  Address 0x4e5dc68 is 24 bytes inside a block of size 40 free'd
>>> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
>>> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
>>> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
>>> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==
>>> ==31620== Invalid read of size 8
>>> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
>>> ==31620==    by 0x41E609: first_extent_gap (cmds-check.c:182)
>>> ==31620==    by 0x427421: maybe_free_inode_rec (cmds-check.c:768)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
>>> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
>>> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
>>> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
>>> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
>>> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
>>> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==
>>> ==31620== Invalid read of size 8
>>> ==31620==    at 0x41E60A: first_extent_gap (cmds-check.c:183)
>>> ==31620==    by 0x427421: maybe_free_inode_rec (cmds-check.c:768)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
>>> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
>>> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==  Address 0x4e5dc68 is 24 bytes inside a block of size 40 free'd
>>> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
>>> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
>>> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
>>> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==
>>> ==31620== Invalid read of size 8
>>> ==31620==    at 0x4C257C3: rb_first (rbtree.c:420)
>>> ==31620==    by 0x42186C: free_file_extent_holes (cmds-check.c:355)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x428827: enter_shared_node (cmds-check.c:1138)
>>> ==31620==    by 0x428BCF: walk_down_tree (cmds-check.c:1745)
>>> ==31620==    by 0x42CA64: check_fs_root (cmds-check.c:3360)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>> ==31620==  Address 0x4e5dc60 is 16 bytes inside a block of size 40 free'd
>>> ==31620==    at 0x4A063F0: free (vg_replace_malloc.c:446)
>>> ==31620==    by 0x421887: free_file_extent_holes (cmds-check.c:359)
>>> ==31620==    by 0x4218FB: free_inode_rec (cmds-check.c:718)
>>> ==31620==    by 0x42753E: maybe_free_inode_rec (cmds-check.c:786)
>>> ==31620==    by 0x4282A5: splice_shared_node (cmds-check.c:1038)
>>> ==31620==    by 0x42849E: leave_shared_node (cmds-check.c:1170)
>>> ==31620==    by 0x42869F: walk_up_tree (cmds-check.c:1817)
>>> ==31620==    by 0x42CA82: check_fs_root (cmds-check.c:3366)
>>> ==31620==    by 0x42CE2D: check_fs_roots (cmds-check.c:3496)
>>> ==31620==    by 0x42E342: cmd_check (cmds-check.c:9161)
>>> ==31620==    by 0x40C089: main (btrfs.c:245)
>>>
>>> ... etc ...
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

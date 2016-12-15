Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:34406 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752523AbcLOIll (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 03:41:41 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CE354AC008A
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 17:41:36 +0900 (JST)
Subject: Re: Btrfs progs pre-release 4.9-rc1
To: David Sterba <dsterba@suse.com>
References: <20161214144224.17846-1-dsterba@suse.com>
 <6c4324b7-90b7-37f0-42ae-101a22f65dbb@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <e69f50ac-abe1-4237-d20c-62085d03f82e@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 17:41:22 +0900
MIME-Version: 1.0
In-Reply-To: <6c4324b7-90b7-37f0-42ae-101a22f65dbb@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/12/15 15:45, Tsutomu Itoh wrote:
> On 2016/12/14 23:42, David Sterba wrote:
>> Hi,
>>
>> a pre-release has been tagged. Contains almost the entire devel branch from
>> today. There are small fixes, the lowmem mode of check gets more updates but
>> still does not work in the --repair mode and is considered experimental.
>>
>> ETA for 4.9 is in +6 days (2016-12-20).
>>
>> Minor fixes, docs improvements or more testcases will be still considered for
>> 4.9 release.
> 
> xfstests btrfs/{108,109,117} that was working in 4.8.5 will not work properly.
> 
> + ./check btrfs/108
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 luna 4.9.0
> MKFS_OPTIONS  -- /dev/sdb3
> MOUNT_OPTIONS -- /dev/sdb3 /test6
> 
> btrfs/108 1s ... [failed, exit status 1] - output mismatch (see /xfstests/results//btrfs/108.out.bad)
>     --- tests/btrfs/108.out     2015-10-19 09:55:52.000000000 +0900
>     +++ /xfstests/results//btrfs/108.out.bad    2016-12-15 15:41:43.771411349 +0900
>     @@ -8,6 +8,6 @@
>      File digests in the original filesystem:
>      fbf36a062ffcbd644b5739c4d683ccc7  SCRATCH_MNT/snap/foo
>      5d2c92827a70aad932cfe7363105c55e  SCRATCH_MNT/snap/bar
>     -File digests in the new filesystem:
>     -fbf36a062ffcbd644b5739c4d683ccc7  SCRATCH_MNT/snap/foo
>     -5d2c92827a70aad932cfe7363105c55e  SCRATCH_MNT/snap/bar
>     +./common/rc: line 2784: 22352 Segmentation fault      (core dumped) "$@" >> $seqres.full 2>&1
>     ...
>     (Run 'diff -u tests/btrfs/108.out /xfstests/results//btrfs/108.out.bad'  to see the entire diff)
> Ran: btrfs/108
> Failures: btrfs/108
> Failed 1 of 1 tests

Another problem was found. xfstests btrfs/012 will not succeed.

btrfs/012 58s ... [failed, exit status 1] - output mismatch (see /xfstests/results//btrfs/012.out.bad)
    --- tests/btrfs/012.out     2015-08-04 16:09:38.000000000 +0900
    +++ /xfstests/results//btrfs/012.out.bad    2016-12-15 17:38:10.305009249 +0900
    @@ -1 +1,3 @@
     == QA output created by 012
    +btrfs-convert rollback failed
    +(see /xfstests/results//btrfs/012.full for details)
    ...
    (Run 'diff -u tests/btrfs/012.out /xfstests/results//btrfs/012.out.bad'  to see the entire diff)

Thanks,
Tsutomu

> 
> Thanks,
> Tsutomu
> 
>>
>> Changes:
>>   * check: many lowmem mode updates
>>   * send: use splice syscall to copy buffer from kernel
>>   * receive: new option to dump the stream in textual form
>>   * convert:
>>     * move sources to own directory
>>     * prevent accounting of blocks beyond end of the device
>>     * make it work with 64k sectorsize
>>   * mkfs: move sources to own directory
>>   * defrag: warns if directory used without -r
>>   * dev stats:
>>     * new option to check stats for non-zero values
>>     * add long option for -z
>>   * library: version bump to 0.1.2, added subvol_uuid_search2
>>   * other:
>>     * cleanups
>>     * docs updates
>>
>> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
>> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>>
>> Shortlog:
>>
>> Adam Borowski (1):
>>       btrfs-progs: man mkfs: warn about RAID5/6 being experimental
>>
>> Anand Jain (1):
>>       btrfs-progs: recursive defrag cleanup duplicate code
>>
>> Austin S. Hemmelgarn (1):
>>       btrfs-progs: dev stats: add dev stats returncode option
>>
>> Chandan Rajendra (3):
>>       btrfs-progs: Use helper function to access btrfs_super_block->sys_chunk_array_size
>>       btrfs-progs: convert: Prevent accounting blocks beyond end of device
>>       btrfs-progs: convert: Fix migrate_super_block() to work with 64k sectorsize
>>
>> David Sterba (35):
>>       btrfs-progs: remove extra newline from messages
>>       btrfs-progs: use symbolic name for first inode number when searching
>>       btrfs-progs: send: use splice syscall instead of read/write to transfer buffer
>>       btrfs-progs: send: rename thread callback to read data from kernel
>>       btrfs-progs: make incompat bit wrappers more compact
>>       btrfs-progs: receive: rename receive context variable
>>       btrfs-progs: check: use on-stack path buffer in check_fs_first_inode
>>       btrfs-progs: check: use on-stack path buffer in check_fs_root_v2
>>       btrfs-progs: check: use on-stack path buffer in check_fs_roots_v2
>>       btrfs-progs: send dump: introduce helper for printing escaped path
>>       btrfs-progs: send dump: print escaped path
>>       btrfs-progs: send dump: use reentrant variant of localtime
>>       btrfs-progs: tests: add more gobal option to test 001-btrfs
>>       btrfs-progs: docs: update receive help and manual page
>>       btrfs-progs: build: extend pattern rules for standalone directories
>>       btrfs-progs: move btrfs-convert to own directory
>>       btrfs-progs: move mkfs.btrfs sources to own directory
>>       btrfs-progs: tests: check for partscan support in misc/006-partitioned-loopdev
>>       btrfs-progs: run mkfs tests in CI
>>       btrfs-progs: mkfs: annotation of a case
>>       btrfs-progs: docs: clarify trim after mkfs -K
>>       btrfs-progs: docs: make documentation updates workflow more clear
>>       btrfs-progs: dev stats: adjust some error messages
>>       btrfs-progs: dev stats: use char type path
>>       btrfs-progs: dev stats: use table based printing of items
>>       btrfs-progs: dev stats: add long option for -z
>>       btrfs-progs: docs: update dev stats help and manual page
>>       btrfs-progs: help: fix printing of aliased commands
>>       btrfs-progs: fixup API after change in subvol_uuid_search
>>       btrfs-progs: library: bump to 0.1.2
>>       btrfs-progs: handle failed strdup in subvol_uuid_search2
>>       btrfs-progs: dev stats: update option name for checking non-zero status
>>       btrfs-progs: defrag: cleanup temporary errno value
>>       btrfs-progs: defrag: warn when deframgenting directories without -r
>>       btrfs-progs: update CHANGES for v4.9
>>
>> Goldwyn Rodrigues (5):
>>       btrfs-progs: Correct value printed by assertions/BUG_ON/WARN_ON
>>       btrfs-progs: Remove duplicate printfs in warning_trace()/assert_trace()
>>       btrfs-progs: check: fix extents after finding all errors
>>       btrfs-progs: Initialize ret to suppress compiler warning
>>       btrfs-progs: find_free_dev_extent() closer to kernel code
>>
>> Lu Fengqi (11):
>>       btrfs-progs: check: introduce function to find dir_item
>>       btrfs-progs: check: introduce function to check inode_ref
>>       btrfs-progs: check: introduce function to check inode_extref
>>       btrfs-progs: check: introduce function to find inode_ref
>>       btrfs-progs: check: introduce function to check dir_item
>>       btrfs-progs: check: introduce function to check file extent
>>       btrfs-progs: check: introduce function to check inode item
>>       btrfs-progs: check: introduce function to check fs root
>>       btrfs-progs: check: introduce function to check root ref
>>       btrfs-progs: check: introduce low_memory mode fs_tree check
>>       btrfs-progs: check: fix the return value bug of cmd_check()
>>
>> Noah Massey (1):
>>       btrfs-progs: docs: fix typo in mkfs manual page
>>
>> Prasanth K S R (3):
>>       btrfs-progs: subvol_uuid_search: return error on memory allocation failure
>>       btrfs-progs: subvol_uuid_search: return error encoded pointer
>>       btrfs-progs: subvol_uuid_search: return error code on memory allocation failure
>>
>> Qu Wenruo (11):
>>       btrfs-progs: raid56: Introduce new function to calculate raid5 parity or data stripe
>>       btrfs-progs: volumes: Use new raid5_gen_result to calculate raid5 parity
>>       btrfs-progs: check: Enhance leaf traversal function to handle missing inode item
>>       btrfs-progs: fsck: Fix patch allocation check and leak in check_fs_first_inode
>>       btrfs-progs: check: fix NULL pointer dereference for possible memory allocation failure
>>       btrfs-progs: introduce new send-dump object
>>       btrfs-progs: receive: introduce option to dump send stream
>>       btrfs-progs: check: Fix assert when using lowmem on fs with tree reloc tree
>>       btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023
>>       btrfs-progs: check: Fix lowmem false alert on tree reloc tree
>>       btrfs-progs: check: Fix false alert on generation mismatch for tree reloc tree
>>
>> Wang Xiaoguang (1):
>>       btrfs-progs: check: skip shared node or leaf check for low_memory mode
>>
> 


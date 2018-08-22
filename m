Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbeHVTqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 15:46:02 -0400
From: David Howells <dhowells@redhat.com>
To: clm@fb.com
Cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org
Subject: Pre-preview of conversion of btrfs to the mount API
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 22 Aug 2018 17:20:27 +0100
Message-ID: <19986.1534954827@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Here's a pre-preview of my conversion of btrfs to the mount API:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=btrfs-mount-api

The last patch is the one that does the heavy lifting.

The code compiles and you can load the module.  in theory it should work, but
I haven't actually tried mounting anything with it yet.  What you *can* do is
use the samples/statx/test-fs-query program to list all the parameters that
the converted btrfs takes via the fsinfo() system call (see attached).

However, I have to disappear off for the moment.

David
---

[root@andromeda ~]# ./test-fs-query btrfs          
Filesystem btrfs has 39 parameters
- PARAM[  0] type=8(string)
- PARAM[  1] type=1(no-val) -neg-no
- PARAM[  2] type=8(string) -dep
- PARAM[  3] type=1(no-val) -neg-no
- PARAM[  4] type=1(no-val)
- PARAM[  5] type=1(no-val)
- PARAM[  6] type=3(u32)
- PARAM[  7] type=1(no-val)
- PARAM[  8] type=3(u32)
- PARAM[  9] type=7(enum) -opt
- PARAM[ 10] type=7(enum) -opt
- PARAM[ 11] type=1(no-val) -neg-no
- PARAM[ 12] type=1(no-val) -neg-no
- PARAM[ 13] type=1(no-val) -neg-no
- PARAM[ 14] type=1(no-val)
- PARAM[ 15] type=8(string)
- PARAM[ 16] type=1(no-val) -neg-no
- PARAM[ 17] type=1(no-val) -neg-no
- PARAM[ 18] type=7(enum)
- PARAM[ 19] type=1(no-val) -neg-no
- PARAM[ 20] type=7(enum)
- PARAM[ 21] type=1(no-val) -neg-no
- PARAM[ 22] type=8(string)
- PARAM[ 23] type=1(no-val)
- PARAM[ 24] type=3(u32)
- PARAM[ 25] type=1(no-val) -neg-no
- PARAM[ 26] type=1(no-val)
- PARAM[ 27] type=1(no-val)
- PARAM[ 28] type=1(no-val)
- PARAM[ 29] type=7(enum) -opt -neg-no
- PARAM[ 30] type=1(no-val) -neg-no
- PARAM[ 31] type=1(no-val) -neg-no
- PARAM[ 32] type=8(string) -opt
- PARAM[ 33] type=13(u64)
- PARAM[ 34] type=6(s32) -dep
- PARAM[ 35] type=3(u32)
- PARAM[ 36] type=1(no-val) -neg-no
- PARAM[ 37] type=1(no-val)
- PARAM[ 38] type=1(no-val)
Filesystem has 39 parameter names
- NAME[  0] acl -> 1
- NAME[  1] alloc_start -> 2
- NAME[  2] autodefrag -> 13
- NAME[  3] barrier -> 3
- NAME[  4] check_int -> 4
- NAME[  5] check_int_data -> 5
- NAME[  6] check_int_print_mask -> 6
- NAME[  7] clear_cache -> 7
- NAME[  8] commit -> 8
- NAME[  9] compress -> 10
- NAME[ 10] compress-force -> 9
- NAME[ 11] datacow -> 11
- NAME[ 12] datasum -> 12
- NAME[ 13] degraded -> 14
- NAME[ 14] device -> 15
- NAME[ 15] discard -> 16
- NAME[ 16] enospc_debug -> 17
- NAME[ 17] fatal_errors -> 18
- NAME[ 18] flushoncommit -> 19
- NAME[ 19] fragment -> 20
- NAME[ 20] inode_cache -> 21
- NAME[ 21] max_inline -> 22
- NAME[ 22] metadata_ratio -> 24
- NAME[ 23] nologreplay -> 23
- NAME[ 24] recovery -> 25
- NAME[ 25] ref_verify -> 26
- NAME[ 26] rescan_uuid_tree -> 27
- NAME[ 27] skip_balance -> 28
- NAME[ 28] source -> 0
- NAME[ 29] space_cache -> 29
- NAME[ 30] ssd -> 30
- NAME[ 31] ssd_spread -> 31
- NAME[ 32] subvol -> 32
- NAME[ 33] subvolid -> 33
- NAME[ 34] subvolrootid -> 34
- NAME[ 35] thread_pool -> 35
- NAME[ 36] treelog -> 36
- NAME[ 37] usebackuproot -> 37
- NAME[ 38] user_subvol_rm_allowed -> 38
Filesystem has 33 enumeration values
- ENUM[  0]  20.all
- ENUM[  1]  20.data
- ENUM[  2]  20.metadata
- ENUM[  3]  10.zlib
- ENUM[  4]  10.zlib:1
- ENUM[  5]  10.zlib:2
- ENUM[  6]  10.zlib:3
- ENUM[  7]  10.zlib:4
- ENUM[  8]  10.zlib:5
- ENUM[  9]  10.zlib:6
- ENUM[ 10]  10.zlib:7
- ENUM[ 11]  10.zlib:8
- ENUM[ 12]  10.zlib:9
- ENUM[ 13]  10.lzo
- ENUM[ 14]  10.zstd
- ENUM[ 15]  10.no
- ENUM[ 16]   9.zlib
- ENUM[ 17]   9.zlib:1
- ENUM[ 18]   9.zlib:2
- ENUM[ 19]   9.zlib:3
- ENUM[ 20]   9.zlib:4
- ENUM[ 21]   9.zlib:5
- ENUM[ 22]   9.zlib:6
- ENUM[ 23]   9.zlib:7
- ENUM[ 24]   9.zlib:8
- ENUM[ 25]   9.zlib:9
- ENUM[ 26]   9.lzo
- ENUM[ 27]   9.zstd
- ENUM[ 28]   9.no
- ENUM[ 29]  29.v1
- ENUM[ 30]  29.v2
- ENUM[ 31]  18.bug
- ENUM[ 32]  18.panic

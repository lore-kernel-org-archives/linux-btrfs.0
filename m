Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6622C46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 12:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9839620862
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 12:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9839620862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbeKEWGx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:06:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:39966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbeKEWGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 17:06:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4CA25AE1D
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 12:47:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3670FDA8C0; Mon,  5 Nov 2018 13:47:04 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 4.19
Date:   Mon,  5 Nov 2018 13:47:04 +0100
Message-Id: <20181105124704.6118-1-dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 4.19 have been released.

The version 4.18 was skipped to keep the time of release close to kernel. The
sort-of promise that 'progs version X supports features from kernel X' does not
hold for the user accessible ioctls to list subvolumes. As this is not a
critical feature that's missing, hopefully this is berable.

On the downside this blocked the whole 4.18 release as this is a user interface
change that must be done right on the first try. I don't want to repeat this in
future releases so the kernel/userspace feature parity will be more relaxed.

Changes since 4.19-rc1: fix test failure for check --mode=lowmem

Changes:

* check: support repair of fs with free-space-tree feature
* core:
  * port delayed ref infrastructure from kernel
  * support write to free space tree
* dump-tree: new options for BFS and DFS enumeration of b-trees
* quota: rescan is now done automatically after 'assign'
* btrfstune: incomplete fix to uuid change
* subvol: fix 255 char limit checks
* completion: complete block devices and now regular files too
* docs:
  * ship uncompressed manual pages
  * btrfsck uses a manual page link instead of symlink
* other
  * improved error handling
  * docs
  * new tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (9):
      btrfs-progs: btrfstune: allow to continue uuid change
      btrfs-progs: tests: renumber last fsck test to 036-rescan-not-kicked-in
      btrfs-progs: docs: use manual page link instead of symlink
      btrfs-progs: build: remove gzip dependency
      btrfs-progs: docs: update clean target file masks
      btrfs-progs: clean up .gitignore
      btrfs-progs: tests: add runtime check for free-space-tree
      btrfs-progs: convert strerror to implicit %m
      btrfs-progs: update CHANGES for v4.19

Mike Gilbert (1):
      btrfs-progs: docs: install uncompressed manual pages

Misono Tomohiro (3):
      btrfs-progs: doc: update manual page of btrfs subvolume
      btrfs-progs: ioctl/libbtrfsutil: add 3 definitions of new unprivileged ioctl
      libbtrfsutil: factor out btrfs_util_subvolume_info_fd

Nikolay Borisov (23):
      btrfs-progs: tests: add test for missing device delete error value
      btrfs-progs: add __free_extent2 function
      btrfs-progs: add alloc_reserved_tree_block2 function
      btrfs-progs: Add delayed refs infrastructure
      btrfs-progs: Make btrfs_write_dirty_block_groups take only trans argument
      btrfs-progs: Wire up delayed refs
      btrfs-progs: Remove old delayed refs infrastructure
      btrfs-progs: Remove __free_extent2, now unused
      btrfs-progs: Merge alloc_reserved_tree_block2 and alloc_reserved_tree_block
      btrfs-progs: Add support for freespace tree in btrfs_read_fs_root
      btrfs-progs: Add extent buffer bitmap manipulation infrastructure
      btrfs-progs: Replace homegrown bitops related functions with kernel counterparts
      btrfs-progs: Implement find_*_bit_le operations
      btrfs-progs: Pull free space tree related code from kernel
      btrfs-progs: Hook FST code in extent (de)alloc
      btrfs-progs: Add freespace tree as compat_ro supported feature
      btrfs-progs: check: Add support for freespace tree fixing
      btrfs-progs: tests: Test for FST corruption detection/repair
      btrfs-progs: check: lowmem: Factor out inline extent checking code in its own function
      btrfs-progs: check: lowmem: Refactor extent len test in check_file_extent_inline
      btrfs-progs: check: lowmem: Refactor extent type checks in check_file_extent
      btrfs-progs: btrfstune: Remove fs_info arg from change_device_uuid
      btrfs-progs: btrfstune: Rename change_header_uuid to change_buffer_header_uuid

Qu Wenruo (22):
      btrfs-progs: transaction: do proper error handling in transaction commit
      btrfs-progs: completion: use _filedir to replace _btrfs_devs
      btrfs-progs: completion: let dump-tree/dump-super/inode-resolve accept any file
      btrfs-progs: print-tree: skip deprecated blockptr / nodesize output
      btrfs-progs: exit gracefully if we hit ENOSPC when allocating tree block
      btrfs-progs: exit gracefully when root dir item repair fails
      btrfs-progs: only warn if there are leaked extent buffers after transaction abort
      btrfs-progs: fix infinite loop when bad key order repair fails
      btrfs-progs: exit gracefully when device extent allocation fails
      btrfs-progs: rescue-super: don't double free fs_devices
      btrfs-progs: qgroup: don't return 1 if qgroup is marked inconsistent during relationship assignment
      btrfs-progs: convert: Make read_disk_extent return more -EIO instead of -1
      btrfs-progs: convert: Output meaningful error messages for create_image
      btrfs-progs: image: Warn about log tree generation mismatch when restoring
      btrfs-progs: Replace root parameter using fs_info for reada_for_search()
      btrfs-progs: Introduce function to find next sibling tree block
      btrfs-progs: print-tree: Introduce breadth-first search
      btrfs-progs: print-tree: Introduce --bfs and --dfs options
      btrfs-progs: print-tree: Use bool for @follow
      btrfs-progs: qgroup: Use bool to replace int for @rescan
      btrfs-progs: qgroup: make --rescan the default behavior after assign
      btrfs-progs: doc: Update btrfs-qgroup regarding the rescan conditions

Rosen Penev (1):
      btrfs-progs: Eliminate remaining uses of strerror(errno)

Su Yanjun (3):
      btrfs-progs: change filename limit to 255 when creating subvolume
      btrfs-progs: tests: Add the testcase for subvolume name length limit test
      btrfs-progs: consitfy keys passed to serch functions

Su Yue (2):
      btrfs-progs: docs: update document about option -R of btrfs-scrub
      btrfs-progs: dump-tree: print invalid argument and strerror


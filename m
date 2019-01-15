Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F3C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 13:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5634620656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 13:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfAONlX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:41:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:43582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729324AbfAONlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 08:41:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 631FDAF91
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 13:41:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2A52DA83D; Tue, 15 Jan 2019 14:40:52 +0100 (CET)
Date:   Tue, 15 Jan 2019 14:40:52 +0100
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs pre-release 4.20-rc1
Message-ID: <20190115134052.GH2900@suse.cz>
Mail-Followup-To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1 (2014-03-12)
From:   David Sterba <dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

this is a pre-release of btrfs-progs, 4.20-rc1.

The 4.20 release is scheduled to this Friday, +3 days (2019-01-18).

Changelog:
  * image: fix blockgroups when restroring from multi-device image
  * new feature: metadata uuid
    * lightweight change of UUID without rewriting all metadata
      (incompatible change)
    * done by btrfstune -m/-M
    * needs kernel support, 5.0+
  * check
    * more device extent checks and fixes
    * can repair dir item with mismatched hash
  * mkfs: uuid tree created with proper contents
  * other:
    * new tests
    * libbtrfsutil: fix tests if kernel lacks support for new subvolume ioctls
    * build fixes
    * doc fixes

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Disseldorp (1):
      btrfs-progs: docs: fix balance -f grammar

David Sterba (5):
      btrfs-progs: docs: enhance subvol show documentation and help
      btrfs-progs: tests: speed up fsck/037 free space tree test
      btrfs-progs: docs: add bootlaoder support section to section 5

Johannes Thumshirn (1):
      btrfs-progs: provide etags make target

Nikolay Borisov (6):
      btrfs-progs: Add support for metadata_uuid field
      btrfs-progs: btrfstune: Add support for changing the user uuid
      btrfs-progs: Remove fsid/metdata_uuid fields from fs_info
      btrfs-progs: Remove btrfs_fs_info::new_fsid
      btrfs-progs: Directly pass root to change_devices_uuid
      btrfs-progs: tests: Add tests for changing fsid feature

Omar Sandoval (1):
      libbtrfsutil: fix unprivileged tests if kernel lacks support

Qu Wenruo (31):
      btrfs-progs: fsck-tests: Move reloc tree images to 020-extent-ref-cases
      btrfs-progs: image: Refactor fixup_devices() to fixup_chunks_and_devices()
      btrfs-progs: image: Fix block group item flags when restoring multi-device image to single device
      btrfs-progs: volumes: Refactor btrfs_alloc_dev_extent() into two functions
      btrfs-progs: image: Remove all existing dev extents for later rebuild
      btrfs-progs: misc-tests/021: Do extra btrfs check before mounting
      btrfs-progs: Makefile.extrawarn: Import cc-disable-warning
      btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
      btrfs-progs: Fix -Wimplicit-fallthrough warning
      btrfs-progs: Fix -Wsuggest-attribute=format warning
      btrfs-progs: Fix -Wtype-limits warning
      btrfs-progs: Move btrfs_check_nodesize to fsfeatures.c to fix missing-prototypes warning
      btrfs-progs: Introduce rescue.h to resolve missing-prototypes for chunk and super rescue
      btrfs-progs: Add utils.h include to solve missing-prototypes warning
      btrfs-progs: free-space-tree: Remove unused function
      btrfs-progs: Fix Wempty-body warning
      btrfs-progs: image: Use correct device size when restoring
      btrfs-progs: check: lowmem: Add check for overlapping dev extents
      btrfs-progs: check: orig:  Add ability to detect bad dev extents
      btrfs-progs: check: lowmem: Add dev_item check for used bytes and total bytes
      btrfs-progs: check: orig: Add dev_item check for used bytes and total bytes
      btrfs-progs: tests: Add test image for dev extents beyond device boundary
      btrfs-progs: check: lowmem: Add ability to repair dir item with mismatched hash
      btrfs-progs: check: orig: Use mismatch_dir_hash_record to record bad dir items
      btrfs-progs: check: orig: Add ability to repair dir item with invalid hash
      btrfs-progs: tests: check: Make 026-bad-dir-item-name verify if btrfs-check can also repair
      btrfs-progs: Export btrfs_create_tree() and move it to disk-io.c
      btrfs-progs: mkfs: Create data reloc tree from scratch
      btrfs-progs: uuid: Port kernel btrfs_uuid_tree_lookup()
      btrfs-progs: uuid: Port btrfs_uuid_tree_add() function
      btrfs-progs: Create uuid tree with proper contents

Su Yanjun (1):
      btrfs-progs: silence build warning caused by gcc 8 '-Wformat-truncation'

Su Yue (1):
      btrfs-progs: trivial fix of line break in repair_inode_nbytes_lowmem()

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:47892 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeAQFRW (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 17 Jan 2018 00:17:22 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3] Lowmem fsck repair to fix filetype mismatch
Date: Wed, 17 Jan 2018 13:17:07 +0800
Message-Id: <20180117051710.16853-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sebastian reported a filesystem corruption where DIR_INDEX has wrong
filetype against INODE_ITEM.

Lowmem mode normally handles such problem by checking DIR_INDEX,
DIR_ITEM and INODE_REF/INODE_ITEM to determine the correct file type.
In such case, lowmem mode fsck can get the correct filetype.

When fixing the problem, lowmem mode will try to re-insert correct
(DIR_INDEX, DIR_ITEM, INODE_REF) tuple, and if existing correct
DIR_ITEM and INODE_REF is found, btrfs_link() will just skip and only
insert correct DIR_INDEX.

However, when inserting correct DIR_INDEX, due to extra DIR_INDEX
validation, incorrect one will be skiped and correct one will be
inserted after invalid one.

This leads to lowmem mode repair to create duplicated DIR_INDEX.

This patch will fix it by removing the whole (DIR_INDEX, DIR_ITEM,
INODE_REF) tuple before inserting correct tuple.
And the removing part, btrfs_unlink(), will be enhanced to handle
incorrect tuple member more robust.

Please note that, due a bug in lowmem mode repair, btrfs check will
still show "error(s) found in fs tree" even repair is done successfully.

And test case for this repair still needs extra work for original mode
to support such repair, or test case won't pass original mode test.

Qu Wenruo (3):
  btrfs-progs: lowmem fsck: Remove corupted link before re-add correct
    link
  btrfs-progs: dir-item: Allow dir item and dir index lookup to ignore
    found problem
  btrfs-progs: dir-item: Make btrfs_delete_one_dir_name more robust to
    handle corrupted name len

 cmds-check.c   |  6 +++++-
 convert/main.c |  2 +-
 ctree.h        |  4 ++--
 dir-item.c     | 45 +++++++++++++++++++++++++++++++++++----------
 inode.c        | 14 +++++++-------
 5 files changed, 50 insertions(+), 21 deletions(-)

-- 
2.15.1


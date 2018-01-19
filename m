Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37123 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbeASHZr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 02:25:47 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
Subject: [PATCH v2 0/3] Lowmem fsck repair to fix filetype mismatch
Date: Fri, 19 Jan 2018 15:25:33 +0800
Message-Id: <20180119072536.22286-1-wqu@suse.com>
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

Changelog:
v2:
  No longer play tricks to add new parameters to let btrfs_unlink() to
  locate invalid dir_index, but remove the unnecessary filetype check in
  verify_dir_item().
  Since user of functions in dir-items.c are all btrfs check, either
  repairing or checking, and both original mode and lowmem mode can
  handle it well.

Qu Wenruo (3):
  btrfs-progs: lowmem fsck: Remove corupted link before re-add correct
    link
  btrfs-progs: dir-item: Don't do extra filetype validaction check for
    btrfs_match_dir_item_name
  btrfs-progs: dir-item: Make btrfs_delete_one_dir_name more robust to
    handle corrupted name len

 cmds-check.c |  4 ++++
 dir-item.c   | 17 +++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.15.1


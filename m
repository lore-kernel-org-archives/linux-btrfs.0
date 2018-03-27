Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750907AbeC0HTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3136AFE8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:39 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/10] Simplify function interfaces
Date: Tue, 27 Mar 2018 10:19:22 +0300
Message-Id: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of functions in lowmem mode take an 'ext_ref' parameter only to pass it
down the call chain where it eventually is consumed. Turns out the functions
which actually check the parameter are find_inode_ref and check_inode_item, the
are only passing it down to them. At the same time those functions can get a 
reference to fs_info and do the check in them at the appropriate time. 

This patchset cleanups the interface of various function by dropping the 
ext_ref argument and moving the actual query of the EXTREF feature closer to 
where it's being used. 

The final patch just changes signature of __btrfs_fs_incompat to better match 
the logic of the code and be identical to its kernel counterpart. All in all 
this series doesn't introduce any functional changes per-se.

Nikolay Borisov (10):
  btrfs-progs: Drop ext_ref parameter from find_inode_ref
  btrfs-progs: Drop ext_ref param from check_dir_item
  btrfs-progs: Drop ext_ref argument from check_inode_item
  btrfs-progs: Drop unused ext_ref parameter from process_one_leaf
  btrfs-progs: Remove ext_ref param from check_fs_first_inode
  btrfs-progs: Remove ext_ref param from walk_down_tree
  btrfs-progs: Drop ext_ref param from check_fs_first_inode
  btrfs-progs: Drop ext_ref arument from check_fs_root
  btrfs-progs: Remove ext_ref local variable from check_fs_roots_lowmem
  btrfs-progs: Make __btrfs_fs_incompat return bool

 check/mode-lowmem.c | 63 +++++++++++++++++++++++------------------------------
 ctree.h             |  2 +-
 2 files changed, 28 insertions(+), 37 deletions(-)

-- 
2.7.4


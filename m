Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaL3O5g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0C65FABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:34 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/5] Btrfs progs, coverity fixes for 3.18-rc3
Date: Tue, 30 Dec 2014 15:57:34 +0100
Message-Id: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several issues reported by coverity, minor resource leaks and two bugfixes.

David Sterba (5):
  btrfs-progs: check, fix path leak in error branch
  btrfs-progs: fi show, don't leak canonical path
  btrfs-progs: check, missing parens around compound block in
    find_normal_file_extent
  btrfs-progs: fix overflow check in btrfs_insert_inode_ref
  btrfs-progs: fix minor leak of dev_info in btrfs_scan_kernel

 cmds-check.c      | 8 +++++---
 cmds-filesystem.c | 6 ++++--
 inode-item.c      | 2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.1.3


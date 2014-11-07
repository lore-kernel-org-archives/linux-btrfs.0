Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKGQrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:01 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8175AACF9
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 16:47:00 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4] More mount-time checks
Date: Fri,  7 Nov 2014 17:47:00 +0100
Message-Id: <cover.1415378049.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series adds more superblock checks that turned out not to be enough after
"btrfs: add more superblock checks". Would be good to get them into 3.18 as I'd
like to submit them to stable kernels as well. This is not easily possible
right now as it depends on a patch that's not merged yet (mentioned below).

Based on current master plus patch

"btrfs: fix typos in btrfs_check_super_valid"
(https://patchwork.kernel.org/patch/5206401/)

David Sterba (4):
  btrfs: more superblock checks, lower bounds on devices and
    sectorsize/nodesize
  btrfs: add checks for sys_chunk_array sizes
  btrfs: cleanup, rename a few variables in btrfs_read_sys_array
  btrfs: add more checks to btrfs_read_sys_array

 fs/btrfs/disk-io.c | 38 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 55 +++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 76 insertions(+), 17 deletions(-)

-- 
1.8.4.5


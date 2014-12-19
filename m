Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSQGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 048E3AC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:22 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6] Btrfs progs, coverity fixes for 3.18
Date: Fri, 19 Dec 2014 17:06:21 +0100
Message-Id: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few straightforward fixes.

David Sterba (6):
  btrfs-progs: corrupt block, add missing break to option I
  btrfs-progs: corrupt block, add break after option U
  btrfs-progs: fragments, close output file on error
  btrfs-progs: check result of first_cache_extent
  btrfs-progs: check allocation result in add_clone_source
  btrfs-progs: let btrfs_free_path accept NULL

 btrfs-corrupt-block.c |  2 ++
 btrfs-fragments.c     |  7 +++++--
 cmds-check.c          |  2 ++
 cmds-send.c           | 25 +++++++++++++++++++++----
 ctree.c               |  2 ++
 5 files changed, 32 insertions(+), 6 deletions(-)

-- 
2.1.3


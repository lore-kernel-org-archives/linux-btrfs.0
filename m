Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760826Ab3D3QwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 12:52:15 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3BFFBA5359
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 18:52:14 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] A few message cleanups
Date: Tue, 30 Apr 2013 18:51:56 +0200
Message-Id: <cover.1367339998.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running tests with SANITY_CHECKS enabled and saw that the messages
were not printed with a prefix, fixed. And updated a some lines along
the way. Patches are interdependent.

David Sterba (3):
  btrfs: add prefix to sanity tests messages
  btrfs: move ifdef around sanity checks out of init_btrfs_fs
  btrfs: show compiled-in config features at module load time

 fs/btrfs/free-space-cache.c |  101 ++++++++++++++++++++++---------------------
 fs/btrfs/free-space-cache.h |    2 -
 fs/btrfs/super.c            |   17 ++++++--
 fs/btrfs/version.h          |    4 --
 4 files changed, 65 insertions(+), 59 deletions(-)
 delete mode 100644 fs/btrfs/version.h

-- 
1.7.9


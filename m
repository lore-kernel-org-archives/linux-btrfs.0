Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971AbaFTKHH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 06:07:07 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PULL] [PATCH 0/2] Minor fixups from 3.16-rc1
Date: Fri, 20 Jun 2014 12:07:05 +0200
Message-Id: <cover.1403258476.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

two minor fixups for patches merged in rc1

You can also pull that from
 git://repo.or.cz/linux-2.6/btrfs-unstable.git for-chris/3.16-rc2

with top commit b934864cc8b08eb358748b06468b9cca64026c1e,
based on current for-linus 8408c716d7a4ddd5954ce33f53a7d3cd2876cf65

Thanks.

David Sterba (2):
  btrfs: remove stale comment from btrfs_flush_all_pending_stuffs
  btrfs: use E2BIG instead of EIO if compression does not help

 fs/btrfs/transaction.c |    5 -----
 fs/btrfs/zlib.c        |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

-- 
1.7.9


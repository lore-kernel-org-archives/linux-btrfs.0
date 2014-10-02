Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaJBQxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:53:50 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6E219AB1D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:53:49 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] Remove branch hints
Date: Thu,  2 Oct 2014 18:53:49 +0200
Message-Id: <cover.1412265734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two patches removing some 'unlikely' branch hints where it does not make much
sense. Sent separately from the other cleanups in case they do not seem to fit.

You can pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git remove-unlikely

David Sterba (2):
  btrfs: remove unlikely from NULL checks
  btrfs: remove unlikely from data-dependent branches and slow paths

 fs/btrfs/async-thread.c | 10 +++++-----
 fs/btrfs/extent-tree.c  |  4 ++--
 fs/btrfs/file.c         |  4 ++--
 fs/btrfs/inode.c        | 10 +++++-----
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/transaction.c  |  2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

-- 
1.8.4.5


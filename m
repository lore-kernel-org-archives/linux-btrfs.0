Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbbKJRz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 12:55:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9CC37ACB5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 17:55:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Reduced impact of allocation failures during snapshot creation
Date: Tue, 10 Nov 2015 18:53:53 +0100
Message-Id: <cover.1447177256.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's an improvement in allocation of temporary structures during snaphost
creation, namely the root_item. The allocation is moved to the ioctl call, so
it will fail early and not during the transaction commit. I've once hit it in
practice.

It's aimed for 4.5 dev cycle and can be pulled from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/prealloc-subvol

David Sterba (3):
  btrfs: do an allocation earlier during snapshot creation
  btrfs: allocate root item at snapshot ioctl time
  btrfs: preallocate path for snapshot creation at ioctl time

 fs/btrfs/ioctl.c       | 31 ++++++++++++++++++++-----------
 fs/btrfs/transaction.c | 18 +++++++-----------
 fs/btrfs/transaction.h |  2 ++
 3 files changed, 29 insertions(+), 22 deletions(-)

-- 
2.6.2


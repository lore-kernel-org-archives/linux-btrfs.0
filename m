Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaDOOle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:41:34 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] Snapshot deletion vs send (for 3.15)
Date: Tue, 15 Apr 2014 16:41:19 +0200
Message-Id: <cover.1397572052.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I lost track of these patches at 3.14 development cycle, they accompany the
subvolume RO protections during send. Would be good to get them to 3.15 but I
understand this may be too late.

David Sterba (2):
  btrfs: protect snapshots from deleting during send
  btrfs: assert that send is not in progres before root deletion

 fs/btrfs/ctree.h       |   11 +++++++++++
 fs/btrfs/ioctl.c       |   31 +++++++++++++++++++++++++++++++
 fs/btrfs/send.c        |   14 ++++++++++++--
 fs/btrfs/transaction.c |   13 -------------
 4 files changed, 54 insertions(+), 15 deletions(-)

-- 
1.7.9


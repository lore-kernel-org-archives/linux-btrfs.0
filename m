Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSRig (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:38:36 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PULL] [PATCH 0/4] Updates in message levels
Date: Fri, 19 Dec 2014 18:38:34 +0100
Message-Id: <cover.1419010347.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is motivated by the ERR level when skinny metadata are used, this has been
reported several times. Patch tagged for stable.  The rest is taken from a SLES
patch that I forgot to forward upstream.

You can pull the branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fix/message-levels

based on current master (d790be3863b28fd22e0)

David Sterba (4):
  btrfs: update message levels for errors
  btrfs: update message levels during failed mount
  btrfs: update message levels after checksum errors
  btrfs: set proper message level for skinny metadata

 fs/btrfs/disk-io.c | 29 +++++++++++++++--------------
 fs/btrfs/inode.c   |  4 ++--
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
2.1.3


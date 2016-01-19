Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbcASKnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:43:51 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/4] Btrfs: cleanups for 4.5, part 2
Date: Tue, 19 Jan 2016 11:43:44 +0100
Message-Id: <cover.1453199864.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a handful of cleanups. Geliang Tang's patch is a fixup to his list iterator cleanup,
Jeff's patch has been posted long time ago. Please pull to 4.5.

----------------------------------------------------------------
The following changes since commit a7ca42256d9fad572fb7f2c471514d7d3572b1db:

  btrfs: use list_for_each_entry* in backref.c (2016-01-07 14:42:46 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-cleanups-4.5

for you to fetch changes up to fb75d857a31d600cc0c37b8c7d914014f7fa3f9a:

  btrfs: remove duplicate const specifier (2016-01-19 10:33:56 +0100)

----------------------------------------------------------------
Colin Ian King (1):
  btrfs: remove duplicate const specifier

Dan Carpenter (1):
  Btrfs: clean up an error code in btrfs_init_space_info()

Geliang Tang (1):
  btrfs: fix iterator with update error in backref.c

Jeff Mahoney (1):
  btrfs: cleanup, stop casting for extent_map->lookup everywhere

 fs/btrfs/backref.c     | 10 +++++-----
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/extent_map.c  |  2 +-
 fs/btrfs/extent_map.h  | 10 +++++++++-
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/volumes.c     | 26 +++++++++++++-------------
 7 files changed, 32 insertions(+), 24 deletions(-)

-- 
2.6.3


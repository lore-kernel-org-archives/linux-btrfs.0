From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 0/3] Btrfs: change scrub to support big blocks
Date: Fri, 23 Mar 2012 15:59:07 +0100
Message-ID: <cover.1332513438.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Scrub used to be coded for nodesize == leafsize == sectorsize == PAGE_SIZE.
This is now changed to support nodesize == leafsize == N * PAGE_SIZE.

The "Btrfs: fix scrub statistics report" patch that I sent on 2/10/2012
is also superseeded by this patch. This new patch includes similar
functionality.

Stefan Behrens (3):
  Btrfs: introduce common define for max number of mirrors
  Btrfs: minor cleanup in scrub
  Btrfs: change scrub to support big blocks

 fs/btrfs/ctree.h |    2 +
 fs/btrfs/reada.c |   10 +-
 fs/btrfs/scrub.c | 1380 ++++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 1028 insertions(+), 364 deletions(-)

-- 
1.7.3.4


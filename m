Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45734 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754828Ab1K1TdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:15 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWT5H020777
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWPqq012374
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:26 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWPKG020308
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:25 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWPli020306
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:25 -0200
Message-Id: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 17:17:05 -0200
Subject: [PATCH 00/20] Here's my current btrfs patchset
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first 11 patches are relatively simple fixes or improvements that
I suppose go could make it even in 3.2 (02 is particularly essential
to avoid progressive performance degradation and metadata space waste
in the default clustered allocation strategy).

Patch 12 and its complement 15, and also 19, are debugging aids that
helped me track down the problem fixed in 02.

Patch 13 is a revised version of the larger-clusters patch I posted
before, that adds a microoptimization to the bitmap computations to
the earlier version.

Patches 14 to 20 are probably not suitable for inclusion, and are
provided only for reference, although I'm still undecided on 16: it
seems to me to make sense to stick to the ordered list and index
instead of jumping to the current cluster's block group, but it may
also make sense performance-wise to start at the current cluster and
advance from there.  We still do that, as long as we find a cluster
to begin with, but I'm yet to double check on the race that causes
multiple subsequent releases/creation of clusters under heavy load.
I'm sure I saw it, and I no longer do, but now I'm no longer sure
whether this is the patch that fixed it, or about the details of how
we came about that scenario.

Patches 14, 17, 18 and 20 were posted before, and I'm probably dropping
them from future patchsets unless I find them to be still useful.

Alexandre Oliva (20):
  Btrfs: enable removal of second disk with raid1 metadata
  Btrfs: initialize new bitmaps' list
  Btrfs: fix comment typo
  Btrfs: reset cluster's max_size when creating bitmap cluster
  Btrfs: start search for new cluster at the beginning of the block
    group
  Btrfs: skip block groups without enough space for a cluster
  Btrfs: don't set up allocation result twice
  Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE
  Btrfs: skip allocation attempt from empty cluster
  Btrfs: report reason for failed relocation
  Btrfs: note when a bitmap is skipped because its list is in use
  Btrfs: introduce verbose debug mode for patched clustered allocation
    recovery
  Btrfs: revamp clustered allocation logic
  Btrfs: introduce option to rebalance only metadata
  Btrfs: activate allocation debugging
  Btrfs: try cluster but don't advance in search list
  Btrfs: introduce -o cluster and -o nocluster
  Btrfs: add -o mincluster option
  Btrfs: log when a bitmap is rejected for a cluster
  Btrfs: don't waste metadata block groups for clustered allocation

 fs/btrfs/ctree.h            |    3 +-
 fs/btrfs/extent-tree.c      |  297 ++++++++++++++++++++++++++++++++-----------
 fs/btrfs/free-space-cache.c |  132 ++++++++++---------
 fs/btrfs/ioctl.c            |    2 +
 fs/btrfs/ioctl.h            |    3 +
 fs/btrfs/relocation.c       |    8 +
 fs/btrfs/super.c            |   31 ++++-
 fs/btrfs/volumes.c          |   39 +++++-
 fs/btrfs/volumes.h          |    1 +
 9 files changed, 369 insertions(+), 147 deletions(-)

-- 
1.7.4.4


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:36438 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab3DWNWD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 09:22:03 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp3) (RZmta 31.27 OK)
	with ESMTP id p003c4p3NAm89Y for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Apr 2013 15:21:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] speedup btrfs send/receive
Date: Tue, 23 Apr 2013 15:21:56 +0200
Message-Id: <cover.1366722651.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit changes the btrfs send/receive commands to use the
UUID tree to map UUIDs to subvolumes, and to use the root tree
to map subvolume IDs to paths. Now these tools start fast and are
independent on the number of subvolumes/snapshots that exist.

Before this commit, mapping UUIDs to subvolume IDs was an operation
with a high effort. The algorithm even had quadratic effort (based
on the number of existing subvolumes). E.g. with 15,000 subvolumes
it took much more than 5 minutes on a state of the art XEON CPU to
start btrfs send or receive before these tools were able to send or
receive the first byte).
Even linear effort instead of the current quadratic effort would be
too much since it would be a waste. And these data structures to
allow mapping UUIDs to subvolume IDs had been created every time a
btrfs send/receive instance was started.

It is much more efficient to maintain a searchable persistent data
structure in the filesystem, one that is updated whenever a
subvolume/snapshot is created and deleted, and when the received
subvolume UUID is set by the btrfs-receive tool. The user mode
tools can then just use the tree-search ioctl to quickly retrieve
all information.

With a recent commit, kernel code was added that is able to maintain
data structures in the filesystem that allow to quickly search for a
given UUID and to retrieve data that is assigned to this UUID, like
which subvolume ID is related to this UUID.

This commit series adds support for the UUID tree to Btrfs-progs
and changes the send/receive tools to use it.

Stefan Behrens (3):
  Btrfs-progs: Support UUID tree and UUID items in btrfs-debug-tree
  Btrfs-progs: add uuid-tree lookup methods
  Btrfs-progs: use UUID tree for send/receive

 Makefile       |   2 +-
 cmds-receive.c |  23 ++-
 cmds-send.c    |  53 +++++--
 ctree.h        |  34 ++++
 print-tree.c   |  91 ++++++++++-
 send-utils.c   | 477 +++++++++++++++++++++++----------------------------------
 send-utils.h   |   9 +-
 uuid-tree.c    | 196 ++++++++++++++++++++++++
 8 files changed, 572 insertions(+), 313 deletions(-)
 create mode 100644 uuid-tree.c

-- 
1.8.2.1


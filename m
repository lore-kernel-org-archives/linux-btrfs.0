Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59357 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3FCS5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 14:57:34 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 0/2] introduce list_for_each_entry_del
Date: Mon,  3 Jun 2013 13:28:03 -0400
Message-Id: <1370280485-10047-1-git-send-email-joern@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A purely janitorial patchset.  A fairly common pattern is to take a
list, remove every object from it and do something with this object -
usually kfree() some variant.  A stupid grep identified roughly 300
instances, with many more hidden behind more complicated patterns to
achieve the same end results.

This patchset moves the boilerplate code into list.h and uses it in a
few example places.  Diffstat is pretty clear and imo the code is
improved as well.

Drawback is that object size is growing.  I think an ideal compiler
should be able to optimize all the overhead away, but 4.7 just isn't
there yet.  Or maybe I just messed up - patches are only
compile-tested after all.  Comments/ideas are welcome.

Joern Engel (2):
  list: add list_for_each_entry_del
  btrfs: use list_for_each_entry_del

 fs/btrfs/backref.c      |   15 +++------------
 fs/btrfs/compression.c  |    4 +---
 fs/btrfs/disk-io.c      |    6 +-----
 fs/btrfs/extent-tree.c  |   17 +++--------------
 fs/btrfs/extent_io.c    |    8 ++------
 fs/btrfs/inode.c        |   16 +++-------------
 fs/btrfs/ordered-data.c |    7 +------
 fs/btrfs/qgroup.c       |   22 ++++------------------
 fs/btrfs/relocation.c   |    6 +-----
 fs/btrfs/scrub.c        |    9 +++------
 fs/btrfs/transaction.c  |    5 +----
 fs/btrfs/volumes.c      |   11 ++---------
 include/linux/list.h    |   33 +++++++++++++++++++++++++++++++++
 13 files changed, 58 insertions(+), 101 deletions(-)

-- 
1.7.10.4


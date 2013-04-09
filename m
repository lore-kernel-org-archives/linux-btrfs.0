Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:52461 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 31.25 OK)
	with ESMTP id g06957p39Fj67P for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/17] Btrfs-progs: some receive related patches
Date: Tue,  9 Apr 2013 19:08:28 +0200
Message-Id: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most fixes are trivial.

The one from Alex is fixing a real bug that several users have reported.
Alex sent the patch half a year ago and it was not yet integrated.

The patch "Use /proc/mounts instead of /etc/mtab" is a repost.

The patch "btrfs-receive optionally honors the end-cmd" is a preparation
step to allow backup tools to multiplex a single communication stream
(e.g. a single TCP stream) to carry multiple Btrfs send/receive streams
and a request/response handshake. It basically corrects the handling
of the "end-cmd" in the send/receive stream. Without, only the closing
of the stream (EOF) was terminating the receiver. The change is
fully compatible as it is explained in more detail in the commit itself.
Unfortunately the change to the sender is only compatible together
with a kernel change, it is therefore not part of this patch set.

Everything is also on
git://btrfs.giantdisaster.de/git/btrfs-progs recv1


Alex Lyakas (1):
  btrfs-progs: Fix the receive code pathing

Stefan Behrens (16):
  Btrfs-progs: Use /proc/mounts instead of /etc/mtab
  Btrfs-progs: ignore subvols above BTRFS_LAST_FREE_OBJECTID
  Btrfs-progs: close file descriptor in cmds-send.c
  Btrfs-progs: fix a small memory leak in btrfs-list.c
  Btrfs-progs: add a function to free subvol_uuid_search memory
  Btrfs-progs: cleanup subvol_uuid_search memory in btrfs send/receive
  Btrfs-progs: free memory and close file descriptor in btrfs receive
  Btrfs-progs: Set the root-id for received subvols in btrfs receive
  Btrfs-progs: btrfs-receive: different levels (amount) of debug output
  Btrfs-progs: small parent_subvol cleanup for cmds-receive.c
  Btrfs-progs: fix bug in find_root_gen
  Btrfs-progs: btrfs-receive optionally honors the end-cmd
  Btrfs-progs: don't allocate one byte too much each time
  Btrfs-progs: Fix that BTRFS_FSID_SIZE is used instead of
    BTRFS_UUID_SIZE
  Btrfs-progs: remove some unused code
  Btrfs-progs: allow to receive to relative directories

 btrfs-list.c   |  14 ++---
 cmds-receive.c | 164 ++++++++++++++++++++++++++++++++++++++++++---------------
 cmds-send.c    |  12 ++++-
 send-stream.c  |   9 ++--
 send-stream.h  |   3 +-
 send-utils.c   |  49 +++++++++++++++--
 send-utils.h   |   2 +
 7 files changed, 194 insertions(+), 59 deletions(-)

-- 
1.8.2.1


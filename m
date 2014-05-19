Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbaESQTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:19:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9A6B9AC77
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:19:40 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/5] Documentation updates
Date: Mon, 19 May 2014 18:19:40 +0200
Message-Id: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Formatting changes inspired by Hugo's mail and some fixes that I found along
the way. The update in Availability section removes the "heavy development &
not usable" text.

David Sterba (5):
  btrfs-progs: doc: fix argument notation and typos
  btrfs-progs: doc: remove text for unmerged features
  btrfs-progs: doc: autoformat user-supplied arguments by sed
  btrfs-progs: doc: make all commands and subcommands bold
  btrfs-progs: doc: update the Availability section

 Documentation/Makefile                   |  9 ++--
 Documentation/btrfs-balance.txt          | 30 +++++++-------
 Documentation/btrfs-check.txt            | 18 ++++----
 Documentation/btrfs-convert.txt          |  6 +--
 Documentation/btrfs-debug-tree.txt       |  6 +--
 Documentation/btrfs-device.txt           | 27 +++++-------
 Documentation/btrfs-filesystem.txt       | 70 ++++++--------------------------
 Documentation/btrfs-find-root.txt        |  6 +--
 Documentation/btrfs-image.txt            | 10 ++---
 Documentation/btrfs-inspect-internal.txt | 18 ++++----
 Documentation/btrfs-map-logical.txt      |  6 +--
 Documentation/btrfs-property.txt         | 22 +++++-----
 Documentation/btrfs-qgroup.txt           | 36 ++++++++--------
 Documentation/btrfs-quota.txt            | 16 ++++----
 Documentation/btrfs-receive.txt          | 12 +++---
 Documentation/btrfs-replace.txt          | 16 ++++----
 Documentation/btrfs-rescue.txt           | 16 ++++----
 Documentation/btrfs-restore.txt          | 12 +++---
 Documentation/btrfs-scrub.txt            | 26 ++++++------
 Documentation/btrfs-send.txt             | 10 ++---
 Documentation/btrfs-show-super.txt       |  6 +--
 Documentation/btrfs-subvolume.txt        | 34 ++++++++--------
 Documentation/btrfs-zero-log.txt         | 12 +++---
 Documentation/btrfs.txt                  | 48 +++++++++++-----------
 Documentation/btrfstune.txt              |  6 +--
 Documentation/fsck.btrfs.txt             |  6 +--
 Documentation/mkfs.btrfs.txt             | 12 +++---
 27 files changed, 207 insertions(+), 289 deletions(-)

-- 
1.9.0


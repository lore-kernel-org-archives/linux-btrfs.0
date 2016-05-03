Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbcECQMv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 12:12:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DC25DAB9D
	for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2016 16:12:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Btrfs-progs: fix unaligned acces for ioctl search header
Date: Tue,  3 May 2016 18:12:34 +0200
Message-Id: <cover.1462291729.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reports that some commands fail with SIGBUS on SPARC, due to unaligned
access. We should really use the helpers as the search header data are read
from a random position in the buffer that's returned from the TREE_SEARCH
ioctl.

David Sterba (3):
  btrfs-progs: kerncompat: introduce get_unaligned helpers
  btrfs-progs: add getters for ioctl search_header
  btrfs-progs: use ioctl search headers everywhere

 btrfs-fragments.c | 62 ++++++++++++++++++++++++++++++++++---------------------
 btrfs-list.c      | 21 ++++++++++---------
 cmds-fi-usage.c   |  8 +++----
 cmds-inspect.c    | 23 +++++++++++----------
 cmds-subvolume.c  | 13 ++++++------
 ctree.h           | 26 +++++++++++++++++++++++
 kerncompat.h      |  4 ++++
 qgroup.c          | 44 +++++++++++++++++++++++----------------
 send-utils.c      | 60 ++++++++++++++++++++++++++++++-----------------------
 uuid-tree.c       |  2 +-
 10 files changed, 163 insertions(+), 100 deletions(-)

-- 
2.7.1


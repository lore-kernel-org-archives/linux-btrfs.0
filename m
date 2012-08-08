Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2HHIyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 04:54:50 -0400
Message-ID: <50222948.8030102@cn.fujitsu.com>
Date: Wed, 08 Aug 2012 16:54:32 +0800
From: zhoubo <zhoub-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: btrfs community <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 0/3 V2] Btrfs-progs: enhance btrfs subvol list only to show
 read-only snapshots
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

We want 'btrfs subvolume list' only to list readonly subvolumes, this patch set
introduces a new option 'r' to implement it.

You can use the command like that:

	btrfs subvolume list -r <path>

v1->v2: address the comments from Goffredo Baroncelli
- change the changelog of the patches and make them more elaborate.
- move the function declarations to a new head file.
- add the introduction of the new option 'r' into the man page
---
 btrfs-list.c     |   72 +++++++++++++++++++++++++++++++++++++++++++++++------
 btrfs-list.h     |   21 +++++++++++++++
 cmds-inspect.c   |    4 +--
 cmds-subvolume.c |   18 +++++++------
 ctree.h          |    2 +
 man/btrfs.8.in   |    5 ++-
 6 files changed, 100 insertions(+), 22 deletions(-)
 create mode 100644 btrfs-list.h

-- 
1.6.0.6

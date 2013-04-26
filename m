Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37321 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] Btrfs-progs: start at kernel/userspace syncup
Date: Fri, 26 Apr 2013 16:06:01 -0500
Message-Id: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A first round of small, hopefully obviously-correct and/or no-op
patches that start to make the userspace copies of kernelspace code
look a bit more similar.

Many of these are direct ports from userspace, a couple others
are just my cleanups of various bits here and there.

There'll be a fair bit more after this, but I'll do it in chunks.

(Thanks David!) :)

Thanks,
-Eric

[PATCH 1/9] Btrfs-progs: remove dead btrfs-defrag.c
[PATCH 2/9] Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
[PATCH 3/9] Btrfs-progs: fix array bound checking
[PATCH 4/9] Btrfs-progs: move btrfs_fsck_reinit_root to cmds-check.c
[PATCH 5/9] Btrfs-progs: remove some dead/unbuilt code
[PATCH 6/9] Btrfs-progs: cleanup duplicated division functions
[PATCH 7/9] Btrfs-progs: make extent_ref_type() match kernelspace
[PATCH 8/9] Btrfs-progs: remove the unnecessary 'return -1;' at the end of bin_search
[PATCH 9/9] Btrfs-progs: remove btrfs_init_path calls from ctree.c

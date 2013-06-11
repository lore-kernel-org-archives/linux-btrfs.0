Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42782 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3FKXPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 19:15:24 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs-progs: make some subdirs
Date: Tue, 11 Jun 2013 18:15:16 -0500
Message-Id: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are some patches I've been sitting on for a while that I think
clean up the btrfs-progs tree a bit; there are still quite a few files
left in the top-level dir, but moving tests & cmd files into cmd/
seems to clean things up a bit.  Curious to see what people think.

This is just file-moves and makefile-mangling, no code changes.

(a common/ or similar later on to hold kernel copies would probably
be the next move if this all looks reasonable)

Thanks,
-Eric

[PATCH 1/3] Btrfs-progs: Add Makefile infrastructure for subdirs
[PATCH 2/3] Btrfs-progs: move test tools to tests/ subdir
[PATCH 3/3] Btrfs-progs: move btrfs cmd files to cmd/ subdir

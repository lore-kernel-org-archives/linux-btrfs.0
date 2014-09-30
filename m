Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44795 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaI3WAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 18:00:47 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so8033445pdj.41
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 15:00:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: [PATCH v2 0/3] btrfs: fix several sparse warnings
Date: Tue, 30 Sep 2014 15:01:39 -0700
Message-Id: <cover.1412114127.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series fixes some warnings reported by sparse when building the
btrfs module. It fixes two classes of warnings: address space warnings and lock
context warnings. This didn't uncover any logical errors, but it reduces the
noise when checking the source. There are a few less straightforward sparse
warnings still remaining.

Version 2 replaces an open-coded implementation of kernel_write in write_buf,
doesn't touch unrelated style issues, and add's David's Reviewed-by.

This patch series applies to 3.17-rc7.

Omar Sandoval (3):
  btrfs: replace open-coded kernel_write
  btrfs: fix sparse address space warnings
  btrfs: fix sparse lock context warnings

 fs/btrfs/extent-tree.c      |  1 +
 fs/btrfs/extent_io.c        |  2 +-
 fs/btrfs/free-space-cache.c |  1 +
 fs/btrfs/ioctl.c            |  6 +++---
 fs/btrfs/locking.c          |  1 +
 fs/btrfs/send.c             | 21 ++++++---------------
 6 files changed, 13 insertions(+), 19 deletions(-)

-- 
2.1.1


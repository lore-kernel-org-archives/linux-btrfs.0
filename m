Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35872 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaI1IrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 04:47:17 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj1so5201023pad.15
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 01:47:17 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix several sparse warnings
Date: Sun, 28 Sep 2014 01:48:10 -0700
Message-Id: <1411894092-28784-1-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series fixes some warnings reported by sparse when building the
btrfs module. It fixes two classes of warnings: address space warnings and lock
context warnings. This didn't uncover any logical errors, but it reduces the
noise when checking the source. There are a few less straightforward sparse
warnings still remaining.

Omar Sandoval (2):
  btrfs: fix sparse address space warnings
  btrfs: fix sparse lock context warnings

 fs/btrfs/ctree.c            | 3 ++-
 fs/btrfs/extent-tree.c      | 1 +
 fs/btrfs/extent_io.c        | 2 +-
 fs/btrfs/free-space-cache.c | 1 +
 fs/btrfs/ioctl.c            | 6 +++---
 fs/btrfs/locking.c          | 1 +
 fs/btrfs/send.c             | 8 ++++----
 7 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.1.1


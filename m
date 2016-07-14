Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34332 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcGNXbS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 19:31:18 -0400
Received: by mail-pf0-f179.google.com with SMTP id p64so901893pfb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 16:31:18 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on big-endian systems
Date: Thu, 14 Jul 2016 16:31:05 -0700
Message-Id: <cover.1468538030.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

So it turns out that the free space tree bitmap handling has always been
broken on big-endian systems. Totally my bad.

Patch 1 fixes this. Technically, it's a disk format change for
big-endian systems, but it never could have worked before, so I won't go
through the trouble of any incompat bits. If you've somehow been using
space_cache=v2 on a big-endian system (I doubt anyone is), you're going
to want to mount with nospace_cache to clear it and wait for this to go
in.

Patch 2 fixes a similar error in the sanity tests (it's the same as the
v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
oversight that patch 1 fixes.

Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
pass on x86_64 and MIPS.

Thanks!

1: http://thread.gmane.org/gmane.comp.file-systems.btrfs/58329

Omar Sandoval (3):
  Btrfs: fix free space tree bitmaps on big-endian systems
  Btrfs: fix extent buffer bitmap tests on big-endian systems
  Btrfs: expand free space tree sanity tests to catch endianness bug

 fs/btrfs/extent_io.c                   |  64 +++++++++----
 fs/btrfs/extent_io.h                   |  22 +++++
 fs/btrfs/free-space-tree.c             |  17 ++--
 fs/btrfs/tests/extent-io-tests.c       |  87 +++++++++--------
 fs/btrfs/tests/free-space-tree-tests.c | 164 +++++++++++++++++++--------------
 5 files changed, 223 insertions(+), 131 deletions(-)

-- 
2.9.0


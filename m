Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35341 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733207AbeGLXXM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 19:23:12 -0400
Received: by mail-pl0-f67.google.com with SMTP id k1-v6so11304765plt.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2018 16:11:26 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH RESEND 0/2] btrfs-progs: build improvements
Date: Thu, 12 Jul 2018 16:11:17 -0700
Message-Id: <cover.1531436967.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi, Dave,

This is a resend of a couple of patches I sent back in April, rebased on
the current devel branch. Patch 1 cleans up some stale build targets,
and patch 2 makes the btrfs-progs build more flexible, so that it's
possible to pick and choose what gets built. Please consider these for
the next progs release.

Thanks!

Omar Sandoval (2):
  btrfs-progs: remove stale dir-test and quick-test
  btrfs-progs: make all programs and libraries optional

 Makefile        | 139 ++++++++-----
 Makefile.inc.in |  16 +-
 configure.ac    | 138 +++++++++++--
 dir-test.c      | 518 ------------------------------------------------
 quick-test.c    | 226 ---------------------
 5 files changed, 227 insertions(+), 810 deletions(-)
 delete mode 100644 dir-test.c
 delete mode 100644 quick-test.c

-- 
2.18.0


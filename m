Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37416 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2HyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:04 -0400
Received: by mail-pg0-f67.google.com with SMTP id n11so2570160pgp.4
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:04 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 0/5] libbtrfsutil: misc fixes
Date: Thu, 29 Mar 2018 00:53:52 -0700
Message-Id: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi, Dave,

This is a handful of minor fixes for libbtrfsutil that would be good to
get in before the release. Patch 1 fixes an issue reported by Tomohiro a
few weeks back. Patch 2 fixes a memory leak I noticed while writing
patch 1. Patch 3 makes us use the local mkfs.btrfs so that the tests can
run on the CI system. Patch 4 fixes an issue I noticed while testing
that fix. Patch 5 fixes a test failure caused by "btrfs-progs: mkfs: add
uuid and otime to ROOT_ITEM of, FS_TREE".

Based on your devel branch. Please apply!

Omar Sandoval (5):
  libbtrfsutil: don't return free space cache inodes from
    deleted_subvolumes()
  libbtrfsutil: fix memory leak in deleted_subvolumes()
  libbtrfsutil: use local mkfs.btrfs for tests if it exists
  libbtrfsutil: always build libbtrfsutil.so.$MAJOR
  libbtrfsutil: fix test assumptions about top-level subvolume

 Makefile                                    |  4 ++--
 libbtrfsutil/python/tests/__init__.py       |  6 ++++-
 libbtrfsutil/python/tests/test_subvolume.py |  8 ++++---
 libbtrfsutil/subvolume.c                    | 34 +++++++++++++++++++----------
 4 files changed, 35 insertions(+), 17 deletions(-)

-- 
2.16.3


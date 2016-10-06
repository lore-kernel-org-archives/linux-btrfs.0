Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44301 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbcJFNlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 09:41:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EAF9AADAA
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 13:41:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Btrfs-progs 4.8, fix build on 32bit, ioctl cleanups
Date: Thu,  6 Oct 2016 15:41:37 +0200
Message-Id: <20161006134141.837-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So this series should fix the 32bit build problems, tested on gcc 6.2.1. I've
added test of checking the ioctl numbers: "make test-ioctl" that will build
32bit and 64bit versions (needs compiler for both).

The ioctl compatibility reasoning is in the changelogs. The goal is to keep
everything working (send, receive), so there's no visible change, but more
testing would be welcome of course.

The patchset is now in devel, on top of 4.8.

David Sterba (4):
  btrfs-progs: ioctl: pack structures
  btrfs-progs: ioctl: add 32bit compat for SET_RECEIVED_SUBVOL
  btrfs-progs: ioctl: add 64bit compat for SEND
  btrfs-progs: tests: make the ioctl-test actually useful

 Makefile.in  |  27 +++++-
 ioctl-test.c | 266 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 ioctl.h      |  79 ++++++++++++++++--
 3 files changed, 335 insertions(+), 37 deletions(-)

-- 
2.10.0


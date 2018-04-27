Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758062AbeD0S4p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 14:56:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 426ECACDC
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 18:56:44 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/3] btrfs-progs: build on SLE11
Date: Fri, 27 Apr 2018 14:56:34 -0400
Message-Id: <20180427185637.16642-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch set allows btrfs-progs to build without further patching
on a stock SLE11 SP4 install.  The major issues were:
- new dependencies on e2fsprogs 1.42
- use of -std=gnu90, which gcc 4.3.4 doesn't support
- use of m4_chomp, introduced in autoconf 2.64.

This patch set is also posted as a GitHub pull request:
https://github.com/kdave/btrfs-progs/pull/125

-Jeff

---

Jeff Mahoney (3):
  btrfs-progs: convert: fix support for e2fsprogs < 1.42
  btrfs-progs: build: detect whether -std=gnu90 is supported
  btrfs-progs: build: use m4_flatten instead of m4_chomp

 Makefile                    |  1 -
 Makefile.inc.in             |  1 +
 configure.ac                | 10 +++---
 convert/source-ext2.h       | 12 +++++++-
 m4/ax_check_compile_flag.m4 | 74 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 8 deletions(-)
 create mode 100644 m4/ax_check_compile_flag.m4

-- 
2.12.3


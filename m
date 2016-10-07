Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbcJGM1I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 08:27:08 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.8.1-rc1
Date: Fri,  7 Oct 2016 14:26:51 +0200
Message-Id: <20161007122651.5125-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

another pre-release, just in case.  I did a lot of build tests [1] and
automated a few things so the build failures should not happen again.

ETA for the release is on Sunday (2016-10-09).  Please test and report any new
problems.

Changes since 4.8:
- 32bit build works
  - build without backtrace support fixed

[1]
build tests on arches: arm, aarch64, ppc, ppc64, ppc64le, i586, x86_64
32/64 build on x86_64 (X) default, static (X) gcc 4.8.5, gcc 5.41, gcc 6.2.1

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (10):
      btrfs-progs: build: add explicit option separator to rm commands
      btrfs-progs: ioctl: pack structures
      btrfs-progs: ioctl: add 32bit compat for SET_RECEIVED_SUBVOL
      btrfs-progs: ioctl: add 64bit compat for SEND
      btrfs-progs: tests: make the ioctl-test actually useful
      btrfs-progs: tests: add script to help build coverage
      btrfs-progs: fix printf format of sizeof on 32bit build
      btrfs-progs: test: add default ioctl-test build
      btrfs-progs: update CHANGES for v4.8.1
      Btrfs progs v4.8.1-rc1

Qu Wenruo (1):
      btrfs-progs: Fix warning_trace compile error if backtrace is disabled

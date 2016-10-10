Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750799AbcJJJxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 05:53:43 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jmaggard10@gmail.com, clm@fb.com
Subject: Btrfs progs pre-release 4.8.1-rc2
Date: Mon, 10 Oct 2016 10:38:02 +0200
Message-Id: <20161010083802.9420-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

another pre-release. The problem with ioctl on 32bit ARM that Justin reported
shows we have to be more careful with the changes to ioctl structures. The
build size checks are now optional (make D=bcheck to enable) and the patches to
add packing, alignment or alternate structures are left out.

ETA for 4.8.1 is tomorrow.

Changes since 4.8:
- 32bit build works
- build without backtrace support fixed

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (6):
      btrfs-progs: build: add explicit option separator to rm commands
      btrfs-progs: tests: add script to help build coverage
      btrfs-progs: fix printf format of sizeof on 32bit build
      btrfs-progs: ioctl: make build-time structure size checks optional
      btrfs-progs: update CHANGES for v4.8.1
      Btrfs progs v4.8.1-rc2

Qu Wenruo (1):
      btrfs-progs: Fix warning_trace compile error if backtrace is disabled

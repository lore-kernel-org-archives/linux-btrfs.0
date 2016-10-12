Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933505AbcJLNek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 09:34:40 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8.1
Date: Wed, 12 Oct 2016 15:34:32 +0200
Message-Id: <20161012133432.28679-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.8.1 have been released, with a short delay than estimated. This
is a bugfix release, namely the build has been fixed (32bit and no-backtrace).

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (5):
      btrfs-progs: build: add explicit option separator to rm commands
      btrfs-progs: tests: add script to help build coverage
      btrfs-progs: fix printf format of sizeof on 32bit build
      btrfs-progs: ioctl: make build-time structure size checks optional
      btrfs-progs: update CHANGES for v4.8.1

Qu Wenruo (1):
      btrfs-progs: Fix warning_trace compile error if backtrace is disabled

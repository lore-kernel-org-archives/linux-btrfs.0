Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33861 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933119AbdCaPfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 11:35:02 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.10.2
Date: Fri, 31 Mar 2017 17:34:15 +0200
Message-Id: <20170331153415.2287-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.10.2 have been released.  More build breakages fixed and
some minor updates.

Changes:

 * check: lowmem mode fix for false alert about lost backrefs
 * convert: minor bugfix
 * library: fix build, misisng symbols, added tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (4):
      btrfs-progs: library-test: add all exported headers
      btrfs-progs: add prefix to message helpers
      btrfs-progs: update CHANGES for v4.10.2
      Btrfs progs v4.10.2

Qu Wenruo (4):
      btrfs-progs: Cleanup kernel-shared dir when execute make clean
      btrfs-progs: convert: Add missing return for HOLE mode when checking convert image
      btrfs-progs: check: lowmem, fix false alert about backref lost for SHARED_DATA_REF
      btrfs-progs: tests: Add SHARED_DATA_REF test image for check lowmem mode

Sergei Trofimovich (1):
      btrfs-progs: fix missing __error symbol in libbtrfs.so.0


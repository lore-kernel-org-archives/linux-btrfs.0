Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752844AbdJPRAv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 13:00:51 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.13.3
Date: Mon, 16 Oct 2017 18:58:59 +0200
Message-Id: <20171016165859.4101-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.13.3 have been released.

This is a bugfix release, namely for the subvolume listing and deletion
commands (again), and 'check --force'. Both were not caught by faulty tests,
now fixed.

Changes:
  * check: fix --force, wrong check for a mounted block device
  * build: fix --with-convert parsing
  * subvol list: don't list TOPLEVEL
  * other: update tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (7):
      btrfs-progs: check: drop exclusive open mode for --force
      btrfs-progs: tests: fsck/007 fix so check --force works
      btrfs-progs: build: move travis helper script to own directory
      btrfs-progs: tests: add more configure option coverage
      btrfs-progs: build: add absolute path for topdir
      btrfs-progs: update CHANGES for v4.13.3
      Btrfs progs v4.13.3

Lu Fengqi (1):
      btrfs-progs: subvol list: don't print deleted subvol as TOPLEVEL

Naohiro Aota (1):
      btrfs-progs: build: set include path relatively

Sergei Trofimovich (1):
      btrfs-progs: build: allow '--with-convert=' to accept comma-separated values

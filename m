Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751841AbdJFMxA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 08:53:00 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.13.2
Date: Fri,  6 Oct 2017 14:51:10 +0200
Message-Id: <20171006125110.14138-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.13.2 have been released.

This is a bugfix release for the subvolume listing and deletion commands, and
performance improvement for the 'check' command that should decrease running
time of some fstests.

Changes:
  * subvol list:
    * don't list toplevel subvolume among deleted (broken since 4.8.3)
    * minor adjustments of uuid print format
  * subvol delete:
    * fix swapped behaviour of --commit-each and --commit-after
    * fix potentially lost sync if subvolumes are from different filesystems
  * check: add cache for metadata blocks, should improve performance
  * other:
    * new tests, testsuite updates
    * doc updates
    * cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (9):
      btrfs-progs: mkfs: use existing helper for path concatenation
      btrfs-progs: mkfs: remove unused function
      btrfs-progs: docs: update btrfs-balance
      btrfs-progs: subvol: group options in help
      btrfs-progs: set fixed with for printing uuids of subvolumes
      btrfs-progs: subvol list: don't list FS_TREE as deleted
      btrfs-progs: tests: don't list toplevel subvolme in 'subvol list'
      btrfs-progs: update CHANGES for v4.13.2
      Btrfs progs v4.13.2

Holger Hoffstätte (1):
      btrfs-progs: right-align number columns in btrfs-debugfs output

Jeff Mahoney (7):
      btrfs-progs: check: supplement extent backref list with rbtree
      btrfs-progs: check: switch to iterating over the backref_tree
      btrfs-progs: extent-cache: actually cache extent buffers
      btrfs-progs: backref: push state tracking into a helper structure
      btrfs-progs: backref: add list_first_pref helper
      btrfs-progs: backref: use separate list for missing keys
      btrfs-progs: backref: use separate list for indirect refs

Misono, Tomohiro (6):
      btrfs-progs: subvol: exchange subvol del --commit-after and --commit-each
      btrfs-progs: move get_fsid() to utils.c
      btrfs-progs: move seen_fsid to utils.c
      btrfs-progs: change seen_fsid to hold fd and DIR
      btrfs-progs: subvol: fix subvol del --commit-after
      btrfs-progs: misc-test: use raid1 for data to enable mount with -o degraded

Su Yue (1):
      btrfs-progs: tests: arg override in command line

Yingyi Luo (2):
      btrfs-progs: convert: move link_subvol out of main
      btrfs-progs: add a parameter to btrfs_mksubvol

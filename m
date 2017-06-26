Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751449AbdFZRCH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 13:02:07 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.11.1-rc1
Date: Mon, 26 Jun 2017 19:00:53 +0200
Message-Id: <20170626170053.31270-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged.  A bugfix release.

Changes:
  * image: restoring from multiple devices
  * dev stats: make --check option work
  * check: fix false alert with extent hole on a NO_HOLE filesystem
  * check: lowmem mode, fix false alert in case of mixed inline and compressed
    extent
  * convert: work with large filesystems (many TB)
  * docs updates
  * build: sync Android.mk with Makefile
  * tests:
    * new tests
    * fix 008 and 009, shell quotation mistake

ETA for 4.11.1 is in +4 days (2017-06-30).

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (7):
      btrfs-progs: docs: update formatting of btrfs-rescue
      btrfs-progs: docs: update formatting of btrfs-property
      btrfs-progs: docs: fix sentence for no-dump file attribute
      btrfs-progs: docs: update note about device deletion
      btrfs-progs: build: sync recent makefile changes to android.mk
      btrfs-progs: update CHANGES for v4.11.1
      Btrfs progs v4.11.1-rc1

Filipe Manana (2):
      btrfs-progs: Fix restoring image from multi devices fs into single device
      btrfs-progs: test for restoring multiple devices fs into a single device

Hans van Kranenburg (1):
      btrfs-progs: send operates on ro snapshots only

Kasijjuf (3):
      btrfs-progs: docs: Expand confusing abbreviation in documentation
      btrfs-progs: docs: Wrong section in ref to manpage
      btrfs-progs: docs: replace <dev> with <device>

Lakshmipathi.G (3):
      btrfs-progs: Fix 'btrfs device stats --check' cli option
      btrfs-progs: convert: widen int types in convert context
      btrfs-progs: convert: Add larger device support

Lu Fengqi (1):
      btrfs-progs: lowmem check: Fix false alert about file extent interrupt

Qu Wenruo (2):
      btrfs-progs: check: Fix false alert about EXTENT_DATA that shouldn't be a hole
      btrfs-progs: tests: Add test case to check file hole extents with NO_HOLES flag

Tsutomu Itoh (1):
      btrfs-progs: tests: remove variable quotation from convert-tests


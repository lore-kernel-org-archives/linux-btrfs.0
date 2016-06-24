Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbcFXMvq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 08:51:46 -0400
Date: Fri, 24 Jun 2016 14:52:22 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.6.1
Message-ID: <20160624125222.GB5574@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.6.1 have been released. A bugfix release.

Changes:

* fi resize: negative resize argument accepted again (broken
* qgroup rescan: fix skipping when rescan is in progress
* mkfs: initialize stripesize to correct value
* testsuite updates, mostly convert tests
* documentation updates
  * btrfs-device, btrfs-restore manual pages enhanced
  * misc fixups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Chandan Rajendra (1):
      Btrfs-progs: Initialize stripesize to the value of sectorsize

David Sterba (16):
      btrfs-progs: new helper for option parsing, more permissive for "no options"
      btrfs-progs: fi resize: fix parsing of negative argument
      btrfs-progs: tests: add 003-fi-resize-args
      btrfs-progs: docs: update btrfs-restore manual page
      btrfs-progs: docs: update 'btrfs-device' manual page
      btrfs-progs: tests: split convert_test
      btrfs-progs: tests: print shorter test name in the output
      btrfs-progs: tests: add test console
      btrfs-progs: tests: update README
      btrfs-progs: tests: add 005-delete-all-rollback
      btrfs-progs: tests: fix filesytem type creation for convert tests
      btrfs-progs: build: let autotools include m4
      btrfs-progs: build: add m4 macros for AC_CHECK_DEFINE
      btrfs-progs: build: check if FIEMAP_EXTENT_SHARED is defined
      btrfs-progs: update CHANGES for 4.6.1
      Btrfs progs v4.6.1

Mark Fasheh (1):
      btrfs-progs: free qgroup counts in btrfsck

Noah Massey (1):
      btrfs-progs: doc: add missing newline in btrfs-convert

Qu Wenruo (1):
      btrfs-progs: qgroup: Fix a bug that fails to skip rescan running case

Satoru Takeuchi (2):
      btrfs-progs: doc: correct the destination of btrfs-receive
      btrfs-progs: fi show: print error message if no valid Btrfs is specified

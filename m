Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48293 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754534AbcKYJGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:06:01 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8.4
Date: Fri, 25 Nov 2016 10:05:40 +0100
Message-Id: <20161125090540.24379-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.8.4 have been released.

Changes:
  * check: support for clearing space cache v2 (free-space-tree)
  * send:
    * more sanity checks (with tests), cleanups
    * fix for fstests/btrfs/038 and btrfs/117 failures
  * build:
    * fix compilation of standalone ioctl.h, pull NULL definition
    * fix library link errors introduced in 4.8.3
  * tests:
    * add more fuzzed images from bugzilla
    * add bogus send stream checks
    * fixups and enhancements for CI environment builds
    * misc refinements and updates of testing framework
  * other:
    * move sources for btrfs-image to own directory
    * deprecated and not build by default: btrfs-calc-size, btrfs-show-super
    * docs updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (36):
      btrfs-progs: ioctl: fix compilation if ioctl.h is included standalone
      btrfs-progs: tests: add more fuzzed images from bugzilla
      btrfs-progs: send-stream: switch to common message helpers
      btrfs-progs: send-stream: rename single letter variable
      btrfs-progs: send-stream: fix size types passed to read_buf
      btrfs-progs: send-stream: pass char buffer to read_buf
      btrfs-progs: send-stream: check command length before reading from stream
      btrfs-progs: send-stream: change length type to unsigned
      btrfs-progs: send-stream: use proper type for read return value
      btrfs-progs: send-stream: use proper types for tlv header values
      btrfs-progs: send-stream: don't use single letter variable in tlv_get
      btrfs-progs: send-stream: use proper type for cmd in read_cmd
      btrfs-progs: send-stream: document return values of some functions
      btrfs-progs: send-stream: check number of read bytes from stream
      btrfs-progs: tests: add basic checks for bad stream on the receive side
      btrfs-progs: send-stream: track the read position in the stream
      btrfs-progs: docs: fix typo in btrfs-scrub manual page
      btrfs-progs: tests: use the root helper for various info retrieval commands
      btrfs-progs: tests: change options to list all loop devices
      btrfs-progs: tests: check for TEST_LOG values by a regex
      btrfs-progs: tests: enhance TEST_LOG features
      btrfs-progs: tests: add more tests to the CI build
      btrfs-progs: tests: add fallback to current directory for check_all_images
      btrfs-progs: Update README and other docs
      btrfs-progs: tests: drop redundant test for rwx number validity
      btrfs-progs: tests: more variable quoting in common scripts
      btrfs-progs: tests: add support for additional command arguments
      btrfs-progs: move btrfs-image sources to own directory
      btrfs-progs: deprecate standalone btrfs-calc-size
      btrfs-progs: deprecate standalone btrfs-show-super
      btrfs-progs: move bitops.h to kernel-lib
      btrfs-progs: print-tree: fix format string on 32bit
      btrfs-progs: move lookup_path_rootid to library utils
      btrfs-progs: test: extend library-test coverage
      btrfs-progs: build: link against local libraries
      btrfs-progs: update CHANGES for v4.8.4

Goldwyn Rodrigues (1):
      btrfs-progs: return best entry, if it is the first one

Omar Sandoval (7):
      btrfs-progs: add the FREE_SPACE_TREE_VALID compat_ro bit definition
      btrfs-progs: format FREE_SPACE_TREE{,_VALID} nicely in dump-super
      btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
      btrfs-progs: add btrfs_clear_free_space_tree() from the kernel
      btrfs-progs: implement btrfs check --clear-space-cache v2
      btrfs-progs: document space_cache=v2 more thoroughly
      btrfs-progs: check: fix missing newlines

Qu Wenruo (1):
      btrfs-progs: utils: Fix NULL pointer derefernces in string_is_numerical

Tsutomu Itoh (4):
      btrfs-progs: send: fix failure of fstests btrfs/038
      btrfs-progs: test: fix error of test target of Makefile
      btrfs-progs: qgroup: fix error in ASSERT condition expression
      btrfs-progs: test: fix how to make test files in fsck-tests 013

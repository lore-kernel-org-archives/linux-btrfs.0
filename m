Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38833 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935560AbdIYQib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 12:38:31 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.13.1
Date: Mon, 25 Sep 2017 18:36:53 +0200
Message-Id: <20170925163653.32108-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.13.1 have been released.

The ZSTD support has been added, the kernel code will land in 4.14. Now
configure will detect if libzstd is available and will use it. In the future
this will become a mandatory dependency. Please check your distro for libzstd
and ask them to add it eventually. As a fallback, it is and will be possible to
disable zstd detection (and btrfs restore will obviously lack the support).

Changes:
  * image: speed up generating the sanitized names, do not generate unprintable chars
  * completion: add missing commands, better mount point detection
  * restore: add zstd support; libzstd detected automatically, will be
    requested by default in the future, or can be configured out
  * other:
    * misc fixes found by sparse
    * doc enhancements, ioctl manual page started
    * updated and new tests
    * build fixes

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (18):
      btrfs-progs: README: update links, enhance contribution section
      btrfs-progs: tests: fix run_mustfail in cli-tests/007-check-force
      btrfs-progs: build: sync Makefile to Android.mk
      btrfs-progs: convert: use correct string printing for errcode_t
      btrfs-progs: tests: remove temporary loopdev files
      btrfs-progs: tests: remove temporary images in mkfs/005 and mkfs/006
      btrfs-progs: build: whitespace adjustment of [LD] fssum
      btrfs-progs: tests: make sure _is_file_or_command does not get confused
      btrfs-progs: docs: start ioctl documentation manual page
      btrfs-progs: fix debugging macro checks
      btrfs-progs: print-tree: use proper helper for reading offset
      btrfs-progs: free-space-cache: fix endianity when reading from disk_key
      btrfs-progs: updated and add missing function attributes to the definition
      btrfs-progs: build: add missing defines for the C=1 build
      btrfs-progs: build: use -std=gnu89 for sparse
      btrfs-progs: build: add more sparse warning checks
      btrfs-progs: tests: check there are no unprintable characters in btrfs-image -ss output
      btrfs-progs: update CHANGES for v4.13.1

Misono, Tomohiro (2):
      btrfs-progs: update btrfs-completion
      btrfs-progs: cleanup whitespaces of btrfs-completion

Naohiro Aota (2):
      btrfs-progs: build: generate all dependency files
      btrfs-progs: build: omit unnecessary -MD flag

Nicholas D Steeves (2):
      btrfs-progs: tests: Add required IETF Trust copyright to SHA implementation
      btrfs-progs: tests: Remove misleading BCP 78 boilerplate from SHA implementation

Nick Terrell (2):
      btrfs-progs: Add zstd support
      btrfs-progs: tests: add testing image for zstd for btrfs-restore

Piotr Pawlow (6):
      btrfs-progs: image: fix non-printable characters in generated file names
      btrfs-progs: image: move core find_collision code to a separate function
      btrfs-progs: image: add reverse CRC32C table
      btrfs-progs: image: add a function to calculate CRC32C collisions
      btrfs-progs: image: add a function to check if generated filename suffix is valid
      btrfs-progs: image: use CRC32C reversing instead of brute force to find collisions

Qu Wenruo (2):
      btrfs-progs: Refactor find_next_chunk to get rid of parameter root and objectid
      btrfs-progs: Fix one-byte overlap bug in free_block_group_cache

Uli Heller (1):
      btrfs-progs: Removed missing header file, fixes compilation error

yingyil (1):
      btrfs-progs: mkfs: refactor create_data_reloc_tree


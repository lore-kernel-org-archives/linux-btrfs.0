Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbbITNQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 09:16:42 -0400
Date: Sun, 20 Sep 2015 15:15:47 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.2.1
Message-ID: <20150920131547.GW8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's a bugfix release of btrfs-progs.

* fix an off-by-one error in cross-stripe boundary check
  * if nodesize was 64k, any metadata block was reported as crossing, this leads
    to mkfs failure for example due to "no free blocks found"
  * for other nodesizes, if the end of the metadata block was 64k aligned, it
    was incorrectly reported by fsck

* convert:
  * don't write uninitialized data to image

* image:
  * don't loop with option -t0
  * don't create threads if compression is not requested

* other: minor cleanups

The pending patches in the mailinglist are scheduled for next minor
release.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Shortlog:

Arnd Hannemann (1):
      btrfs-progs: makefile: drop u option from ar invocation

David Sterba (9):
      btrfs-progs: autogen: add check for pkg-config
      btrfs-progs: INSTALL: enhance build instructions
      btrfs-progs: tests: add crafted and fuzzed images
      btrfs-progs: fix cross stripe boundary check
      btrfs-progs: cleanup, make usage strings static
      btrfs-progs: cleanup, mark more functions static
      btrfs-progs: cleanup, update function definitions to be ANSI conformant
      btrfs-progs: docs: add option variants, defaults and versions to mount options
      Btrfs progs v4.2.1

Omar Sandoval (1):
      btrfs-progs: use calloc instead of malloc+memset for tree roots

Zhao Lei (7):
      btrfs-progs: fix typo in set/get of btrfs_inode_item::sequence
      btrfs-progs: Avoid uninitialized data in output of btrfs-convert
      btrfs-progs: close inode scan in copy_inodes
      btrfs-progs: image: fix infinite looping with -t 0
      btrfs-progs: image: don't create unused threads
      btrfs-progs: image: close all_devices at the end
      btrfs-progs: tests: Add '-o loop' to mount command line in convert-tests.sh


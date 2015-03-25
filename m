Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbbCYR7r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 13:59:47 -0400
Date: Wed, 25 Mar 2015 18:59:46 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.19.1
Message-ID: <20150325175945.GK20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 3.19.1 have been released. Mostly a bugfix release with an
enhancement to convert.

User visible changes:

- convert:
  - new option to specify metadata block size
  - --no-progress actually works
- restore: properly handle the page boundary corner case
- build fixes:
  - missing macro from public header, BTRFS_BUILD_VERSION
  - wrong handling of --enable-convert
- fi usage: reports correct space for degraded mounts

Other:

  - mkfs: help string updates
  - completion: added 'usage' subcommands
  - cleanups in qgroup code, preparatory work

Thanks.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

---
Shortlog:

David Sterba (9):
      btrfs-progs: fi usage, fix reporting space for degraded mounts
      btrfs-progs: convert tests: add remaining supported nodesizes
      btrfs-progs: convert, fix typo in getopt value
      btrfs-progs: completion: add fi and dev usage commands
      btrfs-progs: convert, add long options for all short options
      btrfs-progs: mkfs, align help strings
      btrfs-progs: mkfs, add required arguments to help strings
      Btrfs progs v3.19.1-rc1
      Btrfs progs v3.19.1

Gui Hecheng (1):
      btrfs-progs: restore, fix page alignment issue for lzo compression

Lokesh Mandvekar (1):
      btrfs-progs: re-introduce BTRFS_BUILD_VERSION in version.h

Mike Gilbert (1):
      btrfs-progs: Fix autoconf handling of --enable-convert

Qu Wenruo (6):
      btrfs-progs: Update qgroup status flags and replace qgroup level/subvid calculation with inline function
      btrfs-progs: Allow btrfs-debug-tree to print human readable qgroup status flag.
      btrfs-progs: Move parse_qgroupid() to utils.c
      btrfs-progs: Allow parse_qgroupid() to resolve subvolume path into qgroupid
      btrfs-progs: Add stack get/set functions for btrfs_qgroup_status_item
      btrfs-progs: Print warning message if qgroup data is inconsistent

Sebastian Thorarensen (4):
      btrfs-progs: mkfs: Move out some nodesize code
      btrfs-progs: Fix msgs in check_node_or_leaf_size
      btrfs-progs: btrfs-convert: Allow setting nodesize
      btrfs-progs: Add nodesize test for btrfs-convert

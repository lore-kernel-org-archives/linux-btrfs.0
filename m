Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbbKPNmJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 08:42:09 -0500
Date: Mon, 16 Nov 2015 14:40:30 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.3.1
Message-ID: <20151116134029.GV6445@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the btrfs-progs 4.3.1 have been released.

* fixes
  * device delete: recognize 'missing' again
  * mkfs: long names are not trimmed when doing ssd check
  * support partitioned loop devices

* other
  * replace several mallocs with on-stack variables
  * more memory allocation failure handling
  * add tests for bugs fixed
  * cmd-device: switch to new message printing helpers
  * minor code cleanups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Shortlog:

Alexander Fougner (1):
      btrfs-progs: allow device deletion using 'missing' keyword again

David Sterba (25):
      btrfs-progs: utils: rename helpinfo unit vairables
      btrfs-progs: simplify empty stirngs check
      btrfs-progs: don't print version info from embedded subcommands
      btrfs-progs: remove unused parameter from print_one_fs
      btrfs-progs: use on-stack buffer for dev_to_fsid
      btrfs-progs: use on-stack buffer for btrfs_scan_one_device
      btrfs-progs: use on-stack variable in __rebuild_device_items
      btrfs-progs: use on-stack buffer in recover_prepare
      btrfs-progs: use on-stack buffer in __ino_to_path_fd
      btrfs-progs: use on-stack buffer in __csum_tree_block_size
      btrfs-progs: handle memory allocation failure in add_file_items
      btrfs-progs: handle memory allocation failures in traverse_directory
      btrfs-progs: use fixed size buffer in zero_output_file
      btrfs-progs: drop unused argument from zero_output_file
      btrfs-progs: calc-size: use on-stack buffer for a helper structure
      btrfs-progs: calc-size: kill fs_roots structure and its user
      btrfs-progs: corrupt-block: use on-stack path buffer in corrupt_dir_item
      btrfs-progs: image: reorder initialization in metadump_init
      btrfs-progs: mkfs: handler memory allocation error in make_btrfs
      btrfs-progs: tests: add 011-delete-missing-device
      btrfs-progs: tests: add 005-long-device-name-for-ssd
      btrfs-progs: utils: do not expect lo_file_name to be null terminated
      btrfs-progs: tests: add 006-partitioned-loopdev
      btrfs-progs: fix fd leak in resolve_loop_device_with_loopdev
      Btrfs progs v4.3.1

Florian Margaine (1):
      btrfs-progs: Fix partitioned loop devices resolving

Michael Lass (1):
      btrfs-progs: mkfs: increase buffer size in is_ssd

Qu Wenruo (1):
      btrfs-progs: find-root: Add support to search chunk root

Zhao Lei (3):
      btrfs-progs: Check periodic.timer_fd's value before use
      btrfs-progs: device: use warning/error for error message
      btrfs-progs: cleanup cmd_device_usage, simplify loop checks


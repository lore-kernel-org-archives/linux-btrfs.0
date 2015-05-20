Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbbETNTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 09:19:15 -0400
Date: Wed, 20 May 2015 15:19:13 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.0.1
Message-ID: <20150520131913.GJ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the btrfs-progs 4.0.1 have been released, a bugfix release with a few
enhancements.

>From now on, the latest development branch will be named 'devel'. It might be
rebased occasionally.

The branch 'master' is updated at the time of release only and is never
rebased, no change here.

Changes:
* restore:
  * can restore symlinks, new option --symlinks
  * long option variants added
* convert: dropped dependency on acl.h header and libacl is not required for
  build
* fix for 'check' crash
* device remove error message fix
* preparatory works for fsid change

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (2):
      btrfs-progs: btrfs_scan_block_devices is unused function delete it
      btrfs-progs: use the correct variable

Dan Merillat (2):
      btrfs-progs: restore: separate the overwrite check
      btrfs-progs: optionally restore symlinks.

David Sterba (4):
      btrfs-progs: restore: use bigger buffer for output path name
      btrfs-progs: restore: shift option texts
      btrfs-progs: restore: add more long option variants
      btrfs-progs: convert: drop dependency on sys/acl.h

Qu Wenruo (15):
      btrfs-progs: fsck: Fix a shallow copy which will leads to segfault.
      btrfs-progs: Add CHANGING_FSID super flag
      btrfs-progs: Use unified function to implement print_readable_*_flag function
      btrfs-progs: show-super: print human readable text for super flags
      btrfs-progs: Add open_ctree check for uuid changing
      btrfs-progs: Export write_tree_block
      btrfs-progs: Introduce change_header_uuid function
      btrfs-progs: Introduce change_extents_uuid function
      btrfs-progs: Introduce change_device_uuid function
      btrfs-progs: Introduce change_devices_uuid function.
      btrfs-progs: Introduce change_fsid_prepare and change_fsid_done functions
      btrfs-progs: Introduce change_uuid function
      btrfs-progs: Remove non-exist csum size.
      btrfs-progs: Add extra chunk item check to avoid btrfs-progs crash.
      btrfs-progs: Fix a bug in chunk item extra check and allow degraded chunk.


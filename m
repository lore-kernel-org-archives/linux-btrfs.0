Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaL3Qel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 11:34:41 -0500
Date: Tue, 30 Dec 2014 17:34:39 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.18
Message-ID: <20141230163439.GP6490@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

let me announce the release of btrfs-progs version 3.18. There are
updates to UI and several enhancements of check/repair. About 100
commits from 14 contributors, thank you all!

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Major user-visible changes:

* mkfs - skinny-metadata feature is now on by default, first introduced
  in kernel 3.10

New subcommands:

* filesystem usage - give an overview of fs usage in a way that's more
  comprehensible than existing 'fi df'
  * on kernels < 3.18: requires root due to restricted ioctl FS_INFO
  * raid 5/6 numbers may be missing due to restricte ioctl (TREE_SEARCH)
  * that's used to calculate the numbers
* device usage - more detailed information about per-device allocations
  * same restrictions as for 'fi usage'

New features, options:

* check
  * option to set a different tree root byte number
  * ability to link lost files to lost+found, caused by a recent
    kernel bug
  * repair of severely corrupted fs (use with care):
    * recover from corrupted b-tree
    * ability to rebuild inode items from other items
    * improved rebuilding of extent tree with snapshots
* convert
  * option to show progress
* subvol create - print the commit mode inline, print the global mode
  only if --verbose

Other updates:

* musl-libc build support
* bugfixes for coverity reports
* new test images, testing framework
* documentation

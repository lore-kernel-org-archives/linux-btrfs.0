Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcCRQoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 12:44:07 -0400
Date: Fri, 18 Mar 2016 17:43:40 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.5-rc2
Message-ID: <20160318164340.GD21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5-rc2 have been released. The changes in option parsing broke
several commands, that's been fixed since rc1 but I'd rather give it some more
time before 4.5 release. New ETA is this Sunday.

Changes since rc1:

* bugfixes
  * subvol sync: fix crash, memory corruption
  * argument parsing fixes: subvol get-default, qgroup
    create/destroy/assign, inspect subvolid-resolve
  * fi du: fixed column order
  * verify that given path to device is a block device or regular file,
    in several commands
* other
  * documentation updates
  * testsuite updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Alexander Fougner (1):
      btrfs-progs: fi du: fix incorrect column order

Austin S. Hemmelgarn (1):
      btrfs-progs: add stat check in open_ctree_fs_info

David Sterba (7):
      btrfs-progs: subvol sync: fix memory corruption, undersized array
      btrfs-progs: tests: add 013-subvolume-sync-crash
      btrfs-progs: docs: man5, add space_cache=v2
      btrfs-progs: handle stat errors in open_ctree_fs_info
      btrfs-progs: switch to common message helpers in open_ctree_fs_info
      btrfs-progs: tests: enumerate RWX in convert tests
      Btrfs progs v4.5-rc2

Lakshmipathi.G (1):
      btrfs-progs: tests: populate fs with small dataset for convert tests

Satoru Takeuchi (5):
      btrfs-progs: subvol get-default: fix argument parsing
      btrfs-progs: qgroup create/destroy: fix argument parsing
      btrfs-progs: inspect subvolid-resolve: fix argument parsing
      btrfs-progs: qgroup assign: can't handle options
      btrfs-progs: qgroup assign: handle --no-rescan option

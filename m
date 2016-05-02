Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcEBNoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 09:44:12 -0400
Date: Mon, 2 May 2016 15:43:54 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.5.2
Message-ID: <20160502134353.GI29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5.2 have been released. A bugfix release. ETA for 4.6 is week
after kernel 4.6 release (~3 weeks from now), so there's time for bigger
changes, like the convert or checker patchsets. I still have enough old
patchsets in the backlog so something from that could be merged as well.

Changes:
  * new/moved command: btrfs-calc-stats -> btrfs inspect tree-stats
  * check: fix false alert for metadata blocks crossing stripe boundary
  * check: catch when qgroup numbers mismatch
  * check: detect running quota rescan and report mismatches
  * balance start: add safety delay before doing a full balance
  * fi sync: is now silent
  * fi show: don't miss filesystems with partially matching uuids
  * dev ready: accept only one argument for device
  * dev stats: print "devid:N" for a missing device instead of "(null)"
  * other:
    * lowest supported version of e2fsprogs is 1.41
    * minor cleanups, test updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Alexander Fougner (2):
      btrfs-progs: copy btrfs-calc-size to inspect-internal tree-stats
      btrfs-progs: update docs and completion for tree-stats

Anand Jain (1):
      btrfs-progs: fix re-declared get_device_info()

David Sterba (14):
      btrfs-progs: tests: add support for command line coverage tests
      btrfs-progs: fi sync: make it silent by default
      btrfs-progs: replace leafsize with nodesize
      btrfs-progs: deprecate and stop using btrfs_level_size
      btrfs-progs: check: cleanup, move structure definitions to the beginning
      btrfs-progs: check: refactor add_extent_rec, separate lookup
      btrfs-progs: check: use add_extent_rec_nolookup after lookups
      btrfs-progs: convert: fix typo in original image subvolume name
      btrfs-progs: add CHANGES 3.12 - 4.5.1
      btrfs-progs: add safety delay before starting full balance
      btrfs-progs: tests: add 002-balance-full-no-filters
      btrfs-progs: handle memory allocation error in cmd_device_stats
      btrfs-progs: update CHANGES for 4.5.2
      Btrfs progs v4.5.2

Patrik Lundquist (1):
      btrfs-progs: device stats: Print devid instead of null

Qu Wenruo (5):
      btrfs-progs: fsck: Fix a false metadata extent warning
      btrfs-progs: Fix return value bug of qgroups check
      btrfs-progs: Fix an extent buffer leak in qgroups check
      btrfs-progs: Read qgroup status for qgroup verify
      btrfs-progs: Restrict e2fsprogs version for convert

Satoru Takeuchi (2):
      btrfs-progs: "device ready" accepts just one device
      btrfs-progs: prop: remove an unnecessary condition on parse_args

Yauhen Kharuzhy (1):
      btrfs-progs: Check if the FSID was seen by comparing full UUID


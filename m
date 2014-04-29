Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbaD2P46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 11:56:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 60E9FAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 15:56:57 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 00/14] Enhanced df - followup
Date: Tue, 29 Apr 2014 17:56:47 +0200
Message-Id: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is a followup to the df (space usage) enhancements, Goffredo's
patches are merged without changes, though the code needs updates.

But, given the patchset size, net benefit of the enriched output and
longstanding need of the update, I've deliberately skipped the process of
incremental rewiew/resend loop that should normally take place and implemented
the changes that were agreed in previous discussions and did code cleanups
along the way.

The basic layout of the command output has been kept, there are some
tweaks or additions.

Changes:
* btrfs filesystem disk_usage - renamed to usage
  * added a section of overall filesystem usage, that used to be in the
    'fi df' output
* btrfs device disk_usage - renamed to usage
  * the device size prints both blockdevie size and the size that's occupied
    by the filesystem
  * device ID is printed
* btrfs filesystem df - reverted to the original output
* btrfs filesystem df - now prints the GlobalReserve info
* units print B for bytes
* the ioctls FS_INFO and DEV_INFO need root (patches sent to drop that
  requirement), so there's a warning printed instead
* no documentation for now

It's not finished, I've tried to scan all the previous iteration of the
patches for the suggested UI tweaks and probably missed some, but IMO in a
state that can go to git and be scheduled for a near release.

The major UI changes are there, we can tweak it further of course.


David Sterba (14):
  btrfs-progs: read global reserve size from space infos
  btrfs-progs: add original 'df' and rename 'disk_usage' to 'usage'
  btrfs-progs: move device usage to cmds-device, more cleanups
  btrfs-progs: check if we can't get info from ioctls due to permissions
  btrfs-progs: zero out structures before calling ioctl
  btrfs-progs: print B for bytes
  btrfs-progs: Print more info about device sizes
  btrfs-progs: compare unallocated space against the correct value
  btrfs-progs: add section of overall filesystem usage
  btrfs-progs: cleanup filesystem/device usage code
  btrfs-progs: extend pretty printers with unit mode
  btrfs-progs: replace df_pretty_sizes with pretty_size_mode
  btrfs-progs: clean up return codes and paths
  btrfs-progs: move global reserve to overall summary

 cmds-device.c        |  92 +++++++-
 cmds-fi-disk_usage.c | 631 +++++++++++++++++++--------------------------------
 cmds-fi-disk_usage.h |  35 ++-
 cmds-filesystem.c    |  55 ++++-
 ctree.h              |   6 +
 utils.c              |  78 +++++--
 utils.h              |  21 +-
 7 files changed, 482 insertions(+), 436 deletions(-)

-- 
1.9.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab3B0ROr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 12:14:47 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 30439A341E
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 18:14:46 +0100 (CET)
Date: Wed, 27 Feb 2013 18:14:45 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-02-27
Message-ID: <20130227171445.GL27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this time it's the label set/get patches to match ioctl added into
3.9-pre, the initial libify support and small fixes recently sent to the
mailinglist.

   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130227

For those who haven't noticed, the previous integration branch has been
merged and is now in the upstream master branch.

david

---
Anand Jain (1):
      Btrfs-progs: add correct indentation

David Sterba (1):
      btrfs-progs: don't link binaries to a dynamic library

Eric Sandeen (16):
      btrfs-progs: fix btrfs_get_subvol cut/paste error
      btrfs-progs: Remove write-only var fdres in cmd_dev_stats()
      btrfs-progs: btrfs_list_get_path_rootid error handling
      btrfs-progs: avoid double-free in __btrfs_map_block
      btrfs-progs: fix open error test in cmd_start_replace
      btrfs-progs: fix close of error fd in scrub cancel
      btrfs-progs: more scrub cancel error handling
      btrfs-progs: free memory before error exit in read_whole_eb
      btrfs-progs: don't call close on error fd
      btrfs-progs: provide positive errno to strerror in cmd_restore
      btrfs-progs: free allocated di_args in cmd_start_replace
      btrfs-progs: close fd on cmd_subvol_get_default return
      btrfs-progs: fix mem leak in resolve_root
      btrfs-progs: Tidy up resolve_root
      btrfs-progs: fix fd leak in cmd_subvol_set_default
      btrfs-progs: initialize save_ptr prior to strtok_r

Jeff Liu (5):
      Btrfs-progs: Change the label of a mounted file system
      Btrfs-progs: Fix set_label_unmounted() with label length validation
      Btrfs-progs: fix cmd_label_usage to reflect this change.
      btrfs-progs: refactor check_label()
      btrfs-progs: move btrfslabel.[c|h] stuff to utils.[c|h]

Mark Fasheh (1):
      btrfs-progs: libify some parts of btrfs-progs

Tsutomu Itoh (1):
      Btrfs-progs: fix segmentation fault of "btrfs check"

Wang Shilong (2):
      Btrfs-progs: let the error message outputed only once
      Btrfs-progs: output the error reason when qgroup_show fails


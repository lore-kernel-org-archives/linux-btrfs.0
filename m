Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaBGNdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 08:33:53 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D86CBABA6
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2014 13:33:52 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4] Btrfs updates for 3.14-rc - sysfs, ioctl
Date: Fri,  7 Feb 2014 14:33:48 +0100
Message-Id: <cover.1391779611.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two minor fixes to the new sysfs code and a RFC change to replace the
GLOBAL_RSV ioctl with the same information exported through SPACE_INFO ioctl.

This requires to reserve a blockgroup type that will become part of ABI.

David Sterba (3):
  btrfs: reserve no transaction units in btrfs_ioctl_set_features
  btrfs: export global block reserve size as space_info
  Revert "btrfs: add ioctl to export size of global metadata
    reservation"

Jeff Mahoney (1):
  btrfs: commit transaction after setting label and features

 fs/btrfs/ctree.h           |  9 ++++++++-
 fs/btrfs/ioctl.c           | 42 +++++++++++++++++++++++-------------------
 include/uapi/linux/btrfs.h |  1 -
 3 files changed, 31 insertions(+), 21 deletions(-)

-- 
1.8.5.2


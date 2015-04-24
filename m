Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031479AbbDXRLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 13:11:53 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D5A46ADB9
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 17:11:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] Better transaction abort reports
Date: Fri, 24 Apr 2015 19:11:51 +0200
Message-Id: <cover.1429894863.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

patch #1 moves the WARN at transaction abort time to the callsite (via macro).
That way we get the exact location of the error and not the common location.
This is supposed to help debugging and screening report, but the change comes
at some cost and increases the resulting asm code.

I vote for better error reports, the .text grows all the time anyway. Patch #2
adds some compiler hints so the error blocks are likely to be put out of the
hot paths.

Available in

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/abort-onsite

David Sterba (3):
  btrfs: report exact callsite where transaction abort occurs
  btrfs: add 'cold' compiler annotations to all error handling functions
  btrfs: fix warnings after changes in btrfs_abort_transaction

 fs/btrfs/ctree.h   | 16 +++++++++++++---
 fs/btrfs/ioctl.c   |  2 +-
 fs/btrfs/super.c   | 11 +++--------
 fs/btrfs/volumes.c |  6 +++---
 4 files changed, 20 insertions(+), 15 deletions(-)

-- 
2.1.3


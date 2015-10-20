Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbbJTRPD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 13:15:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0494FABDC
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 17:15:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3 v3] Balance filters: stripes, enhanced limit and usage
Date: Tue, 20 Oct 2015 19:13:43 +0200
Message-Id: <cover.1445360598.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few more enhancements, I'd like to see all changes to the balance filters
merged into one major release. Thanks.

Changelog (v3):
* I've noticed that we can enhance the 'usage' filter the same way, so do it
  to be consistent with the rest
* the flags for all the new filters have been renamed and look more consistent
  as well:
  BTRFS_BALANCE_ARGS_LIMIT_RANGE
  BTRFS_BALANCE_ARGS_STRIPES_RANGE
  BTRFS_BALANCE_ARGS_USAGE_RANGE
* Not: the flags mask is not yet updated, this will follow, also the progs
  need to be updated accordingly

Changelog (v2):
* the limit_min logic was wrong and did not work, all other filters are locally
  applied to the processed chunk, but for the limit_min we need to count all
  filters first and then decide if we want to rebalance or not

Update to balance filters, intended for 4.4:

* new 'stripes=<range>' - process only stripes that cross given number of
  devices, specified by a range

* updated 'limit=<range>' - previously a single number was accepted, it's a
  range so now we can specify a minimum number of chunks to process

There will be more documentation about the use in the btrfs-progs patches, the
kernel side just applies the ranges. The update to 'limit' is backward
compatible, reuses the previous struct member.

Need the v2 btrfs-progs patchset.

Note to merging: there's a missing patch that actuall adds both filter flags
to the mask, however this patch[1] will supposedly be merged to 4.3-rc6.
Current integration is based on 4.3-rc5 so I can't send a branch containing
that without pulling unrelated patches. I'll send the patch independently so
you can decide how to apply it once your first 4.4 pull request gets merged.

[1] btrfs: check unsupported filters in balance arguments
    (8eb934591f8bf584969454a658f629cd06e59f3a)

----------------------------------------------------------------
The following changes since commit 049e6dde7e57f0054fdc49102e7ef4830c698b46:

  Linux 4.3-rc4 (2015-10-04 16:57:17 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/balance-filters

for you to fetch changes up to c0b33bea07c4e2ae6d4d9ed56b968e7c09b933c4:

  btrfs: extend balance filter usage to take minimum and maximum (2015-10-20 18:58:49 +0200)

----------------------------------------------------------------
David Sterba (2):
      btrfs: extend balance filter limit to take minimum and maximum
      btrfs: extend balance filter usage to take minimum and maximum

Gabríel Arthúr Pétursson (1):
      btrfs: add balance filter for stripes

 fs/btrfs/ctree.h           |  37 +++++++++++++---
 fs/btrfs/volumes.c         | 102 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h         |   3 ++
 include/uapi/linux/btrfs.h |  31 ++++++++++++--
 4 files changed, 164 insertions(+), 9 deletions(-)

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbbJPQvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:51:18 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/2 v2] Balance filters: stripes, enhanced limit
Date: Fri, 16 Oct 2015 18:50:05 +0200
Message-Id: <cover.1445013000.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

for you to fetch changes up to 9811b51815f9b5874832bbfa56a5171bac6aae7d:

  btrfs: add balance filter for stripes (2015-10-16 15:50:00 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: extend balance filter limit to take minimum and maximum

Gabríel Arthúr Pétursson (1):
      btrfs: add balance filter for stripes

 fs/btrfs/ctree.h           | 23 ++++++++++++++---
 fs/btrfs/volumes.c         | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h | 23 +++++++++++++++--
 4 files changed, 104 insertions(+), 5 deletions(-)

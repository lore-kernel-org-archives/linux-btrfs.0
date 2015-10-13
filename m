Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbbJMJIX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 05:08:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 15413ABF7
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 09:08:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Balance filters: stripes, enhanced limit
Date: Tue, 13 Oct 2015 11:07:13 +0200
Message-Id: <cover.1444664601.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update to balance filters, intended fro 4.4:

* new 'stripes=<range>' - process only stripes that cross given number of
  devices, specified by a range

* updated 'limit=<range>' - previously a single number was accepted, it's a
  range so now we can specify a minimum number of chunks to process

There will be more documentation about the use in the btrfs-progs patches, the
kernel side just applies the ranges. The update to 'limit' is backward
compatible, reuses the previous struct member.

Can be pulled from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/balance-filters

I'm finalizing the progs patches and haven't tested that them extensively.


David Sterba (1):
  btrfs: extend balance filter limit to take minimum and maximum

Gabríel Arthúr Pétursson (1):
  btrfs: add balance filter for stripes

 fs/btrfs/ctree.h           | 23 ++++++++++++++++++++---
 fs/btrfs/volumes.c         | 33 +++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h | 23 +++++++++++++++++++++--
 4 files changed, 76 insertions(+), 5 deletions(-)

-- 
2.6.1


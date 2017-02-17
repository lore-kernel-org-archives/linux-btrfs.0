Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934053AbdBQSGU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0D6D4AC17
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] Parameter reduction in compression wrappers
Date: Fri, 17 Feb 2017 19:05:46 +0100
Message-Id: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've noticed that some of the parameters passed to compress_pages are redundant
and that we can either reuse a parameter for both input and output value
(number of pages) or we can infer some value from the existing parameters (the
maximum output limit).

There's no functional change, the stack consumption is slightly smaller.

David Sterba (5):
      btrfs: merge length input and output parameter in compress_pages
      btrfs: merge nr_pages input and output parameter in compress_pages
      btrfs: export compression buffer limits in a header
      btrfs: use predefined limits for calculating maximum number of pages for compression
      btrfs: derive maximum output size in the compression implementation

 fs/btrfs/compression.c | 33 ++++++++++++++-------------------
 fs/btrfs/compression.h | 28 +++++++++++++++++++---------
 fs/btrfs/inode.c       | 37 +++++++++++++------------------------
 fs/btrfs/lzo.c         | 10 +++++-----
 fs/btrfs/zlib.c        |  9 +++++----
 5 files changed, 56 insertions(+), 61 deletions(-)

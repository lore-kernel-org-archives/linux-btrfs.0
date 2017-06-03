Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdFCHiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:38:10 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: dedicated error codes for the block layer V3
Date: Sat,  3 Jun 2017 09:37:53 +0200
Message-Id: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series introduces a new blk_status_t error code type for the block
layer so that we can have tigher control and explicit semantics for
block layer errors.

All but the last three patches are cleanups that lead to the new type.

The series it mostly limited to the block layer and drivers, and touching
file systems a little bit.  The only major exception is btrfs, which
does funny things with bios and thus sees a larger amount of propagation
of the new blk_status_t.

A git tree is also available at:

    git://git.infradead.org/users/hch/block.git block-errors

gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors

Note the the two biggest patches didn't make it to linux-block and
linux-btrfs last time.  If you didn't get them they are available in
the git tree above.  Unfortunately there is no easy way to split them
up.

Changes since V2:
 - minor tweaks from reviews

Changes since V1: 
 - keep blk_types.h for now
 - removed a BUG_ON in dm-mpath

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933855AbdERNSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 09:18:30 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: dedicated error codes for the block layer
Date: Thu, 18 May 2017 15:17:57 +0200
Message-Id: <20170518131812.22956-1-hch@lst.de>
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

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbbFCNoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 09:44:20 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dm-devel@redhat.com
Subject: [RFC] add a bi_error field
Date: Wed,  3 Jun 2015 15:42:38 +0200
Message-Id: <1433338959-24808-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bio error reporting has been a mess for a while, and the increasing
use of chained bios makes it worse.

This series attempts to add a proper error field to struct bio
to sort this out.  It's working fine for me, but MD and btrfs were
doing pretty nasty things with the BIO_UPTODATE flag, so I would
appreciate some detailed review there.


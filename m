Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45813 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933923AbcKJUGC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 15:06:02 -0500
Date: Thu, 10 Nov 2016 12:06:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: bi_vcnt checks for repair
Message-ID: <20161110200601.GA2859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

btrfs_check_repairable and bio_readpage_error have somewhat odd
looking check for bi_vcnt, checking on how to proceed based on that.

Does anyone remember what they actually are checking for?  Depending
on the exact devices merging bi_vcnt can mean quite a few different
things, and we should probably check for what people actually intended
to check.

The suspect for adding these checks are in Cc, although the commit
history is a bit murky.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49399 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdEPL4G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 07:56:06 -0400
Date: Tue, 16 May 2017 04:56:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] block: Introduce blkdev_issue_flush_no_wait()
Message-ID: <20170516115605.GA18649@infradead.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <20170516093914.16035-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170516093914.16035-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 05:39:13PM +0800, Anand Jain wrote:
> blkdev_issue_flush() is a blocking function and returns only after
> the flush bio is completed, so a module handling more than one
> device can't issue flush for all the devices unless it uses worker
> thread.
> 
> This patch adds a new function blkdev_issue_flush_no_wait(), which
> uses submit_bio() instead of submit_bio_wait(), and accepts the
> completion function and data from the caller.

Just open code the damn thing, and drop the various superflous checks
while you're at it.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36699 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdEUHJq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 03:09:46 -0400
Date: Sun, 21 May 2017 00:09:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        linux-block@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] block: Introduce blkdev_issue_flush_no_wait()
Message-ID: <20170521070945.GC10453@infradead.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <20170516093914.16035-2-anand.jain@oracle.com>
 <20170516115605.GA18649@infradead.org>
 <d97acfdb-3ab1-5722-f341-a8feba1a72ef@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d97acfdb-3ab1-5722-f341-a8feba1a72ef@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 05:31:32PM +0800, Anand Jain wrote:
>  You mean at btrfs: write_dev_flush()
>    OR
>  block: blkdev_issue_flush() ?
>  Where I find
>         q = bdev_get_queue(bdev);
>         if (!q)
>                 return -ENXIO
>  isn't needed as anyway generic_make_request_checks() will
>  check that down below.
>  Not too sure about the other two checks though.

I was looking at your new function, but indeed it seems like the
function is mostly copy & pasted from blkdev_issue_flush.

The bdev->bd_disk, !bdev_get_queue and q->make_request_fn checks
are all things you don't need, any blkdev_issue_flush should not
either, although I'll need to look into the weird loop workaround
again, which doesn't make much sense to me.

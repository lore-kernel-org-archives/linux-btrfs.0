Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45470 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933175AbdEXIhB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 04:37:01 -0400
Subject: Re: [PATCH 1/2] block: Introduce blkdev_issue_flush_no_wait()
To: Christoph Hellwig <hch@infradead.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <20170516093914.16035-2-anand.jain@oracle.com>
 <20170516115605.GA18649@infradead.org>
 <d97acfdb-3ab1-5722-f341-a8feba1a72ef@oracle.com>
 <20170521070945.GC10453@infradead.org>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8969d6ba-d053-63ba-06dc-7eecf2de4d77@oracle.com>
Date: Wed, 24 May 2017 16:42:25 +0800
MIME-Version: 1.0
In-Reply-To: <20170521070945.GC10453@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The bdev->bd_disk, !bdev_get_queue and q->make_request_fn checks
> are all things you don't need, any blkdev_issue_flush should not
> either, although I'll need to look into the weird loop workaround
> again, which doesn't make much sense to me.

  I tried to confirm q->make_request_fn and got lost, I am going to
  try again.

Thanks, Anand

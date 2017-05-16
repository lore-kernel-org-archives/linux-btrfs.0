Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3445 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbdEPOHc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 10:07:32 -0400
From: Bart Van Assche <Bart.VanAssche@sandisk.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "anand.jain@oracle.com" <anand.jain@oracle.com>
CC: "dsterba@suse.cz" <dsterba@suse.cz>
Subject: Re: [RFC PATCH 0/2] Introduce blkdev_issue_flush_no_wait()
Date: Tue, 16 May 2017 14:07:23 +0000
Message-ID: <1494943642.2935.1.camel@sandisk.com>
References: <20170516093914.16035-1-anand.jain@oracle.com>
In-Reply-To: <20170516093914.16035-1-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2017-05-16 at 17:39 +0800, Anand Jain wrote:
> BTRFS wanted a block device flush function which does not wait for
> its completion, so that the flush for the next device can be called
> in the same thread.
> 
> Here is a RFC patch to provide the function
> 'blkdev_issue_flush_no_wait()', which is based on the current device
> flush function 'blkdev_issue_flush()', however it uses submit_bio()
> instead of submit_bio_wait().
> 
> This patch is for review comments, will send out a final patch based
> on the comments received.

Hello Anand,

Since the block layer can reorder requests, I think using
blkdev_issue_flush_no_wait() will only yield the intended result if
the caller waits until the requests that have to be flushed have completed.
Is that how you intend to use this function?

Thanks,

Bart.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm

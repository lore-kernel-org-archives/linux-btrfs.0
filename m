Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48833 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2H0Pbu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 11:31:50 -0400
Message-ID: <503B92DD.4010804@oracle.com>
Date: Mon, 27 Aug 2012 23:31:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: tubalcane@earthlink.net, linux-btrfs@vger.kernel.org
Subject: Re: crash while trying to access corrupt fs
References: <alpine.LFD.2.02.1208261605440.5416@bubblegum> <503B561A.1060203@giantdisaster.de>
In-Reply-To: <503B561A.1060203@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/27/2012 07:12 PM, Stefan Behrens wrote:
> On Sun, 26 Aug 2012 16:07:33 -0400 (EDT), tubalcane wrote:
>> I'm primarily interested in the block level checksums of files and the
>> scrubbing
>> feature to detect corrupt files.  Currently I use ext4 and create and keep
>> md5sums of everything which is tedious but I care about my data (quadruple
>> backups including offsite)
>>
[...]
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.835479]  [<ffffffffa04d344a>]
>> btrfs_find_device_for_logical+0x4a/0xa0 [btrfs]
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.836717]  [<ffffffffa04c6955>]
>> end_bio_extent_readpage+0x105/0xa80 [btrfs]
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.837938]  [<ffffffff81173569>] ?
>> kfree+0x139/0x160
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.839157]  [<ffffffff811baaad>]
>> bio_endio+0x1d/0x40
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.840395]  [<ffffffffa049be81>]
>> end_workqueue_fn+0x41/0x50 [btrfs]
>> Aug 25 11:37:24 bubblegum kernel: [ 1183.841635]  [<ffffffffa04d4d46>]
>> worker_loop+0x136/0x580 [btrfs]
> 
> That crash is a bug which I have introduced with the IO error stats. It can happen after checksum errors are detected.
> I'll send a patch to (temporarily) remove the counting for checksum errors in the IO error stats.

Just out of curiosity, isn't it fixable due to your design, Stefan?
Why not try to fix the bug?

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


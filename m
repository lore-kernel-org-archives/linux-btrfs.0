Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:14692 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2H0QMb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 12:12:31 -0400
Message-ID: <503B9C6E.10200@giantdisaster.de>
Date: Mon, 27 Aug 2012 18:12:30 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: tubalcane@earthlink.net, linux-btrfs@vger.kernel.org
Subject: Re: crash while trying to access corrupt fs
References: <alpine.LFD.2.02.1208261605440.5416@bubblegum> <503B561A.1060203@giantdisaster.de> <503B92DD.4010804@oracle.com>
In-Reply-To: <503B92DD.4010804@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Aug 2012 23:31:41 +0800, Liu Bo wrote:
> On 08/27/2012 07:12 PM, Stefan Behrens wrote:
>> On Sun, 26 Aug 2012 16:07:33 -0400 (EDT), tubalcane wrote:
>>> I'm primarily interested in the block level checksums of files and the
>>> scrubbing
>>> feature to detect corrupt files.  Currently I use ext4 and create and keep
>>> md5sums of everything which is tedious but I care about my data (quadruple
>>> backups including offsite)
>>>
> [...]
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.835479]  [<ffffffffa04d344a>]
>>> btrfs_find_device_for_logical+0x4a/0xa0 [btrfs]
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.836717]  [<ffffffffa04c6955>]
>>> end_bio_extent_readpage+0x105/0xa80 [btrfs]
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.837938]  [<ffffffff81173569>] ?
>>> kfree+0x139/0x160
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.839157]  [<ffffffff811baaad>]
>>> bio_endio+0x1d/0x40
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.840395]  [<ffffffffa049be81>]
>>> end_workqueue_fn+0x41/0x50 [btrfs]
>>> Aug 25 11:37:24 bubblegum kernel: [ 1183.841635]  [<ffffffffa04d4d46>]
>>> worker_loop+0x136/0x580 [btrfs]
>>
>> That crash is a bug which I have introduced with the IO error stats. It can happen after checksum errors are detected.
>> I'll send a patch to (temporarily) remove the counting for checksum errors in the IO error stats.
> 
> Just out of curiosity, isn't it fixable due to your design, Stefan?
> Why not try to fix the bug?

Yes, it is fixable. But it is complicated (and a source for new errors),
and I wanted to quickly prevent any more harm caused by this bug. People
who face that bug get a kernel crash whenever they access that corrupted
part of the filesystem.

The right btrfs_device pointer is needed in order to find the statistic
counters to increment. One would need to take some code of
bio_readpage_error() and some code of repair_io_failure() to retrieve
the btrfs_device pointer, and that would be rather huge additional code.
But maybe I am just not seeing the simple way to do it. Any simple
solution would be appreciated.

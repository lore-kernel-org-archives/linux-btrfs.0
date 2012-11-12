Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31497 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2KLPIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 10:08:51 -0500
Date: Mon, 12 Nov 2012 23:08:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ross Moore <ross@rossmoore.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Bug
Message-ID: <20121112150847.GD6347@gmail.com>
References: <CAJDbZnThjTHNON46Sb5QWyaJ9VuaKkza=Z6+OE_dh_YqavtDJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJDbZnThjTHNON46Sb5QWyaJ9VuaKkza=Z6+OE_dh_YqavtDJQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 12, 2012 at 10:37:58PM +0800, Ross Moore wrote:
> Hi,
> 
> I have a BTRFS filesystem that seems to be suffering from a few
> problems. I'll post the first one, which looks most bizarre to me.
> 
> The filesystem is mounted at /media/Media. It consists of 4 devices in
> RAID1 (both metadata and data), of sizes 3*2TB and 1*1TB. The result
> of sudo btrfs fi df /media/Media/ is as follows:
> Data, RAID1: total=3.06TB, used=8.74TB
> System, RAID1: total=32.00MB, used=1.81MB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=130.29GB, used=9.41GB
> 
> I'm running Ubuntu Quantal, on the stock 3.5 kernel (with stock
> btrfs-tools), but the filesystem has been around for a over a year
> now, since Oneiric or maybe Natty. It has been causing a few problems
> recently with the odd kernel crash, but this line in bold seems the
> most odd. It reports Total as smaller than Used. That just seems very
> wrong to me. I'd also like to rescue my filesystem rather than kill it
> and restore from backup if possible (since it's pretty big and
> restoring would take a while / be error-prone).
> 

Can you provide the output of 'btrfs-debug-tree /dev/sdd'?

thanks,
liubo

> I'm no kernel developer, but I am able  to compile and and willing to
> help debug issues given instructions.
> 
> I also have the following mentions of btrfs in the syslog following boot:
> Nov 12 22:10:43 HomeServer kernel: [    6.756770] btrfs: bdev
> /dev/disk/by-uuid/f2178b12-fa9c-4fa0-9efb-11ad188156c0 errs: wr 0, rd
> 0, flush 0, corrupt 0, gen 0
> Nov 12 22:10:43 HomeServer kernel: [   14.613574] btrfs: bdev /dev/sdd
> errs: wr 72, rd 0, flush 0, corrupt 0, gen 0
> Nov 12 22:10:43 HomeServer kernel: [   14.613578] btrfs: bdev /dev/sdc
> errs: wr 542570, rd 559160, flush 0, corrupt 891, gen 0
> Nov 12 22:10:43 HomeServer kernel: [   14.613582] btrfs: bdev /dev/sdb
> errs: wr 156, rd 1166758, flush 0, corrupt 0, gen 0
> Nov 12 22:10:43 HomeServer kernel: [   14.613584] btrfs: bdev /dev/sda
> errs: wr 44273, rd 2378244, flush 0, corrupt 429, gen 0
> 
> If I attempt to rebalance, the kernel crashes after a while, well
> before it has had a chance to complete.
> 
> Any assistance greatly appreciated, and I hope I can also help
> identify a bug with help.
> 
> Thanks,
> Ross
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

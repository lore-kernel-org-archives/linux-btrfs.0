Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41296 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753029AbeGFJQd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2018 05:16:33 -0400
Subject: Re: Issue on BTRFS/copy of really huge files
To: Juergen Sauer <juergen.sauer@automatix.de>, linux-btrfs@vger.kernel.org
References: <918a550f-2782-7549-6a75-3e1c6dd7fab9@automatix.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <6babd15f-ec97-dc15-f14f-1732e33b4791@applied-asynchrony.com>
Date: Fri, 6 Jul 2018 11:16:31 +0200
MIME-Version: 1.0
In-Reply-To: <918a550f-2782-7549-6a75-3e1c6dd7fab9@automatix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/18 10:37, Juergen Sauer wrote:
..
> Moving a virtual machine from ssd/raid1 subvolume (nocow) into the
> rotational big store (noocow) fails.
> After filling up the cachememory (ram) the data flow cuts down to zero
> 0 kb/sec.
> In fatal result the copy of an huge file hangs does not proceed any
> more, load raises infinite, iops falling to zero. In kernel log I find:
> 
> [  491.151952] INFO: task kworker/u16:28:1027 blocked for more than 120
> seconds.
> [  491.151953]       Tainted: P           O      4.17.3-1-ARCH #1
> [  491.151953] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  491.151953] kworker/u16:28  D    0  1027      2 0x80000000
> [  491.151965] Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper
> [btrfs]
> [  491.151965] Call Trace:
> [  491.151967]  ? __schedule+0x282/0x890
> [  491.151969]  schedule+0x32/0x90
> [  491.151970]  io_schedule+0x12/0x40
> [  491.151971]  blk_mq_get_tag+0x146/0x2a0

This has nothing to do with btrfs and is simply one of the remaining
(but already fixed upstream) bugs in the blk-mq stack, probably related
to sbitmap concurrency and or "tag starvation".
I could give you a list of patches from 4.18+ that help (reliably)
but I suppose you're not into kernel patching, so the easiest way for
you would be to to switch to the old block layer (e.g. by booting
with kernel flag scsi_mod.use_blk_mq=0) and use deadline/cfq as before.

This should all be fixed & work reliable with 4.18+; it looks that by
4.19 blk-mq will also be enabled by default.

cheers
Holger

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60215 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751405AbaAEXsf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 18:48:35 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C9CBEF.2000309@gmx.at>
Date: Sun, 5 Jan 2014 16:48:33 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <846FC885-56B5-422B-9366-D690D4258139@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at>
To: Sulla <Sulla@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 2:17 PM, Sulla <Sulla@gmx.at> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dear Chris!
> 
> Certainly: I have 3 HDDs, all of which WD20EARS.

These drives don't have a configurable SCT ERC, so you need to modify the SCSI block layer timeout:

echo 120 >/sys/block/sdX/device/timeout

You also need to schedule regular scrubs at the md level as well.

echo check > /sys/block/mdX/md/sync_action
cat /sys/block/mdX/mismatch_cnt

More info about this is in man 4 md, and on the linux-raid list.

> 
>      3904907520 blocks super 1.2 level 5, 8k chunk, algorithm 2 [3/3] [UUU]

OK so 8KB chunk, 16KB full stripe, so that doesn't apply to what I was thinking might be the case. The workload is presumably small file sizes, like a mail server?


> any other information I can supply?

I'm not a developer, I don't know if this problem is known or maybe fixed in a newer kernel than 3.11.0 - which has been around for 5-6 months. I think the main suggestion is to try a newer kernel, granted with the configuration of md, lvm, and btrfs you have three layers that will likely have kernel changes. I'd make sure you have backups. While this layout is valid and should work, it's also probably less common and therefore less tested.

Usually in case of blocking devs want to see sysrq+w issued. The setup is dmesg -n7, and enable sysrq functions. Then reproduce the block, and during the block issue w to the sysrq trigger, then capture dmesg contents and post the block and any other nearby btrfs messages.

https://www.kernel.org/doc/Documentation/sysrq.txt


Chris Murphy
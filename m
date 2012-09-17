Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43411 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2IQGqL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 02:46:11 -0400
Message-ID: <5056C728.40606@oracle.com>
Date: Mon, 17 Sep 2012 14:46:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Antoine Sirinelli <antoine@monte-stello.com>
CC: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Oops with a "degraded" volume
References: <20120915141737.GA4784@kabis>
In-Reply-To: <20120915141737.GA4784@kabis>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2012 10:17 PM, Antoine Sirinelli wrote:
> Hi,
> 
> I have experienced a very reproducible Oops within the btrfs driver. On
> a linux 3.5.4, if I mount a volume with the option "degraded" because
> one of the device is missing, I would get an Oops when I unmount it (or
> even before). You can see attached the kernel log.
> 

Thanks for the report.  And this has been fixed by

commit 99f5944b8477914406173b47b4f261356286730b
    Btrfs: do not strdup non existent strings

You can find this commit in 3.6.0-rc5. :)

thanks,
liubo

> Here is how I create my btrfs volume:
> 
> # mkfs.btrfs /dev/vdb /dev/vdc
> # mount /dev/vdb /mnt
> # dd if=/dev/zero of=/mnt/zeros count=1M
> # umount /mnt
> # shutdown -h now
> 
> I am then wiping one volume (/dev/vdc) and restarting the system. To
> get a crash, here is what I am doing:
> 
> # mount -o degraded /dev/vdb /mnt
> # umount /mnt
> 
> I recognise the volume is not usable after having erased one drive but I
> would expect no to crash the kernel in such circumstances. I am not an
> expert, I am just reporting a crash from an user point of view.
> 
> Antoine
> 




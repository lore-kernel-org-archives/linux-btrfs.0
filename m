From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/buffer.c:2925! when mounted USB-disk is disconnected
Date: Thu, 18 Dec 2008 09:09:32 -0500
Message-ID: <1229609372.27170.141.camel@think.oraclecorp.com>
References: <1229570138.3007.8.camel@nga>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1229570138.3007.8.camel@nga>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-18 at 04:15 +0100, Kay Sievers wrote:
> I see the following when disconnecting a USB-stick containing a
> mounted 2-partitions btrfs volume, and I try to umount it later.
> 
> I reproduced it 3 times, always after a fresh reboot. The box
> is unstable after that, modules can not be unloaded, other fs's
> can not be unmounted.
> 

Ok, this is just one of many problems in the forced usb disconnect area.
But I'll take a look after the holidays.

-chris



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62668 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdITAjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 20:39:43 -0400
Subject: Re: Problems with debian install
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
References: <055f00d8-4910-64eb-ea60-58b41815f2d8@couderc.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <13fa5006-12ed-f3f8-cf85-b48b7a1d5b8a@gmx.com>
Date: Wed, 20 Sep 2017 08:39:32 +0800
MIME-Version: 1.0
In-Reply-To: <055f00d8-4910-64eb-ea60-58b41815f2d8@couderc.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月20日 05:35, Pierre Couderc wrote:
> I am trying to install stretch on a computer with 2 btrfs disks and EFI.
> 
> Is there a howto to do that ? Did someone success ?
> 
> I get problems as soon as the partionning in debian installer. What 
> partitions do I need ? I understand the grub needs them even if btrfs 
> does not require them. But I am lost, I think due to EFI...

For EFI, you must have one EFI system partition, which must be formatted 
as FAT.

So, at least you can't use Btrfs for ESP.

Despite of that, everything can be read/understood by kernel can be your 
/boot (mainly for grub) or /.


It will be even simpler if using systemd-boot (previously called 
gummiboot), just put kernel (with EFI-stub configured) and initrd into 
ESP, mounting ESP as /boot, then everything is done.


For reference, my current fs layout is just like this:
nvme0n1          259:0    0 238.5G  0 disk
├─nvme0n1p1      259:1    0   512M  0 part /boot
└─nvme0n1p2      259:2    0   238G  0 part
   ├─system-root  254:0    0    32G  0 lvm  /
   ├─system-swap  254:1    0     4G  0 lvm  [SWAP]
   └─system-home  254:2    0   150G  0 lvm  /home

As you can see, I'm using systemd-boot, reusing ESP as /boot.
Then as long as one fs/stacked block device is supported by kernel, you 
can use it as you wish.

> 
> I see nothing on that in google.

Well, Archlinux has quite nice wiki page for this:
https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface

Thanks,
Qu

> 
> Thnaks
> 
> PC
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

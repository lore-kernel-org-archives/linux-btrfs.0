Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:53854 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732686AbeHAAzE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 20:55:04 -0400
Subject: Re: Unmountable root partition
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>, linux-btrfs@vger.kernel.org
References: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1d1760be-ef7d-f0e0-7b6c-6575c7d68c5a@mendix.com>
Date: Wed, 1 Aug 2018 01:04:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 07/31/2018 08:03 PM, Cerem Cem ASLAN wrote:
> Hi, 
> 
> I'm having trouble with my server setup, which contains a BTRFS root
> partition on top of LVM on top of LUKS partition. 
> 
> Yesterday server was shut down unexpectedly. I booted the system with a
> pendrive which contains Debian 4.9.18 and tried to mount the BTRFS root
> partition manually. 
> 
> 1. cryptsetup luksOpen /dev/sda5 
> 
> Seems to decrypt the partition (there are no errors) 
> 
> 2. /dev/mapper/foo--vg-root and /dev/mapper/foo--vg-swap_1 is created
> automatically, so I suppose LVM works correctly. 
> 
> 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo 
> Gives the following error: 
> 
>     mount: wrong fs type, bad option, bad superblock on ...
> 
> 4. dmesg | tail 
> Outputs the following: 
> 
> 
>     [17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:
>     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>     [17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0
>     02 00 00 02 00
>     [17755.840921] blk_update_request: I/O error, dev sda, sector 507906
>     [17755.840941] EXT4-fs (dm-4): unable to read superblock
>     [18140.052300] sd 3:0:0:0: [sda] tag#0 FAILED Result:
>     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>     [18140.052305] sd 3:0:0:0: [sda] tag#0 CDB: ATA command pass
>     through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
>     [18142.991851] sd 3:0:0:0: [sda] tag#0 FAILED Result:
>     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>     [18142.991856] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0
>     80 00 00 08 00
>     [18142.991860] blk_update_request: I/O error, dev sda, sector 508032
>     [18142.991869] Buffer I/O error on dev dm-4, logical block 16, async
>     page read

This points at hardware level failure, regardless if the disk would hold
a btrfs or ext4 or whatever other kind of filesystem. The disk itself
cannot read data back when we ask for it.

> 4. 
> 
>     # btrfs restore -i -D /dev/mapper/foo--vg-root /dev/null
>     No valid Btrfs found on /dev/mapper/foo--vg-root
>     Could not open root, trying backup super
>     No valid Btrfs found on /dev/mapper/foo--vg-root
>     Could not open root, trying backup super
>     No valid Btrfs found on /dev/mapper/foo--vg-root
>     Could not open root, trying backup super
> 
> We are pretty sure that no unexpected electric cuts has been happened. 
> 
> At this point I don't know what information I should supply. 
> 


-- 
Hans van Kranenburg

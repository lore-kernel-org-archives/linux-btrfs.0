Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:38409 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdHaSuF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:50:05 -0400
Received: by mail-io0-f194.google.com with SMTP id m40so532693ioi.5
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 11:50:04 -0700 (PDT)
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2f83f856-031a-9c52-2443-1b8a530e51f8@gmail.com>
Date: Thu, 31 Aug 2017 14:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 13:27, Goffredo Baroncelli wrote:
> Hi All,
> 
> 
> I found a bug in mkfs.btrfs, when it is used the option '-r'. It seems that it is not visible the full disk.
> 
> $ uname -a
> Linux venice.bhome 4.12.8 #268 SMP Thu Aug 17 09:03:26 CEST 2017 x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.12
As far as I understand it, this is intended behavior.  Tools that offer 
equivalent options (genext2fs for example) are designed to generate 
pre-packaged system images that can then be resized to fit the target 
device's space.  As an example use case, I do full system image updates 
on some of my systems (that is, I keep per-system configuration to a 
minimum and replace the entire root filesystem when I update the system) 
I use this option to generate a base-image, which then gets 
automatically resized by my update scripts to fill the partition during 
the update process.

Overall, this could probably stand to be documented better though (I'll 
look at writing a patch to update the documentation to clarify this when 
I have some spare time over the weekend).
> 
> 
> --- First try without '-r' (/dev/sda is about 80GB)
> 
> $ sudo mkfs.btrfs  -f /dev/sda4
> btrfs-progs v4.12
> See http://btrfs.wiki.kernel.org for more information.
> 
> Label:              (null)
> UUID:               6f11971d-a945-4f33-8750-c16a7438a15d
> Node size:          16384
> Sector size:        4096
> Filesystem size:    83.73GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP               1.00GiB
>    System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1    83.73GiB  /dev/sda4
> 
> 
> All the disk (~80GB) is visible
> 
> 
> ---- Now try with '-r'
> 
> $ sudo mkfs.btrfs  -r /tmp/test/ -f /dev/sda4
> btrfs-progs v4.12
> See http://btrfs.wiki.kernel.org for more information.
> 
> Making image is completed.
> Label:              (null)
> UUID:               60ea1c38-e5b1-403d-8a25-1cac2258922d
> Node size:          16384
> Sector size:        4096
> Filesystem size:    52.00MiB
> Block group profiles:
>    Data:             single           29.19MiB
>    Metadata:         DUP               5.19MiB
>    System:           DUP               4.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1    52.00MiB  /dev/sda4
> 
> 
> where /tmp/test contains:
> $ ls -l /tmp/test/
> total 16392
> -rw-r--r-- 1 ghigo ghigo        5 Aug 31 18:26 123
> -rw-r--r-- 1 ghigo ghigo 16777216 Aug 31 18:26 123456
> -rw-r--r-- 1 ghigo ghigo        5 Aug 31 18:26 456
> 
> 
> BTRFS sees only 52MB instead of ~80GB.
> 
> Even if I try to mount and umount, the thing doesn't change.
> 
> $ sudo mount /dev/sda4 /mnt/other/
> $ echo 123 | sudo tee /mnt/other/9999
> 123
> $ sync
> $ sudo umount /mnt/other
> $ sudo mount /dev/sda4 /mnt/other/
> 
> Below an output of "btrfs fi us"
> 
> $ sudo btrfs fi us /mnt/other/
> Overall:
>      Device size:		  52.00MiB
>      Device allocated:		  52.00MiB
>      Device unallocated:		     0.00B
>      Device missing:		     0.00B
>      Used:			  16.16MiB
>      Free (estimated):		  13.19MiB	(min: 13.19MiB)
>      Data ratio:			      1.00
>      Metadata ratio:		      1.00
>      Global reserve:		  16.00MiB	(used: 0.00B)
> 
> Data,single: Size:29.19MiB, Used:16.00MiB
>     /dev/sda4	  29.19MiB
> 
> Metadata,single: Size:18.81MiB, Used:144.00KiB
>     /dev/sda4	  18.81MiB
> 
> System,single: Size:4.00MiB, Used:16.00KiB
>     /dev/sda4	   4.00MiB
> 
> Unallocated:
>     /dev/sda4	     0.00B
> 
> 
> 
> And a balance is impossible
> 
> $ sudo btrfs bala start --full-balance /mnt/other/
> ERROR: error during balancing '/mnt/other/': No space left on device
> There may be more info in syslog - try dmesg | tail
> 
> $ dmesg | tail
> [ 2034.684649] BTRFS: device fsid 60ea1c38-e5b1-403d-8a25-1cac2258922d devid 1 transid 7 /dev/sda4
> [ 2140.835629] BTRFS info (device sda4): disk space caching is enabled
> [ 2140.835632] BTRFS info (device sda4): has skinny extents
> [ 2140.835633] BTRFS info (device sda4): flagging fs with big metadata feature
> [ 2140.837381] BTRFS info (device sda4): creating UUID tree
> [ 2171.646349] BTRFS info (device sda4): disk space caching is enabled
> [ 2171.646362] BTRFS info (device sda4): has skinny extents
> [ 2273.696914] BTRFS info (device sda4): relocating block group 20512768 flags data
> [ 2273.721995] BTRFS info (device sda4): relocating block group 9633792 flags data
> [ 2273.746950] BTRFS info (device sda4): 6 enospc errors during balance
> 
> 
> I tried several btrfs-progs version ( I go back until v0.20-rc1: 2012!!!), and the behavior is the same: with '-r' the disk is not fully used. So I suppose that it is a kernel problem (IIRC the kernel should "complete" the mkfs at the first mount). Any idea ?
> 
> BR
> G.Baroncelli
> 


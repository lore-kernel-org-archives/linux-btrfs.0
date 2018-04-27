Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glass.birch.relay.mailchannels.net ([23.83.209.70]:40513 "EHLO
        glass.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757678AbeD0RvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 13:51:15 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 4ACF5280F62
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 17:41:26 +0000 (UTC)
Received: from lnxwebr13.cpt.wa.co.za (unknown [100.96.25.18])
        (Authenticated sender: webafrica)
        by relay.mailchannels.net (Postfix) with ESMTPA id 815D8280EC2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 17:41:25 +0000 (UTC)
Received: from [41.79.193.87] (port=33632 helo=dogmarch.sienna.invalid.co.za)
        by lnxwebr13.cpt.wa.co.za with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89_1)
        (envelope-from <brendan@swiftspirit.co.za>)
        id 1fC7N4-007mmE-Di
        for linux-btrfs@vger.kernel.org; Fri, 27 Apr 2018 19:41:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: NVMe SSD + compression - benchmarking
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
Date: Fri, 27 Apr 2018 19:41:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, all

I'm following up on the queries I had last week since I have installed 
the NVMe SSD into the PCI-e adapter. I'm having difficulty knowing 
whether or not I'm doing these benchmarks correctly.

As a first test, I put together a 4.7GB .tar containing mostly 
duplicated copies of the kernel source code (rather compressible). 
Writing this to the SSD I was seeing repeatable numbers - but noted that 
the new (supposedly faster) zstd compression is noticeably slower than 
all other methods. Perhaps this is partly due to lack of 
multi-threading? No matter, I did also notice a supposedly impossible 
stat when there is no compression, in that it seems to be faster than 
the PCI-E 2.0 bus theoretically can deliver:

compression type / write speed / read speed (in GBps)
zlib / 1.24 / 2.07
lzo / 1.17 / 2.04
zstd / 0.75 / 1.97
no / 1.42 / 2.79

The SSD is PCI-E 3.0 4-lane capable and is connected to a PCI-E 2.0 
16-lane slot. lspci -vv confirms it is using 4 lanes. This means it's 
peak throughput *should* be 2.0 GBps - but above you can see the average 
read benchmark is 2.79GBps. :-/

The crude timing script I've put together does the following:
- Format the SSD anew with btrfs and no custom settings
- wait 180 seconds for possible hardware TRIM to settle (possibly 
overkill since the SSD is new)
- Mount the fs using all defaults except for compression, which could be 
of zlib, lzo, zstd, or no
- sync
- Drop all caches
- Time the following
  - Copy the file to the test fs (source is a ramdisk)
  - sync
- Drop all caches
- Time the following
  - Copy back from the test fs to ramdisk
  - sync
- unmount

I can see how, with compression, it *can* be faster than 2 GBps (though 
it isn't). But I cannot see how having no compression could possibly be 
faster than 2 GBps. :-/

I can of course get more info if it'd help figure out this puzzle:

Kernel info:
Linux localhost.localdomain 4.16.3-1-vfio #1 SMP PREEMPT Sun Apr 22 
12:35:45 SAST 2018 x86_64 GNU/Linux
^ Close to the regular ArchLinux kernel - but with vfio, and compiled 
with -arch=native. See https://aur.archlinux.org/pkgbase/linux-vfio/

CPU model:
model name    : Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz

Motherboard model:
Product Name: Z68MA-G45 (MS-7676)

lspci output for the slot:
02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe 
SSD Controller SM961/PM961
^ The disk id sans serial is Samsung_SSD_960_EVO_1TB

dmidecode output for the slot:
Handle 0x001E, DMI type 9, 17 bytes
System Slot Information
         Designation: J8B4
         Type: x16 PCI Express
         Current Usage: In Use
         Length: Long
         ID: 4
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:02:01.1

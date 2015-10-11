Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36492 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbbJKSnv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:43:51 -0400
Received: by vkgc187 with SMTP id c187so12643717vkg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 11:43:50 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Oct 2015 07:43:50 +1300
Message-ID: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
Subject: BTRFS with 8TB SMR drives
From: Warren Hughes <wsh@warrenhughes.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys, just added a new Seagate Archive 8TB drive to my BTRFS volume
and I'm getting a tonne of errors when balancing or scrubbing.

A short smartctl test reports fine, running a long one now. Will also
run seatools from a bootable DOS USB while at work today.

Running latest firmware on my 9240-8i which explicitly supports this drive.

I'm finding it very hard to tell if SMR drives are OK with BTRFS
currently - anyone chime in?

Thanks, Warren

[wsh@cloud storcli]$ uname -a
Linux cloud.warrenhughes.net 4.1.10-2-lts #1 SMP Wed Oct 7 21:57:44
CEST 2015 x86_64 GNU/Linux

[wsh@cloud storcli]$ sudo btrfs version
btrfs-progs v4.2.1


[wsh@cloud ~]$ sudo btrfs scrub status /mnt/media
scrub status for 643c3145-8371-4011-8c34-20240e1bbaff
        scrub started at Sun Oct 11 20:37:38 2015 and was aborted after 10:35:47
        total bytes scrubbed: 8.15TiB with 104218141 errors
        error details: read=98736175 csum=5481966
        corrected errors: 5484382, uncorrectable errors: 98733759,
unverified errors: 0

[/dev/sdo].write_io_errs   100154203
[/dev/sdo].read_io_errs    98735251
[/dev/sdo].flush_io_errs   634
[/dev/sdo].corruption_errs 5481966
[/dev/sdo].generation_errs 0

[wsh@cloud ~]$ sudo smartctl -H -T permissive /dev/sdo
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.1.10-2-lts] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

Short INQUIRY response, skip product id
=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

[wsh@cloud storcli]$ sudo ./storcli64 /c0 show
Product Name = LSI MegaRAID SAS 9240-8i
Serial Number = P522221010
SAS Address =  500605b004e9d030
PCI Address = 00:03:00:00
System Time = 10/12/2015 07:38:22
Mfg. Date = 03/17/10
Controller Time = 10/12/2015 07:38:20
FW Package Build = 20.13.1-0240
BIOS Version = 4.38.02.2_4.16.08.00_0x06060A05
FW Version = 2.130.404-4659
Driver Name = megaraid_sas
Driver Version = 06.806.08.00-rc1
Vendor Id = 0x1000
Device Id = 0x73
SubVendor Id = 0x1000
SubDevice Id = 0x9240
Host Interface = PCI-E
Device Interface = SAS-6G
Bus Number = 3
Device Number = 0
Function Number = 0
Physical Drives = 7

PD LIST :
=======

---------------------------------------------------------------------------
EID:Slt DID State DG     Size Intf Med SED PI SeSz Model                Sp
---------------------------------------------------------------------------
64:1      4 JBOD  -  1.363 TB SATA HDD N   N  512B WDC WD15EADS-00P8B0  U
64:2      0 JBOD  -  2.728 TB SATA HDD N   N  512B WDC WD30EFRX-68AX9N0 U
64:3      7 JBOD  -  2.728 TB SATA HDD N   N  512B ST3000DM001-1CH166   U
64:4      6 JBOD  -  2.728 TB SATA HDD N   N  512B WDC WD30EFRX-68AX9N0 U
64:5      5 JBOD  -  2.728 TB SATA HDD N   N  512B WDC WD30EFRX-68EUZN0 U
64:6      3 JBOD  -  2.728 TB SATA HDD N   N  512B WDC WD30EFRX-68AX9N0 U
64:7      2 JBOD  -  2.728 TB SATA HDD N   N  512B WDC WD30EFRX-68AX9N0 U
---------------------------------------------------------------------------

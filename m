Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:39173 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeELIOD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 May 2018 04:14:03 -0400
Received: by mail-oi0-f45.google.com with SMTP id n65-v6so6674518oig.6
        for <linux-btrfs@vger.kernel.org>; Sat, 12 May 2018 01:14:02 -0700 (PDT)
MIME-Version: 1.0
From: Adam Bahe <adambahe@gmail.com>
Date: Sat, 12 May 2018 03:13:21 -0500
Message-ID: <CACzgC9g=gYnEEd_o2RqUpz4Yh1+YrAcfCCmcnqc8SmmzF878AQ@mail.gmail.com>
Subject: replace drive with write_io_errs?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I have a drive that has been in my btrfs array for about 6 months now.
It was purchased new. Its an IBM-ESXS SAS drive rebranded from an HGST
HUH721010AL4200. Here is the following stats, it passed a long
smartctl test. But I'm not sure what to make of it.

[/dev/sdi].write_io_errs    1823
[/dev/sdi].read_io_errs     0
[/dev/sdi].flush_io_errs    0
[/dev/sdi].corruption_errs  0
[/dev/sdi].generation_errs  0

=== START OF INFORMATION SECTION ===
Vendor:               IBM-ESXS
Product:              HUH721010AL4200
Revision:             J6R2
User Capacity:        9,931,038,130,176 bytes [9.93 TB]
Logical block size:   4096 bytes
Formatted with type 2 protection
Logical block provisioning type unreported, LBPME=0, LBPRZ=0
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca266a405e4
Serial number:        *YOINK*
Device type:          disk
Transport protocol:   SAS
Local Time is:        Sat May 12 03:06:35 2018 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     52 C
Drive Trip Temperature:        65 C

Manufactured in week 33 of year 2017
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  28
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  170
Elements in grown defect list: 0

Vendor (Seagate) cache information
  Blocks sent to initiator = 1848304782540800

Error counter log:
           Errors Corrected by           Total   Correction
Gigabytes    Total
               ECC          rereads/    errors   algorithm
processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9
bytes]  errors
read:          0        0         0         0    1096283
14317.360           0
write:         0        0         0         0       2906
27801.489           0
verify:        0        0         0         0      13027
0.000           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime
LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background long   Completed                   -    2466
      - [-   -    -]
# 2  Background short  Completed                   -    2448
      - [-   -    -]
Long (extended) Self Test duration: 65535 seconds [1092.2 minutes]


I can't RMA the drive as I have no idea how or where to RMA an IBM
branded HGST drive. So if on the off chance someone here is reading
this who can also point me in the right direction, let me know where
to RMA and IBM standalone drive with no FRU.

But is this drive healthy or should I have it replaced? What is the
extent of a write_io_err? Are they somewhat common or a sign of a bad
drive? A scrub returned no errors.

Also what about the correction algorithm invocations? All of my IBM
drives seem to have those. Whereas all of my other drives do not. I
was curious about that too, if anyone knows. Thanks!

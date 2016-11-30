Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:63087 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758835AbcK3VDa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 16:03:30 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Metadata balance fails ENOSPC
Message-ID: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
Date: Wed, 30 Nov 2016 22:03:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

# btrfs balance start -v -dusage=0 -musage=1 /ssddisk/
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=0
  METADATA (flags 0x2): balancing, usage=1
  SYSTEM (flags 0x2): balancing, usage=1
ERROR: error during balancing '/ssddisk/': No space left on device
There may be more info in syslog - try dmesg | tail

# btrfs filesystem show /ssddisk/
Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
        Total devices 1 FS bytes used 305.67GiB
        devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1

# btrfs filesystem usage /ssddisk/
Overall:
    Device size:                 500.00GiB
    Device allocated:            500.00GiB
    Device unallocated:            1.05MiB
    Device missing:                  0.00B
    Used:                        305.69GiB
    Free (estimated):            185.78GiB      (min: 185.78GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 608.00KiB)

Data,single: Size:483.97GiB, Used:298.18GiB
   /dev/vdb1     483.97GiB

Metadata,single: Size:16.00GiB, Used:7.51GiB
   /dev/vdb1      16.00GiB

System,single: Size:32.00MiB, Used:144.00KiB
   /dev/vdb1      32.00MiB

Unallocated:
   /dev/vdb1       1.05MiB

How can i make it balancing again?

Greets,
Stefan

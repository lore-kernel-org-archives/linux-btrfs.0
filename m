Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:46263 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755570AbeFZBFj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 21:05:39 -0400
Received: by mail-lf0-f46.google.com with SMTP id v17-v6so8925593lfe.13
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 18:05:38 -0700 (PDT)
MIME-Version: 1.0
From: Sterling Windmill <swindmill@gmail.com>
Date: Mon, 25 Jun 2018 21:05:24 -0400
Message-ID: <CAMOu_z3dhfSVPKFGiZYfDzQx-C-TXRqJ-HJDTm1-DENVYhCwXA@mail.gmail.com>
Subject: btrfs raid10 performance
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am running a single btrfs RAID10 volume of eight LUKS devices, each
using a 2TB SATA hard drive as a backing store. The SATA drives are a
mixture of Seagate and Western Digital drives, some with RPMs ranging
from 5400 to 7200. Each seems to individually performance test where I
would expect for drives of this caliber. They are all attached to an
LSI PCIe SAS controller and configured in JBOD.

I have a relatively beefy quad core Xeon CPU that supports AES-NI and
don't think LUKS is my bottleneck.

Here's some info from the resulting filesystem:

  btrfs fi df /storage
  Data, RAID10: total=6.30TiB, used=6.29TiB
  System, RAID10: total=8.00MiB, used=560.00KiB
  Metadata, RAID10: total=9.00GiB, used=7.64GiB
  GlobalReserve, single: total=512.00MiB, used=0.00B

In general I see good performance, especially read performance which
is enough to regularly saturate my gigabit network when copying files
from this host via samba. Reads are definitely taking advantage of the
multiple copies of data available and spreading the load among all
drives.

Writes aren't quite as rosy, however.

When writing files using dd like in this example:

  dd if=/dev/zero of=tempfile bs=1M count=10240 conv=fdatasync,notrun
c status=progress

And running a command like:

  iostat -m 1

to monitor disk I/O, writes seem to only focus on one of the eight
disks at a time, moving from one drive to the next. This results in a
sustained 55-90 MB/sec throughput depending on which disk is being
written to (remember, some have faster spindle speed than others).

Am I wrong to expect btrfs' RAID10 mode to write to multiple disks
simultaneously and to break larger writes into smaller stripes across
my four pairs of disks?

I had trouble identifying whether btrfs RAID10 is writing (64K?)
stripes or (1GB?) blocks to disk in this mode. The latter might make
more sense based upon what I'm seeing?

Anything else I should be trying to narrow down the bottleneck?

Thanks!

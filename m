Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s3.hotmail.com ([65.55.116.14]:49351 "EHLO
	BLU004-OMC1S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbbJPOfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 10:35:06 -0400
Message-ID: <BLU436-SMTP138EAB426D63216853C17A9A93D0@phx.gbl>
MIME-Version: 1.0
Date: Fri, 16 Oct 2015 16:35:01 +0200
Subject: wrong message for succesful btrfs fi resize
From: Henk Slager <hslager@hotmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While resizing a filesystem a multiple times in a row (even when
unmount,mount in between), the output of btrfs tools mentions error,
no space left on device, while dmesg mentions the new size and the
action was in fact succesful (no errors so far).

It was quite confusing the first time I found this out, but was not
sure if there was something else wrong maybe. Now, on another PC I see
the same effect.

Additional resize commands (same size or smaller) have not resulted in
a corrupted filesystem AFAIK.
Some info w.r.t. the fault:

kernel 4.3.0-rc4
btrfs-progs v4.2.2+20151005

fdisk info:
/dev/sdf: 64.0 GB, 64023257088 bytes, 125045424 sectors
/dev/sdf1   *        2048   115343359    57670656   83  Linux

asus:/tmp # btrfs fi us /tmp/tumbleweed
Overall:
    Device size:                  55.00GiB
    Device allocated:             55.00GiB
    Device unallocated:            1.00MiB
    Device missing:                  0.00B
    Used:                         25.08GiB
    Free (estimated):             28.78GiB      (min: 28.78GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              320.00MiB      (used: 0.00B)

Data,single: Size:52.97GiB, Used:24.19GiB
   /dev/sdf1      52.97GiB

Metadata,single: Size:2.00GiB, Used:916.77MiB
   /dev/sdf1       2.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sdf1      32.00MiB

Unallocated:
   /dev/sdf1       1.00MiB

asus:/tmp # btrfs fi resize 29G /tmp/tumbleweed
Resize '/tmp/tumbleweed' of '29G'
asus:/tmp # btrfs fi resize 28G /tmp/tumbleweed
Resize '/tmp/tumbleweed' of '28G'
ERROR: unable to resize 'tw' - No space left on device

[cut]
[ 5459.020806] BTRFS info (device sdf1): disk space caching is enabled
[ 5459.020808] BTRFS: has skinny extents
[ 5459.035919] BTRFS: detected SSD devices, enabling SSD mode
[ 5459.036735] BTRFS: checking UUID tree
[ 7606.071864] BTRFS: new size for /dev/sdf1 is 31138512896
[ 7606.072860] BTRFS info (device sdf1): relocating block group
62373494784 flags 4
[ 7618.987497] BTRFS info (device sdf1): relocating block group
51032096768 flags 1
[ 7621.147040] BTRFS info (device sdf1): found 7911 extents
[ 7629.754796] BTRFS info (device sdf1): found 7911 extents
[ 7629.842370] BTRFS info (device sdf1): relocating block group
49958354944 flags 1
[ 7632.705118] BTRFS info (device sdf1): found 13248 extents
[ 7642.427493] BTRFS info (device sdf1): found 13248 extents
[ 7642.524090] BTRFS info (device sdf1): relocating block group
71030538240 flags 1
[ 7642.621854] BTRFS info (device sdf1): found 1 extents
[ 7642.729459] BTRFS info (device sdf1): found 1 extents
[ 7642.793593] BTRFS info (device sdf1): relocating block group
48884613120 flags 1
[ 7645.079250] BTRFS info (device sdf1): found 7628 extents
[ 7654.246605] BTRFS info (device sdf1): found 7628 extents
[ 7654.327323] BTRFS info (device sdf1): relocating block group
47274000384 flags 1
[ 7656.422451] BTRFS info (device sdf1): found 9595 extents
[ 7663.991900] BTRFS info (device sdf1): found 9592 extents
[ 7664.091894] BTRFS info (device sdf1): relocating block group
46200258560 flags 1
[ 7666.442398] BTRFS info (device sdf1): found 10892 extents
[ 7676.297287] BTRFS info (device sdf1): found 10892 extents
[ 7676.393986] BTRFS info (device sdf1): relocating block group
62373494784 flags 4
[ 7687.308804] BTRFS info (device sdf1): found 43036 extents
[ 7710.564267] BTRFS: new size for /dev/sdf1 is 30064771072
[cut]

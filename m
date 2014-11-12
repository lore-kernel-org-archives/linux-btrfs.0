Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:54080
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753544AbaKLVVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 16:21:21 -0500
From: "Kline, Matthew" <matthew.kline@flukenetworks.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs balance fails with no space errors (despite having plenty)
Date: Wed, 12 Nov 2014 18:48:47 +0000
Message-ID: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Yesterday I converted my ext4 root and home partitions on my home machine
to btrfs using btrfs-convert. After confirming that everything went well,
I followed the wiki instructions to nuke the 'ext2_saved" subvolume,
then defraggad and rebalanced. Everything went according to plan on my root
partition, but my home partition claimed to have run out of space
when rebalancing.

I did some digging and tried the following to resolve the problem,
but to no avail. So far I have:

- Made sure I deleted the subvolume (a common cause of this problem).
  `sudo btrfs subvolume list -a /home` exits with no output.

- Made sure I defragged the newly converted btrfs partition before attempting
  to rebalance it.

- Made sure that I actually have space on the partition.
  It is only about 60% full - see sdb1 below:

  ~ % sudo btrfs fi show
  Label: none  uuid: 3a154348-9bd4-4c3f-aaf8-e9446d3797db
      Total devices 1 FS bytes used 9.49GiB
      devid    1 size 87.47GiB used 11.03GiB path /dev/sda3

  Label: none  uuid: cc90ee50-bbda-46d6-a7e6-fe1c8578d75b
      Total devices 1 FS bytes used 124.98GiB
      devid    1 size 200.00GiB used 127.03GiB path /dev/sdb1

- Made sure I have metadata space (as suggested on the problem FAQ):

  ~ % sudo btrfs fi df /home
  Data, single: total=126.00GiB, used=124.58GiB
  System, single: total=32.00MiB, used=20.00KiB
  Metadata, single: total=1.00GiB, used=404.27MiB
  GlobalReserve, single: total=136.00MiB, used=0.00B

- Ran partial rebalances using the `-dusage` flag
  (as suggested on the problem FAQ),
  which successfully balanced a handful of blocks.

- Checked the system log - nothing interesting comes up.
  btrfs happily chugs along with "found xxx extents" and
  "relocating block group xxxxx flags 1" messages before unceremoniously
  ending with "7 enospc errors during balance".

In spite of all of this, a full rebalance still fails when it's about 95% done.
I'm at a complete loss as to what could be causing it - I know that it's not
completely necessary (especially with a single drive),
and `btrfs scrub` finds no errors with the file system,
but the wiki gives the impression that it's a good idea after you convert from
ext.

Is there something I'm missing?

Best,
Matt Kline

Other obligatory info: I'm on Arch Linux using btrfs 3.17.1. uname -a is

Linux kline-arch 3.17.2-1-ARCH #1 SMP PREEMPT Thu Oct 30 20:49:39 CET 2014
x86_64 GNU/Linux

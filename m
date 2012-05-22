Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:56234 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217Ab2EVKxv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 06:53:51 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id D353DB29
	for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 12:53:49 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] Btrfs: add IO error device stats
Date: Tue, 22 May 2012 12:53:46 +0200
Message-Id: <cover.1337682115.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changes v1-v2:
- Remove restriction that BTRFS_IOC_GET_DEVICE_STATS is a privileged
  operation
- Cast u64 to unsigned long long for printf()

Changes v2-v3:
- Rebased on Chris' current master

Changes v3-v4:
- Add padding at end of ioctl structure

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

An ioctl interface is added to get the device statistic counters.
A second ioctl is added to atomically get and reset these counters.

The device statistics are written into the device tree with each
transaction commit. Only modified statistics are written.
When a filesystem is mounted, the device statistics for each involved
device are read from the device tree and used to initialize the
counters.

A patch for the btrfs-progs world will also be sent.

Stefan Behrens (3):
  Btrfs: add device counters for detected IO and checksum errors
  Btrfs: add ioctl to get and reset the device stats
  Btrfs: read device stats on mount, write modified ones during commit

 fs/btrfs/ctree.h       |   51 ++++++++
 fs/btrfs/disk-io.c     |   25 +++-
 fs/btrfs/extent_io.c   |   27 +++-
 fs/btrfs/ioctl.c       |   26 ++++
 fs/btrfs/ioctl.h       |   28 ++++
 fs/btrfs/print-tree.c  |    3 +
 fs/btrfs/scrub.c       |   72 ++++++++---
 fs/btrfs/transaction.c |    4 +
 fs/btrfs/volumes.c     |  335 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h     |   43 +++++++
 10 files changed, 589 insertions(+), 25 deletions(-)

-- 
1.7.10.2


Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0A345731
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859748; cv=none; b=DfHV2ragkHg7cYsF/nP4PCsftJ4EIupIShxaZRnFEFhHS6kfB7Itu2WLcmYB21kqRmrZA5SBr2WyTpQR5p27/BZf539+2EZAZCYz3DSQqsAgV1NLKC74nrnUGrcGqrEaEKdAMVYxWcso3F8HSkqYRK8PdhYyXUMhDgqa6IBqSY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859748; c=relaxed/simple;
	bh=18fPPA7us47o9sxlbu+ONJMA0En3qpIvYnLLq8G0z0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zru4RkdXjq/Kmg2jYVS7XTZYxYdjl4fpLoNw/wIRSVG4oAv1lg+uarnxMIwhUvWEC4d3HGSk6QfPjHdIpsAiP7HV2Xn+GrTQNSssV9nZdYCtnWfSEWVLRwWdLc1Hrt6gKu6c96UKn5c12A9g2iV0RQNVcT8L9RS6AFPMzKrqOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iXwpGx7A; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iXwpGx7A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859747; x=1813395747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=18fPPA7us47o9sxlbu+ONJMA0En3qpIvYnLLq8G0z0k=;
  b=iXwpGx7AVHgdrkdMF4ALBvfUsvs7qVybOm4iBrSKL8/6AA8Vjr/arQcN
   ulvOUj65viTs7UUYmQSR9rDhz2Ze0rt4aFiCSPbRs+w2daI/J+vtcybOR
   LO2+6sn0s18cAW8dkUBiC9Nm6gaT2eNWoSbNapIOaHQNKco+vPCc4LpHt
   jhlqSTuE1W2sFZgF3M+bDwdr2/bgvNBLqPz9m/WdG3zzLSeCaVI4RHNlr
   EO5gohqzgOndXkb/NEIf+uBr29vVVqx7ecQav+k7YLe0pi4pBKtQRxeyq
   bxu5V0jXiwYolBNFsCSdq6aF9gHqFNHxR2jLavjiAI23ZBbrHfWauajCJ
   Q==;
X-CSE-ConnectionGUID: MIJ8ZYF+Q/u9w8kGtcjgMA==
X-CSE-MsgGUID: cuuXGHo3TlmHY8PPrYwVvQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951268"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: +2TbVxrSThKSKZrar3M9Bg==
X-CSE-MsgGUID: u62SpM+eRj6sTEO7yV/0rg==
IronPort-SDR: 6a350596_Zoti+CUzwDiYF9zpbYCo8g26F0LLJ0cC8QdYeOktqKVEVCi
 9ZYKLs4xoAcTtXp4a9F3DheLx56mN8KueRK1HvQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:14 -0700
X-CSE-ConnectionGUID: ZOS7nEU4TFS2U6aFAusqVA==
X-CSE-MsgGUID: T2dEg41QQ92+qpfq4dGTBg==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:13 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned + non-zoned)
Date: Fri, 19 Jun 2026 11:01:55 +0200
Message-ID: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This purely RFC series teaches btrfs to run RAID5/6 on top of the RAID
stripe-tree (RST), both on zoned devices (ZNS / SMR, the primary target)
and on regular non-zoned devices. Write-hole-free RAID5 for ordinary
disks is an explicit goal here, not just a side effect of the zoned
work.

It is send as an early feedback/design review and not intended to be
used, therefore I deliberately did not include the btrfs-progs part of
it.

Motivation
==========

Classic btrfs RAID56 derives the data/parity device and offset for each
stripe from a fixed geometric rotation and overwrites parity in place.
That model has two problems:

 1) It cannot work on zoned devices, which forbid in-place overwrite
 2) In-place parity update is the source of the RAID56 write hole

The RAID stripe-tree already maps a logical address to a per-device
physical address for each stripe of a profile. Building RAID5 on the RST
means every stripe's location is recorded rather than computed, so data
and parity can land anywhere (e.g. wherever a zone-append put them) and
stripes are written copy-on-write. That removes the write hole and makes
RAID5 expressible on zoned devices.

How it works
============

Write:
------
A RAID5 write does not assemble a full stripe up front. Each data bbio
folds its column into a shared, zeroed per-stripe parity buffer held by
a struct btrfs_stripe_set (keyed by full_stripe_logical), accounting the
folded bytes. The parity is submitted by btrfs_stripe_set_finalize():

- eagerly, once all nr_data columns are folded (a full stripe, even if
  it was split across two ordered extents); or
- for a partial tail (a stripe that never fills), from the
  ordered-extent completion in btrfs_rst_raid56_finish_ordered(), using
  i_size to decide it is a genuine tail.

The actual zone-append physical for both data and parity is recorded into the
RST from the bio completion, so reads resolve by lookup and the append may
land anywhere. btrfs_stripe_set_calc_parity() dispatches on the parity count
and currently has a RAID6 (or higher order parity) placeholder.

Read:
-----
btrfs_rst_raid56_read() reads the target data column directly when its device
is present, and reconstructs it from the other columns + parity (xor_gen)
only when the target column's device is missing or on a repair retry. RAID56
lookups trust the recorded (devid, physical) and resolve the device from the
recorded devid rather than from a geometric rotation: a zoned RST RAID5 data
column is a contiguous zone-append run, so a single data extent can span what
the geometric model treats as multiple rotated rows, and geometry would
resolve a read to the wrong device.

Delete / partial free:
----------------------
btrfs_delete_raid_extent() removes a RAID56 stripe's data+parity only for a
full stripe entirely covered by the freed range; a partial free retains the
items (so survivors still reconstruct), and the leftovers are reclaimed when
the block-group is removed.

Testing
=======

Verified on QEMU NVMe ZNS, zloop and emulated SMR (SCSI ZBC), and on
regular non-zoned loop devices:

 1) full-stripe writes (128K..32M) and sub-stripe writes round-trip cache-cold
    and across umount/remount
 2) in-kernel sanity tests pass
 3) on-disk parity content is verified (a half-stripe write's recorded parity
    equals the data column)
 4) non-zoned RAID5-RST: mkfs/mount, cache-cold read, overwrite, single-device
    corrupt + degraded reconstruct, btrfs check

Limitations / open work
=======================

 1) Partial stripe (over)write is different from my original idea to pad
    to BTRFS_STRIPE_LEN with 0 bytes and then compute parity. This
    totally broke space accounting (obviously afterwards *facepalm*)
 2) RAID6 is not implemented; the parity computation has a single-parity
    (RAID5) implementation and a RAID6 placeholder.
 3) Reconstruct soundness for non-stripe-aligned, row-spanning data
    extents is not yet fully verified end to end (degraded reconstruct
    works for single-extent stripes).
 4) Reflink handling is not very well tested yet
 5) No NOCOW testing and I'm leaning to make a global no-NOCOW for RST 
 6) Full fstests run still pending
 7) Testing, testing, testing

Johannes Thumshirn (15):
  btrfs: factor out filling a single raid_stride
  btrfs: pass the key type to btrfs_insert_one_raid_extent()
  btrfs: introduce BTRFS_RAID_STRIPE_PARITY_KEY
  btrfs: zoned: align max_zone_append_size to the stripe length for RST
  btrfs: load raid56 block-groups
  btrfs: allow RAID56 for data block groups with stripe-tree
  btrfs: don't call into regular raid56 if we're using RST
  btrfs: implement RAID stripe-tree RAID5 writes
  btrfs: implement basic RAID stripe-tree RAID5 read
  btrfs: fix RAID stripe-tree lookup across leaf boundaries
  btrfs: tests: add a RAID5 RAID-stripe-tree read test
  btrfs: compute RAID stripe-tree RAID5 parity for sub-stripe writes
  btrfs: implement delete of parity stripes
  btrfs: tests: add RAID5 RAID-stripe-tree create/update/delete tests
  btrfs: search commit root when relocating on RST

 fs/btrfs/bio.c                          | 100 ++-
 fs/btrfs/block-group.c                  |  15 +
 fs/btrfs/disk-io.c                      |  16 +
 fs/btrfs/fs.h                           |   3 +
 fs/btrfs/inode.c                        |   7 +
 fs/btrfs/print-tree.c                   |   2 +
 fs/btrfs/raid-stripe-tree.c             | 805 +++++++++++++++++++++++-
 fs/btrfs/raid-stripe-tree.h             |  22 +-
 fs/btrfs/super.c                        |   9 +
 fs/btrfs/tests/raid-stripe-tree-tests.c | 344 +++++++++-
 fs/btrfs/volumes.c                      |  13 +
 fs/btrfs/zoned.c                        |  76 +++
 include/trace/events/btrfs.h            |  24 +
 include/uapi/linux/btrfs_tree.h         |   1 +
 14 files changed, 1395 insertions(+), 42 deletions(-)

-- 
2.54.0


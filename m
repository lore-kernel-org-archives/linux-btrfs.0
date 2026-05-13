Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F912C326C
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675795; cv=none; b=lh9nJjtv4zxKanbCeUOXY6cUcUbh5C1UWIYN0dnPYJaSxhfVw0458t3shrU+lBWpW3AWOJj/fsgaOx4hXDJO75z5bpjugBSnsazEc3BcjmpvoXz4vBRN+h1Yvok+U8muErZ3JdVLU6Yg5oZj7T/2ndQ2tmiywaJ1DhtmYVhmKS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675795; c=relaxed/simple;
	bh=eTgAq3Pd7HA4ZGiycWyZMhfN2diXrISLaSnTs4VXORM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qJCf5/EU487Fu+e6SVzZpqiVHkW98lyMhgCFkacRNYlzAQuxO/262XNraH3piJz4TY443UCcFoKzIR3iK0GpgfeRHQo5QLTGexCiyn3PePzUFfAI9tWynnaRhoE8FSeGTzN7k1oXBzOZ/TRC2c5Oal91JSznIQYXB6hmj1ZXSLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jdnC66zl; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jdnC66zl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675794; x=1810211794;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eTgAq3Pd7HA4ZGiycWyZMhfN2diXrISLaSnTs4VXORM=;
  b=jdnC66zlpOG5dM4nj/psyXtewd7kT1mpGj/2kPXKyDhvAPxDP8KFX438
   P5gyLYUjNC9uLDxk5oiVZ94FkMuY2hcvGdX642MQg6RQgUiCutAf6cKZC
   w1tB/J4WcnMH9gEiQ/CRzNb0M61x5nAosn3RyUIldWkKFKt6De3xZELDq
   zd3AS/dU7iAAxuVrlW+cjUYR8hp4oYXrilkN5Kv7Qk6gXk1KABIHiiZzU
   V5qeR16h/2wM+W3NwOLSUoXZCwgWqQQJ+Axo8MN0OJVoD/gsvFi0Sbjw3
   eAkEDsv96saAhs3kL2cnlSEW6jIftMLvNSyQCUGxqK40dNrPDDNtGprob
   Q==;
X-CSE-ConnectionGUID: xX7ejY8/Q6Ge+o8+kUZN5Q==
X-CSE-MsgGUID: CuoLcTe7Tqi9qMDLQdm1EA==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869032"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:25 +0800
X-CSE-ConnectionGUID: FH3V8U0NT8en9XPvVTFpTA==
X-CSE-MsgGUID: mMIjYJ/AQqagpSC25SO7EQ==
IronPort-SDR: 6a046ff3_jp8X0Uf4/hGMs7CRvwLzPKXPNiOL8SNLQF/OQgzQqNH9rpV
 ktGkw0j/Y17W+VKBS5TO67/fz+GC0S7TdSLzkbQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:34:58 -0700
X-CSE-ConnectionGUID: f9PGjuRQRkqQZHggX20yqw==
X-CSE-MsgGUID: u1yi889rQICblxbQ4jAuVA==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:34:57 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/7] btrfs: fixes around generic/747 on zoned filesystems
Date: Wed, 13 May 2026 14:34:38 +0200
Message-ID: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes premature ENOSPC errors and starvation issues on zoned BTRFS
filesystems when running xfstest generic/747, which tests garbage collection
on zoned block devices using direct and buffered I/O.

The investigation revealed two distinct issues:

1. Async reclaim starvation: On zoned filesystems, the flush state machine
   only executes RECLAIM_ZONES and RESET_ZONES in later flush states
   (FLUSH_DELALLOC and beyond). By the time these states are reached,
   ticket waiters can starvation waiting for space that can only be freed
   by zone reset. The fix adds RECLAIM_ZONES and RESET_ZONES to the first
   async reclaim loop (FLUSH_ALLOC) specifically for zoned filesystems,
   ensuring zone reset happens early enough to free space for pending
   allocation tickets.

2. Inaccurate statfs reporting: On zoned filesystems, space in block
   groups that has been freed but not yet reset is tracked in
   bytes_zone_unusable. This space cannot be used for new allocations
   until zone reclaim resets the zones, but it was being reported as
   available space in statfs. This caused statfs to over-report free
   space, leading to ENOSPC errors when applications tried to allocate
   based on the reported free space. The fix subtracts bytes_zone_unusable
   from total_free_data in the statfs calculation for zoned filesystems,
   with proper RAID factor multiplication for unit conversion.

Additionally, the series fixes a bug in data relocation block group selection
where the first block group was incorrectly skipped, and adds a new flush
state (BTRFS_RESERVE_FLUSH_DATA_RELOCATION) to use priority reclaim for
zoned data relocation operations.


Johannes Thumshirn (7):
  btrfs: zoned: document RECLAIM_ZONES flush state
  btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
  btrfs: zoned: always set data_relocation_bg
  btrfs: zoned: don't account data relocation space-info in statfs free
    space
  btrfs: zoned: subtract zone_unusable space in statfs
  btrfs: zoned: fix deadlock waiting for ticket during data relocation
  btrfs: zoned: add RECLAIM_ZONES and RESET_ZONES to first async reclaim
    loop

 fs/btrfs/delalloc-space.c    |  2 ++
 fs/btrfs/space-info.c        | 18 ++++++++++++++++++
 fs/btrfs/space-info.h        | 11 +++++++++++
 fs/btrfs/super.c             |  5 ++++-
 fs/btrfs/zoned.c             |  6 +++---
 include/trace/events/btrfs.h |  1 +
 6 files changed, 39 insertions(+), 4 deletions(-)

-- 
2.54.0


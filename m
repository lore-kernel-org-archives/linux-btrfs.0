Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7B23B8955
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779440592; cv=none; b=hPCfD3k3dAAaDHuHjIWQZ+f5q3s0EaDBKoRVcMtD1dViVY02fza1dExIj0YJQS4TmwgaP4DFNx5LbYzy2gAJb2UCzJpyFnBtBl9YFtikl3ADDQcXitcjh618HFt/QW3Li/yVsQsLhwA3mnOAyNbxe4T3RdukL3QehwrRKEFASvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779440592; c=relaxed/simple;
	bh=aCRQ71zdUFfliz2LYagsT1soorO5vWfAR/5Nan9OBlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wu3utEz2fEpezWXVbU53w9YCZHIJEuqHwup4NYU/dry1DgcJiywKUvcMJlu0B/StppZ7ya08Y3Secm622tLPGE1POR0HvDYAISJVw9COt43IRiW/OoCji82tdjCnketrfobR/lH38+2BifnNUYzfpQhihGBAau7r6GeaVHXJnbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mCusMM3c; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mCusMM3c"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779440592; x=1810976592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aCRQ71zdUFfliz2LYagsT1soorO5vWfAR/5Nan9OBlk=;
  b=mCusMM3chzzDlydSFgr6qY8IsYK14SM/BXgvIk3GbbwNZNgwpgxQNoLQ
   p6+2FT55m8gTwe+fi19PsgXlJvPgAtykRhWDxzMVZ2GgJiN2NSblG0NdZ
   5r8u75ZXeCtZPNw6yl/TMmHiCIUPYupqWIO8o+Jlem9gsOglRbbEQiYUU
   idfUw0KrSRi6I/NtOzjJnVaqj9nd8ahcQY1zVXTLvHsahCF7Ah2hb1NMn
   LWLrz5/peesmm5ebkggxGtlGwgQuIzqDcJJPsFaH1Wglf1SPHnKIyTYXp
   J9K1qdpo3YAc35khSTtmca48kXRyvIk8k0Dq46b+dVuYPQRw5c5IudDDp
   w==;
X-CSE-ConnectionGUID: X6ISyUH4QruZOVtGCb0Kxw==
X-CSE-MsgGUID: 2q/pAa/PTaK8NOTPkLKCBQ==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="147475589"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:03:05 +0800
X-CSE-ConnectionGUID: 0fqWJt/SR4OaPkHJAzE3Lg==
X-CSE-MsgGUID: BJP0xcWYSmi4rDf0T9mwsA==
IronPort-SDR: 6a101bbf_+jxIXDoj5vRuMQNYyXbpFHTyKnpZ5bNKcmFiO0VgVFGJfPd
 feMC+SB4Mv4K4Icr208NOyrMe0d6mrkqlEh+JiQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:02:53 -0700
X-CSE-ConnectionGUID: dB3c3WNJS7e6JHY1VBa5AA==
X-CSE-MsgGUID: n34dynVlTOW7FuQBhnwHww==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:02:51 -0700
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
Subject: [PATCH v3 0/5] btrfs: zoned: fix deadlock and space reporting issues for zoned filesystems
Date: Fri, 22 May 2026 11:02:42 +0200
Message-ID: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes premature ENOSPC errors and deadlock issues on zoned BTRFS
filesystems when running xfstest generic/747, which tests garbage collection
on zoned block devices using direct and buffered I/O.

There where two issues revealed in the investigation:

Async reclaim deadlock: On zoned filesystems, the flush state machine
only executes RECLAIM_ZONES and RESET_ZONES in later flush states
(FLUSH_DELALLOC and beyond). By the time these states are reached,
ticket waiters can deadlock waiting for space that can only be freed by
zone reset. The fix adds RECLAIM_ZONES and RESET_ZONES to the first
async reclaim loop (FLUSH_ALLOC) specifically for zoned filesystems,
ensuring zone reset happens early enough to free space for pending
allocation tickets.

Additionally, the series fixes a bug in data relocation block group selection
where the first block group was incorrectly skipped, and adds a new flush
state (BTRFS_RESERVE_FLUSH_DATA_RELOCATION) to use priority reclaim for
zoned data relocation operations.

Using this, generic/747 passes when lowering the fill_percent variable
to 80% (from the 95%) that XFS uses. I'm still examining if this is due
to XFS not having metadata on zoned or other statfs space estimation
bugs or something else.

Changes to v2:
- Re-do the data-relocation block-group selection algorithm

Changes to v1:
- Removed the zone_unusable statfs patch
- Removed the heavy handed flushing patch
- Added fixes tags where needed
- Added more comments

Johannes Thumshirn (5):
  btrfs: zoned: document RECLAIM_ZONES flush state
  btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
  btrfs: zoned: always set data_relocation_bg
  btrfs: zoned: don't account data relocation space-info in statfs free
    space
  btrfs: zoned: fix deadlock waiting for ticket during data relocation

 fs/btrfs/delalloc-space.c    |  2 ++
 fs/btrfs/space-info.c        |  9 +++++++++
 fs/btrfs/space-info.h        | 11 +++++++++++
 fs/btrfs/super.c             |  3 ++-
 fs/btrfs/zoned.c             |  8 +-------
 include/trace/events/btrfs.h |  1 +
 6 files changed, 26 insertions(+), 8 deletions(-)

-- 
2.54.0


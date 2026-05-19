Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BECA33A6F2
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205783; cv=none; b=XlBE43ruYY+FjK+fXSmHiTwPUCtqaNVKb0c3IsuG3GV8OotelwylwUGRruSG8n0Lc1hEaMyp8g8o32KBY6mMcjPErvB4Wx/692vOpBpDfYqagCPg0zIMip5SCQOONMHAiXkbzj5MeuD8+LN+fFLGJcyicAB3jlmIEZ1CpXdLWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205783; c=relaxed/simple;
	bh=9S0wySWI4qAAKZumoW3qqp9FjgeO/ChtAlfef9P5AD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qv7SB11kERJA6I7mg8OYjVGqmZh0sE5gMTGdkea7lvwdmgxfyCd+21p/zWj16NigwqXGRslP6V9bucP324eGjbD9bLFN0TTkerJX8QOXPTAH9twh4WZmL1Xlsxq0KBsvSgztqtTCkUId5rNyKP43v2RAEQaF7jcHkaag513iM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IecvYLX9; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IecvYLX9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205781; x=1810741781;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9S0wySWI4qAAKZumoW3qqp9FjgeO/ChtAlfef9P5AD4=;
  b=IecvYLX9hQj/cvC2XUIyr2Rijhi0xv7TIxZl2pBUCgeZMFHpmQTfISQI
   wdC3JDB7u/jPQi27QmpFO/EimklK8pQZn5O6+Mqmn7iHhW2bHi6qm/6Op
   XxS+7t0V61NsB3q1f4OIPTZHSKp/d773QH2vmThn/sjLHkjj7y7cXwZtI
   hsLJWm99lrOD07IwNdBldijfSdDlt1U0qeaMURFaAnNcg7i2cr4vxWnnj
   o9JEsWaAsGw2Xk5ZLh75g9P+CYq2262g8rFPnRwIRdMzGZ2Mob5eNQHjl
   0EQ8bko/VDDZv4GD4l3Kjp9hfZmFVXrU4yiLhkKRCDVBPhI9PinunooD+
   A==;
X-CSE-ConnectionGUID: 2VsWVcOXSp2x4tROLwoEzA==
X-CSE-MsgGUID: KftvLXhuRQW0c3utua96fA==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146893470"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 23:49:35 +0800
X-CSE-ConnectionGUID: mv9T2vEjRnmaKmxlaZgu0w==
X-CSE-MsgGUID: oS5NoJnOTOqlQuYMfWomnA==
IronPort-SDR: 6a0c8678_bQ9GCuLpHncsMsLNQqmETOhreVL1uIAZJGvluilTlbYzps7
 Jjk26g+G4wcZxPFN7/+7sPJgARlyfBJq/zKKTkg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 08:49:12 -0700
X-CSE-ConnectionGUID: Fj5mCX1QTpO2saQXxMSXxA==
X-CSE-MsgGUID: L4rxJo/QQZ6vRkFzEGLN/g==
WDCIronportException: Internal
Received: from wdap-koukjqvp2n.ad.shared (HELO neo.fritz.box) ([10.224.19.38])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 May 2026 08:49:06 -0700
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
Subject: [PATCH v2 0/5] btrfs: zoned: fix deadlock and space reporting issues for zoned filesystems
Date: Tue, 19 May 2026 17:48:57 +0200
Message-ID: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
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
 fs/btrfs/zoned.c             |  8 ++++----
 include/trace/events/btrfs.h |  1 +
 6 files changed, 29 insertions(+), 5 deletions(-)

-- 
2.54.0


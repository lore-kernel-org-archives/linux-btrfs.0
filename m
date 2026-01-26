Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B7C29CE9
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 05:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406639; cv=none; b=dK7yXCQz/hngmTBjhHS0ZkmRI5S69Pdjw32MNbMjoqn25mtfBQWsxnknbpv6++wzJtHZGnWnaisrgLeB0HrBgdPDGZ9OrBk1/IzCnULEF8geO2iC+C7I5pNHUUi7DAkvbG8KZVgkBrf8p7HwQc3Roh7E0gceFHhCnsCk3Y7320U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406639; c=relaxed/simple;
	bh=JtKsjEAQ2m44gLeVM4VCEXsMxqeATS9+9zZN52UlVes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cm9VEq3JjZfalHdLIlknVvrtK90+58/WbDTIihKSJz3eHjB53+ceKRPgs7jjW1F/nF2mckYs+nfAOJmrCqD4Bf9G/mBU2gTS8QLeCetNNJjiNP0YXhH9akUZeE5X8gpELl87pNSrGvRpDBxKC/219lwulZE54128L/CBdwrOb1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TwuaIAVX; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TwuaIAVX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769406638; x=1800942638;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JtKsjEAQ2m44gLeVM4VCEXsMxqeATS9+9zZN52UlVes=;
  b=TwuaIAVXvUSej1/kD4339P7Vhk7lqzy1ngWZImgDL4RzyFfj4edRWs2S
   DdIzPqoqc1LAhJ+JBIMdzj/yy1dhqgBo0tnX8kvw/l7I1KI9oQ+DRPuN0
   d7OrHhfQRV1IS09bbxxxpmj1zVDBCj5tkByIqAIQ9VZ1JNRyqu9Vx+eYk
   uYE96v+L/7z8AEnBbWOVYy0jSAgehka9SMQ5eBuu0bXQerSvmEQ6kJGij
   sqdI9wU1mBxgLT+sx+CTyxbH+bmrMPk1BhpeQuKLJgr/O4yi2JGfTD6IN
   eb4n1nyoDIksgiew21vD7RC06O0bC6VYqKD9YUPnk3OTebN2+mVl6zsGB
   g==;
X-CSE-ConnectionGUID: UfCkKuEFQG+jhtr/hJ/BsQ==
X-CSE-MsgGUID: Yt5NikBGQSiDdrlN0rUimA==
X-IronPort-AV: E=Sophos;i="6.21,254,1763395200"; 
   d="scan'208";a="139468886"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2026 13:50:31 +0800
IronPort-SDR: 697700a6_CE4fA3RDs8P4hwjg6gpleNyYW8H+lVLrrvjwnH6li9E5hG2
 LBPhr0MC9bNBXsy3oiD9x2+ml000aEABTQCqZhA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2026 21:50:31 -0800
WDCIronportException: Internal
Received: from 5cg2075g8f.ad.shared (HELO naota-xeon) ([10.224.105.93])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jan 2026 21:50:31 -0800
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v2 0/4] btrfs: tests: zoned: add selftest for zoned code
Date: Mon, 26 Jan 2026 14:49:49 +0900
Message-ID: <20260126054953.2245883-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having conventional zones on a RAID profile made the alloc_offset
loading code enough complex. It would be good time to add btrfs test for
the zoned code.

For now it tests btrfs_load_block_group_by_raid_type() with various test
cases. The load_zone_info_tests[] array defines the test cases.

- v2:
  - Fix compile error without CONFIG_BLK_DEV_ZONED
- v1: https://lore.kernel.org/linux-btrfs/20260123125920.4129581-1-naohiro.aota@wdc.com/

Naohiro Aota (4):
  btrfs: tests: add cleanup functions for test specific functions
  btrfs: add cleanup function for btrfs_free_chunk_map
  btrfs: zoned: factor out the zone loading part into a testable
    function
  btrfs: tests: zoned: add selftest for zoned code

 fs/btrfs/Makefile            |   4 +
 fs/btrfs/tests/btrfs-tests.c |   3 +
 fs/btrfs/tests/btrfs-tests.h |  14 +
 fs/btrfs/tests/zoned-tests.c | 676 +++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 112 +++---
 fs/btrfs/zoned.h             |   9 +
 7 files changed, 771 insertions(+), 48 deletions(-)
 create mode 100644 fs/btrfs/tests/zoned-tests.c

-- 
2.52.0


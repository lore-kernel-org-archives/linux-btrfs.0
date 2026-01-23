Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E77221F13
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769173196; cv=none; b=ncLZLIEGAMszKVnX32HHotJhFQhBkIu2mVvzyeXiR2WDabo5paNZiNIVZnouJKlfQfb5OFvjV8rdJ8z313d9VUBXJGQVQQ+qWX8x9Qy7tm7v0cAlpQ8bPQeTAGYPEbtxX/vCWT4N7nEhAPE8I9glJchtWjwKtLw7ygATfy7+iro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769173196; c=relaxed/simple;
	bh=oR/n4/H7kH7BffVcEunlCRwVwq1ZL941yU/TZWJBIBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=badFiFV34srwxlwu4wD9tWCYfa3VRNCRj8WkwwVtyTruVdp5K3jwwhwzm/mvBQ3agMFb5oklMPcYS4Hl1eYqBPnOLd+UZ9buWk4FgeqUxfKWU+50xO6kw1T0s3FGqVKdO/BnWNMiQgMO6/Zf6IVhWrHxOTcNH4GWAR+tl6BUGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WvsOeT8B; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WvsOeT8B"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769173193; x=1800709193;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oR/n4/H7kH7BffVcEunlCRwVwq1ZL941yU/TZWJBIBI=;
  b=WvsOeT8BbmGojpZjpEMtK18MmAmLpDe1p7YAf4He0nARbYwceBwcogoY
   76u8p29/28soIh7a6NEyqA6GpVZx3hwfnfuLprVO1TM16uTR35YiiI2gi
   xmtrY2pExb3Qp7nkX9qzSZcLlBDAVwAGX7XwjNEORRH0TQ1nvnxSYXSfe
   cTobPgK093Qr3xsJ7wa82W58wiX0hO0hMwM2PaB9xiUIXQ1/Zt8dI7RJl
   F4ztCwowVHULHmvlmPP7ZlHQxsA1aki/XaVQ3VlhPWCDccT3To9/88NlY
   KeSsmxnGWGmBvoONHN9kJzxoQ6SAdys4JpDAzbteW4WFQrmbWwzbyTa9X
   Q==;
X-CSE-ConnectionGUID: BMiwI77ORxits/dl0wXTZw==
X-CSE-MsgGUID: OjWJK50vQ0S4ixEgoxtDfg==
X-IronPort-AV: E=Sophos;i="6.21,248,1763395200"; 
   d="scan'208";a="138590777"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2026 20:59:47 +0800
IronPort-SDR: 697370c5_cgg5kaW2FRQ1XnWiRHcERw3aQg1Spi0uTK+KhTVVWdF6ck1
 yEc/FpbDz6EmXhsRY4NRRUE1ZAUBYzijommc/YA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2026 04:59:49 -0800
WDCIronportException: Internal
Received: from 5cg2075g8f.ad.shared (HELO naota-xeon) ([10.224.105.93])
  by uls-op-cesaip01.wdc.com with ESMTP; 23 Jan 2026 04:59:49 -0800
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 0/4] btrfs: tests: zoned: add selftest for zoned code
Date: Fri, 23 Jan 2026 21:59:16 +0900
Message-ID: <20260123125920.4129581-1-naohiro.aota@wdc.com>
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

Naohiro Aota (4):
  btrfs: tests: add cleanup functions for test specific functions
  btrfs: add cleanup function for btrfs_free_chunk_map
  btrfs: zoned: factor out the zone loading part into a testable
    function
  btrfs: tests: zoned: add selftest for zoned code

 fs/btrfs/Makefile            |   2 +-
 fs/btrfs/tests/btrfs-tests.c |   3 +
 fs/btrfs/tests/btrfs-tests.h |   7 +
 fs/btrfs/tests/zoned-tests.c | 676 +++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 112 +++---
 fs/btrfs/zoned.h             |   9 +
 7 files changed, 761 insertions(+), 49 deletions(-)
 create mode 100644 fs/btrfs/tests/zoned-tests.c

-- 
2.52.0


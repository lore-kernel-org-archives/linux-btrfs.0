Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6787341D656
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203042; cv=none; b=MJ6meSpLYvSF67N1JgoTwJpHvlisoS31gv2+92Kq+UpIXfLjL2+f+2YOK7hjn6f0EPD3odOWAIpYx3n2ysneZUr0jOg1hBc8ORb9VbAl2Puvk7rkOaRJWWFZhptxaH0FyDb4AizvqRudTnARucSpuUgH4woKSguZGdBvp+ZsD1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203042; c=relaxed/simple;
	bh=OylxGSuQxiASOZ/FJg+A49d8dXe4i/Gw2fCPpEaWraY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lGlhOJvXnE/grtc9ULusW0WKvNsWTC1WyvFy3a7Bu542mRokkDRGjjHWfqT+hG3BRwcZ8N3LUzuu8iSmUvNhRDRPe5QFYAa6GcXcSjpgKWzAhARhAo2xFALHXD5AQDLaAlnnF7ozvQI43nCIwgFodmyg05sigifumK09uxhhzbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MZCFohm6; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MZCFohm6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203040; x=1815739040;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OylxGSuQxiASOZ/FJg+A49d8dXe4i/Gw2fCPpEaWraY=;
  b=MZCFohm6wvgn4XyqsG5Q+DSwcU2G12DOSqiV/ieyQhwwyHgsaVYh84BW
   fse8vH740NUyUBD4OgNjYZ39M/w0TF2ul6tyIGq0RGqf4aLwSG4srUrMm
   VscTGFfFmx1hSu1/qdCozGVV7SzbgX04sHev8EKXhR4zQWzfj11IqEt4t
   d4TgrP4dVlhxOHmZtDxkGmK7XLLS9Xlvx0dVwILWguLbLB0/JdjUX8WT+
   JLycDf0KFfS9YtdOdYDqJhL1Mgm9L6NpOdIprsLpEn1Q2t3I05vWT31fv
   4lu4Kp1gJfL5gbtYVyMIeT1OfNc9hivB+B7Ba2DRdFs9P/RUv7B7PsifE
   A==;
X-CSE-ConnectionGUID: 9KU7dcz1QK2Pf9+Q8tzqQg==
X-CSE-MsgGUID: c9ZZ57yHQDykNxm/U1GYaw==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860081"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: UNmc0UdMQLymoUWhgetTuA==
X-CSE-MsgGUID: QNjoJnUKRTasqGU17cx4GQ==
IronPort-SDR: 6a58c70c_U7jQTrDzROKj9irkKnnBMdVDD1ccYqKBC3AG/zKlwevP68t
 ghUs+yOB5m1RNeALHc6CzmDFKqC3k6hYJ2/8t1Q==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:00 -0700
X-CSE-ConnectionGUID: yv0tWAwOTju6uuYIr5lV6Q==
X-CSE-MsgGUID: YyNlAPvTT3aNsfBRE9bkBg==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:56:59 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/5] btrfs: zoned: fix two deadlocks when runing fstests
Date: Thu, 16 Jul 2026 13:56:51 +0200
Message-ID: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two distinct deadlocks when running fstests:

- The first one happens primarily (but not only) on btrfs/187, Where we
  bunch up dirty metadata and then on umount try to submit it. But at
  the time of submission the block-group is already gone leaving stale
  folios behind that can't be written out. Patch 2 fixes it by clearing
  the stale buffers, patch 1 is a preparation patch for patch 2.

- The second one is a double lock of fs_info->ordered_extent_mutex when
  doing zone finish. It creates a copy of the roots that need to be
  finished and then does an unlocked version of
  btrfs_wait_ordered_roots() btrfs_wait_ordered_roots_nolock() on that
  copy.

For both issues debugging was done LLM assisted and I attributed it in
the respective fix patches (not the prep patches).

Johannes Thumshirn (5):
  btrfs: factor out dirty-clearing part of btrfs_clear_buffer_dirty
  btrfs: zoned: drop stale dirty btree buffers at close_ctree()
  btrfs: walk waited ordered extents in place
  btrfs: walk waited ordered roots in place
  btrfs: zoned: avoid ordered_operations_mutex when finishing a zone

 fs/btrfs/disk-io.c      |   4 ++
 fs/btrfs/extent_io.c    |  57 ++++++++++++------
 fs/btrfs/extent_io.h    |   1 +
 fs/btrfs/ordered-data.c | 129 +++++++++++++++++++++++++++++++++-------
 fs/btrfs/ordered-data.h |   4 ++
 fs/btrfs/zoned.c        |   8 ++-
 6 files changed, 159 insertions(+), 44 deletions(-)

-- 
2.54.0


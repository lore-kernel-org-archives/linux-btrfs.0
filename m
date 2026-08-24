Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF6376A03
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 06:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787554242; cv=none; b=PQOmjra81xKg+lVWV5XQ3w5KY5vnxzxudmIScuK//LXFlF40KwMuFWggCAF2ui+8ZHlLo/cJFiHwUie+l8DcOZBh8w7oA1gzP1haTGoJ64Qwkbk1o60jRf03I982+KkphW3xqYRh91wRG7z8ekgqISQ83cOLkPE+N2/aks/QK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787554242; c=relaxed/simple;
	bh=NyB0Sv5qEfQ5a5i5fPNE+IaX898+55hurY/FJ22HikM=;
	h=Cc:From:Content-Type:Subject:Date:Message-Id:To:Mime-Version; b=buFY6mH7vOp1F2Mot1LLBPYVUjT9Ehf10vyV6fBjzr6gmLtE8lAhYV1R/hyMPRJDSrMBDiiIcpnvhxH2PF4elzgWqyccLFXOu6vB/IzL5RAgE+97YjdBEGuKRY5h8y63NHfsfbV5z3r6yO+VGjeIY7s/NuesN8uDO+SNSFieKGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=oHP7z6xP; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="oHP7z6xP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787554227;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vbRxx1pIiN4oUNi3+wFTFAtq9DwBmjEtYzvjr66tQCY=;
 b=oHP7z6xPr/yCL6SJfAMBrp+zR9/klEc/fSIDYqDbMOCu5mbyb4oqtlMqWL1zPNQZQv/V37
 +uRlWl+mHmarg+OWrJodBa6S09h2f+/ZLE1kqZZM1oqB1tisWJmEgzPMeOl8tGclVVnr25
 Pq22XeCAhdK4zchAQFkG8WQTKmdf6qB8MX+Hi9MOT8+kCtTLutrDmMuamhWfpL3bjDZsds
 4J61gwW3En24cThyERhmRlFDU7WYBa7pxq0CeI9eBebMeC5Va7axnXEqqQyB/G/l5nO6Kq
 dliB2trHiuDNhxaA2LRoIYc2WwydzePDtdbH3jaKTBO/eNk1xgfSUho/R5Qz3A==
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Received: from pdzhu.teiron-inc.cn ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Mon, 24 Aug 2026 06:50:25 +0000
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 0/4] btrfs: zoned: fix active-zone accounting and transitions
Date: Mon, 24 Aug 2026 14:49:52 +0800
Message-Id: <cover.1787551793.git.zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
X-Lms-Return-Path: <lba+26a8be9b2+07c702+vger.kernel.org+zhudongjiang@fygo.io>

After systems using HC620 host-managed zoned devices were upgraded to
Linux 6.18, multiple users reported transaction writeback failures with
-EAGAIN that forced filesystems read-only, as well as hung tasks.

Enforcing the device's max_active_zones=128 limit exposed existing
active-zone handling problems.  We reproduced representative cases
locally, including an -EAGAIN transaction abort that forced the filesystem
read-only and a balance self-deadlock that stalled transaction commit and
data writers.

Further investigation traced these failures to several related gaps in
Btrfs active-zone handling around mount recovery, non-data block group
activation and zone finishing:

- Conventional zones participate in runtime active-zone accounting, but
  that state cannot be reconstructed from device zone conditions at mount.
- Active metadata and system block groups are reconstructed at mount, but
  their runtime write roles are not.
- An obsolete allocation-time activation helper bypasses the write-time
  role pivot and can recursively enter zone finishing.
- do_zone_finish() clears the active state before the device operation has
  released the active-zone slot.

Together, these bugs can leave no active-zone slot available to metadata
or system writeback, or recursively enter zone finishing while holding
ro_block_group_mutex, resulting in the two failure modes described above.

Fix the active-zone model and its state transitions as follows:

1. Track only sequential zones as active.
2. Recover the normal metadata and system write roles on mount, and finish
   extra active block groups left by the old behavior.
3. Remove the obsolete allocation-time non-data activation helper so
   metadata and system activation goes through the write-time role pivot.
4. Serialize concurrent finish operations on the same block group and keep
   it active until the device operation and software cleanup complete.

The individual commits contain the corresponding reproduction conditions,
kernel stacks and state-transition traces.

Dongjiang Zhu (4):
  btrfs: zoned: track only sequential zones as active
  btrfs: zoned: recover active non-data block group roles on mount
  btrfs: zoned: remove obsolete non-data block group activation helper
  btrfs: zoned: serialize zone finishing per block group

 fs/btrfs/block-group.c |  38 +++-----
 fs/btrfs/block-group.h |   7 +-
 fs/btrfs/disk-io.c     |   7 +-
 fs/btrfs/fs.h          |   4 +
 fs/btrfs/zoned.c       | 193 ++++++++++++++++++++++++++++-------------
 fs/btrfs/zoned.h       |   9 +-
 6 files changed, 160 insertions(+), 98 deletions(-)

-- 
2.39.5

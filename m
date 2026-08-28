Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7039A071
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889133; cv=none; b=YiUKJuwr/6dWkwoWPaBfPvPZ/Vbm20kQxIBJpMA6elhjo6UOyrnV3bm9HlKHZTfnyi7EVfp5Q6yEj4v89e6FFqtYCohb2/eORNeUNdftiZSQ9Dess0BKOjBmaNRtp1CizaudeZO38TJWAhRkKe4ehoHF8VTMKHBMUKE2OJfD5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889133; c=relaxed/simple;
	bh=kXXDItl870PiEf4vY90NROEUJ8oruhD8crYeWeLYnLA=;
	h=From:Subject:Mime-Version:To:Cc:Date:Message-Id:Content-Type; b=OLp8lKnfvn+hx+9GQtC3VNXWzKhK4z5KWXDBuSG0vGBbiVTDQ9aRDYiaeBeyYW9l9LUPgyZ9we0pbWU8IdS+06QsSVe0Za/cvMrv4FQl6PvgfiBlgWbqtkguAgiRMHw5BAKqQt108MpycG8BEXDxCYrW+/4tOHiY4Q7ZOaHttxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IxzmBq+Q; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IxzmBq+Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787889119;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/t3NoiW/Aj57EmTf1jmBQlixXkepWdLuzNUBlLJhSU8=;
 b=IxzmBq+QU87XxeCLPGoVsW0SMRM4qLuXPKfnv6nRWWoin+aEavIOlmQhIghQxyJQyzrwL3
 5QbNABg8xYau+aGpQm5npaWq7UDIE5AJ2vOVo2GWNd/qYiKbnq6cok65MuKTHrAcOEcVDE
 i3uCI+2zFPYLv9/bYd0Xog077XzJb8cY1FcWySMCbGCBhbzi9xzr/iaVkalKnwIOjvFa10
 T+GpZG4H3FYgt5DqTotryWmp7+b9D5R5bKRLK5rTS9SVtT6XNmFDBCLUAWFGxaBSudMP4B
 rAcD28hbDWfRNSuta/i7CADUQfVkky2Cyja1oPMICSmSWGw3VIzeaqGeZB6TMg==
Received: from pdzhu.teiron-inc.cn ([14.21.226.247]) by smtp.larksuite.com with ESMTPS; Fri, 28 Aug 2026 03:51:58 +0000
X-Lms-Return-Path: <lba+26a9105de+e0dd63+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Subject: [PATCH v3 0/4] btrfs: zoned: fix active-zone accounting and transitions
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
To: <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
Date: Fri, 28 Aug 2026 11:51:36 +0800
Message-Id: <cover.1787887776.git.zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

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

Changes in v3:
- Dropped the block-group flag comment changes from patch 1; no functional
  changes.

Changes in v2:
- Removed the [BUG], [CAUSE] and [FIX] headings from the commit messages.
- Added a helper for identifying zones that need active-zone tracking.
- Added block group locking around alloc_offset and zone_unusable accesses
  during mount recovery.
- Explained why moving the active-bit clear alone does not serialize
  concurrent zone finish operations.

Previous versions:
v2:
https://lore.kernel.org/linux-btrfs/cover.1787717573.git.zhudongjiang@fygo.io/
v1:
https://lore.kernel.org/linux-btrfs/cover.1787551793.git.zhudongjiang@fygo.io/

Dongjiang Zhu (4):
  btrfs: zoned: track only sequential zones as active
  btrfs: zoned: recover active non-data block group roles on mount
  btrfs: zoned: remove obsolete non-data block group activation helper
  btrfs: zoned: serialize zone finishing per block group

 fs/btrfs/block-group.c |  38 ++------
 fs/btrfs/block-group.h |   1 +
 fs/btrfs/disk-io.c     |   7 +-
 fs/btrfs/zoned.c       | 211 +++++++++++++++++++++++++++++------------
 fs/btrfs/zoned.h       |   9 +-
 5 files changed, 167 insertions(+), 99 deletions(-)

-- 
2.39.5

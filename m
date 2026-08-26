Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F6A3264C1
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 04:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787718475; cv=none; b=DjhChuVldhEFRdpdb6Bz+k84QAEMX6xaO0OAfVzU5tcpapEPndApEMTs7f6ziwPIckDRM29giYR+fFc+OH0f6EZFA2n/yALMLTcHFUfglAsyLegHOC3Mv/dvH7osJ3kP2hFLblCTdOnGhu9xghQF0wOxpgnuZ9eXPynd4vGx22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787718475; c=relaxed/simple;
	bh=rDX/JqgPZiyS3DSfRDxHqsAGdz0DhfKqbqvh2Dh4LcI=;
	h=Subject:Cc:From:Message-Id:Content-Type:To:Date:Mime-Version; b=c4s3MYSO4VWMP1U/fkg0em/xHSpP5XeqUG47exp/Xqlixte6JcWPsKpPqysTvy8493AndTYzH3rEkFYyQadccvZE/BIsNybIAkolfiL2M6rtWLJWZWSzAAG/I29agBT/3OgdgYew6E6ubpJ6EFG+fDjKKX0AN8zloJF4nY4xdAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=WqJsSXH/; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="WqJsSXH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787718459;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kQR4SAScBZlVxNQyzRWlNIO4D9fqFwtvlTHeaRjnR3E=;
 b=WqJsSXH/e/Czu5isTHvp0kn9lmz/NPwnahH+TG6QurQgyTzIo1oEyUeMJC5plNgWt1+YLv
 TmBroFtQvPWFvzKv7mcZPKzz/TvOVRvCgaatsdQIwGU9Ke0Qx1XxAkLjTG0/IYahUueBPJ
 XI9hhMP//s8aAWViEPoJYx9BJaaZ2HS+QZudfngrY6YF8j68WaRlL5tuWmk5Jq1AvOcwxY
 F2mh1hv/DEIlaFqBvSOiSPv0jhKtnDddFX8ipoudBWjliIryUoxllqi5CheJ8uRLR7e2nT
 w71aDfsjSlMRJkS3heCFJO3wHdcqTGvEqSun+OMBli2lLalAcR7u+gAHIjEBgg==
Subject: [PATCH v2 0/4] btrfs: zoned: fix active-zone accounting and transitions
Content-Transfer-Encoding: 7bit
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <cover.1787717573.git.zhudongjiang@fygo.io>
Received: from pdzhu.teiron-inc.cn ([14.21.231.246]) by smtp.larksuite.com with ESMTPS; Wed, 26 Aug 2026 04:27:38 +0000
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
X-Mailer: git-send-email 2.39.5
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Date: Wed, 26 Aug 2026 12:27:23 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a8e6b3a+7511c4+vger.kernel.org+zhudongjiang@fygo.io>

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

Changes in v2:

- Removed the [BUG], [CAUSE] and [FIX] headings from the commit messages.
- Added a helper for identifying zones that need active-zone tracking.
- Added block group locking around alloc_offset and zone_unusable accesses
  during mount recovery.
- Explained why moving the active-bit clear alone does not serialize
  concurrent zone finish operations.

v1:
https://lore.kernel.org/linux-btrfs/cover.1787551793.git.zhudongjiang@fygo.io/

Dongjiang Zhu (4):
  btrfs: zoned: track only sequential zones as active
  btrfs: zoned: recover active non-data block group roles on mount
  btrfs: zoned: remove obsolete non-data block group activation helper
  btrfs: zoned: serialize zone finishing per block group

 fs/btrfs/block-group.c |  38 ++------
 fs/btrfs/block-group.h |   7 +-
 fs/btrfs/disk-io.c     |   7 +-
 fs/btrfs/zoned.c       | 211 +++++++++++++++++++++++++++++------------
 fs/btrfs/zoned.h       |   9 +-
 5 files changed, 172 insertions(+), 100 deletions(-)

-- 
2.39.5

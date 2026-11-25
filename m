Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602105;
	b=HdYV4XVJUENBJPFpOlPgBjG8BjLf15tv+rLj/eAu5kZbpMf9gLrFrlaNpVLpslWCGTXx
	 MFhYyhrERYRfUk9xDjjfk7le/4+IFCEgi2wABm63wavTQEXjMPiliyDhhq3CyZUM6CeAf
	 BhpvmJ8v2NoB38k5AiiYlr8W0WVKnBTOI/dm/1/kUCc5kw4QwmtHein3oi2aHFA3IfSJx
	 YvMaPHQ3ffl6NoG/SkS5gC/JJkBhR5RTlUbjLUA7+17HokpKJPC9CMEibYvr0qjn8SWtn
	 W4UyK+leOLvToqBdQkCtLYf1uUtUdKjgUNn19PNRaO9+BMBi3mJ7MRW6blLVozWtXtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602105;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Mime-Version:X-Original-From:
	 X-Mailer:Content-Type:Cc:Subject:Date:Content-Transfer-Encoding:From:
	 To:Received:X-Lms-Return-Path;
	bh=uLbd3W3shGdi/jYi5um9q/SoKm/LuDDOPTtMewAzBpo=;
	b=RiMod9Im4cJeXRurKK/Sy562o0T5KGQmbBIAgwkR/zxYfuQEfhXIAbEoJ5oNk91JgoPU
	 J74RdBESV+tD67RNGBOVfMM9cXKO67PD9E+cWxeY4flZIl1j/UHCVqV8rhws0NpW28hBr
	 hegOB+4E78sUCdql6+b1oHzo4qPI6/FZ16eFaiAthLVXQhkl1cGnEz8nyTAFmp0B5OkRm
	 beI2m2IfQ+CwrbrFLMtVRwcgSx9y/xUzohVC3fYbWdLLa0/OB6UDqk9uLuYjXD7suJCwX
	 oD7Q99urBgnbC4sdeyiyP74DKXfNcyO1PGW3HuYLRJdjD7LMhA1TUUEkzMsMRI3vFfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=U3NS7rEG;
	arc=none smtp.remote-ip=209.127.231.57
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AA8606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66AA8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=U3NS7rEG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795602099;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uLbd3W3shGdi/jYi5um9q/SoKm/LuDDOPTtMewAzBpo=;
 b=U3NS7rEGp0xCpaz+WXpf/5QyXAyOYcBWrVKVvS5R00pm+FZESFHjzesbMb0AdyJlLS6KlU
 XvuMqpAsG6vqF9gs6EpOun26kQDHJvjXAoSsabdc4vjEwKUPf4aJFQe9BhCMxR9EPTK68B
 gcxXZCH6tI4xTHTsLhdoCFheHFJS9kPW41g+tX4BBIfWgorcIPlZ6fj31mV8RTA2W40Gn7
 dFJ//txGvM7ptYAoShK77Nyx5rQHn6UG9YACFDIzO+dc0B1zakvhKk1wt1tPqZfL3GUh2t
 tjhSlZrsWO2UO0fUMMbH5ailAZXiEsVMZ1wlu7hR/GYRhD86zIjHPvwDfljuFA==
Message-Id: <cover.1795600611.git.zhudongjiang@fygo.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset=UTF-8
Cc: <johannes.thumshirn@wdc.com>, <naohiro.aota@wdc.com>, 
	<a2jphilipp@gmail.com>
Subject: [PATCH v4 0/4] btrfs: zoned: fix active-zone accounting and transitions
Date: Wed, 25 Nov 2026 18:21:27 +0800
Content-Transfer-Encoding: 7bit
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Received: from pdzhu.teiron-inc.cn ([183.34.165.116]) by smtp.larksuite.com with ESMTPS; Wed, 25 Nov 2026 10:21:38 +0000
X-Lms-Return-Path: <lba+26b06b6b3+5e4816+vger.kernel.org+zhudongjiang@fygo.io>

This series addresses active-zone accounting and block group
transitions on zoned devices. It simplifies conventional-zone handling,
restores metadata/system write roles at mount, and addresses a
balance self-deadlock and a race during zone finishing.

The four patches:

1. Track only sequential zones as active.
2. Restore the normal metadata and system write roles at mount,
   keeping one active block group for each role and finishing the
   remaining active non-data block groups.
3. Remove obsolete allocation-time non-data activation, leaving
   activation and role switching to the writeback path.
4. Serialize concurrent finish operations on the same block group,
   keeping it active until the device operations and active-list
   cleanup complete.

Jochen Philipp tested a rebased version of this series on his
filesystem. He reported writing another 2.3 TB via rsync without
Btrfs errors, a clean unmount, no errors from btrfs check --readonly,
and a successful read-write mount afterwards. Many thanks to Jochen
for the extensive testing.

Changes in v4:
- Rebased onto btrfs for-next at 7bfc2c517eac.
- Retained the upstream active-zone bitmap check for mount-time
  reservation accounting and the conditional reservation updates
  during activation and finishing.
- Moved abandoned-tail accounting into do_zone_finish(), alongside
  the alloc_offset update, preserving read-only block group accounting.
- Removed the unnecessary temporary block group references in
  mount-time cleanup.
- Updated the commit messages to reflect the current base and clarify
  the role-recovery and zone-finishing behavior.

Changes in v3:
- Dropped the block-group flag comment changes from patch 1; no
  functional changes.

Changes in v2:
- Removed the [BUG], [CAUSE] and [FIX] headings from the commit messages.
- Added a helper for identifying zones that need active-zone tracking.
- Added block group locking around alloc_offset and zone_unusable
  accesses during mount recovery.
- Explained why moving the active-bit clear alone does not serialize
  concurrent zone finish operations.

Previous versions:
v3: https://lore.kernel.org/linux-btrfs/cover.1787887776.git.zhudongjiang@fygo.io/
v2: https://lore.kernel.org/linux-btrfs/cover.1787717573.git.zhudongjiang@fygo.io/
v1: https://lore.kernel.org/linux-btrfs/cover.1787551793.git.zhudongjiang@fygo.io/

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

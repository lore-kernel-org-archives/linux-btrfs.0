Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156219CD1D
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 05:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783747191; cv=none; b=KOy3ZA1ryRubI5SgLwnlRvqBqPQDx2Li8xDinXdZTN9HrUZ38rh1l0h01cRrGFKx2v5A6a6AXfHLjktj8WC/LWuD42gSBoy3yV4UI6Vq44sXQoL/L8HWE0dfNKOpmLtwKYdoyuyehggreqcPU4I+Jy7NwoiilU7T1ja9a07cQtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783747191; c=relaxed/simple;
	bh=KVXpc5WDl04hpTn93M9/jaIpdcQIOPAU1RxLxBhQ/0s=;
	h=To:Subject:Content-Type:Cc:From:Mime-Version:Date:Message-Id; b=uSqAoa69iPhueN4NUVwYCxSuj1H/DXubOt6AjbG/TVJ2ow/PmOmRXKhZojzAOn27x8VuvibAeKfxlKVdHXaMSTUUptCEsC1nPnx7mg1PDVz8u8l9r6D2QZUYiXwcEUSeJHU5POf7Vcp1IKoFAkYtv2HrwNQ/up2YHp7QdD9Cq3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=hLh5xN/2; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="hLh5xN/2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783747178;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=w1IptLzxXuQO4U9bYH3nEpH8Vs8TVcf4sMP7AMm+jgI=;
 b=hLh5xN/2wkxtNNstUSZ92fjDvwn0C42N8fPXxSZ/Nb5UKV1WIEC+PQG+MuoWtaH4RDsGF+
 cqnb+BoLHfCl7SPyDfcIjvr7On4h0c8rfgLewTAstuPSd0raKUT3gdHbXcdeWuAcK58xkE
 6ns2z1UG6k3qwHXcY1Z2ntmc7z95qSyHed3PbSru5dWdjakEgpAy630mddBKc/HbODOfM5
 Z8CqioYj/OJzsjvitst/7aQTe7Dutqx17Uq2XuqLUCaLh4gCgTD4K8snmX3JmWktPnjmKA
 AaXLFILpTImf2M/rJ3VQLReg/bh228QTJDpsD7kc5EvrkXqXtlzO9c6jzTZtxw==
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] btrfs: handle missing block group and raid stripe tree roots
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset=UTF-8
Cc: <dsterba@suse.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
X-Lms-Return-Path: <lba+26a51d269+1d47ae+vger.kernel.org+zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Sat, 11 Jul 2026 13:19:06 +0800
Message-Id: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Received: from pdzhu.teiron-inc.cn ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 13:19:36 +0800

The rescue=ignorebadroots mount option allows mounting to continue when
some tree roots cannot be loaded. For the block group tree and raid stripe
tree, this leaves the corresponding root pointer NULL while the on-disk
feature bit remains set.

btrfs_update_global_block_rsv() accounts both trees based only on their
feature bits. It therefore dereferences the missing root while mounting.
A missing block group tree root reaches this path through fill_dummy_bgs(),
while a missing raid stripe tree root reaches it after the block groups
have been read.

After the raid stripe tree reserve issue is handled, data reads that need
the raid stripe tree can reach btrfs_get_raid_extent_offset() without a
stripe root. btrfs_search_slot() prevents a NULL pointer dereference, but
returns -EINVAL without any diagnostic.

The series checks that both roots were loaded before accounting them in the
global reserve. It also reports a missing raid stripe tree root during
lookup and returns -EUCLEAN.

Dongjiang Zhu (3):
  btrfs: avoid NULL pointer dereference when block group tree root is
    missing
  btrfs: avoid NULL pointer dereference when raid stripe tree root is
    missing
  btrfs: report missing raid stripe tree root during lookup

 fs/btrfs/block-group.c      | 7 ++++---
 fs/btrfs/block-rsv.c        | 6 ++++--
 fs/btrfs/raid-stripe-tree.c | 7 +++++++
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.39.5

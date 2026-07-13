Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A43C09F2
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932645; cv=none; b=BYrpMOMQiZTaQfkaG/Q/3DeXTnr+DfzPcqAJxvGqruzvrZuNeLXp0Joq5MVw4ErXZBYqiQpqLveQtFynKAmVqw4l7DYjkGbciqKVWh2QL18RIoKKsx8Cmhjk8ooWz3+ZMM0AiojUWCq/YLM2jk125NTiDqh8T4D4IF2byKI229w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932645; c=relaxed/simple;
	bh=X24Rt+ZSrBvkqoVVaGF4yWJyKLTsyNTGrvmNvJUl5Hw=;
	h=Message-Id:Mime-Version:Cc:From:Date:Content-Type:To:Subject; b=mk8mXBQh8jG6IE0Fn5IKv0YVJ8hzfBE5Mws2Dv1z0XCM0lr0PNm724pYDGHAIGw1nJzwoOkdlo2NNGqUswwGylkJiJrr/mOI/Laap/ta4y/7XwIHjdJI4d7yic/MFZyuvPniZsK4K8MUFJ/tVLA4Cn91/+cXD40ecNHwU9UE67Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=0hOWACOE; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="0hOWACOE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783932633;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6lHS0QoQscd9S3TZLilbBkS/ExlzreL4Kio+/qm/MuQ=;
 b=0hOWACOEL4+BOaJAmop6WFayfuykBRMXR5GuKOgXpAe427puJC3WUGJeJFhx0ZQ4zwzqoe
 WcVBs7tLx+KXuejwPSqGnSL3UmhNS5cqJNWdQAuOD9u5evMqSFipQVnQwkk794CGOCF6/Q
 An82/ZBUneyCjJUnhWXHOVz9QklPYCE+o4xuP47Hs71DuMdb+9Dkr+yoJYQySrYQNYxxp1
 74Fwc7S349ljOgjkjn/Prp91+JhZA/4zs9SZMblF2Ee81XzxcSHTPZcUBsQ4WoNlA/U8YI
 bMSxc5RS0hNhE5x1G8wrB00PiQSsmNLCRkakU53HaEfVfb7BWQ+WfDRWpT0mJA==
Message-Id: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5
Received: from pdzhu.teiron-inc.cn ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 16:50:30 +0800
Cc: <dsterba@suse.com>, <wqu@suse.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Date: Mon, 13 Jul 2026 16:50:07 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/3] btrfs: handle missing block group and raid stripe tree roots
X-Lms-Return-Path: <lba+26a54a6d7+82490a+vger.kernel.org+zhudongjiang@fnnas.com>

The rescue=ignorebadroots mount option allows mounting to continue when
some tree roots cannot be loaded. For the block group tree and raid stripe
tree, this leaves the corresponding root pointer NULL while the on-disk
feature bit remains set.

btrfs_update_global_block_rsv() accounts both trees based only on their
feature bits, so it dereferences the missing root while mounting. Rescue
mounts are fully read-only and cannot start transactions, so they do not
need a real global block reserve.

This series moves the full read-only helper to fs.h and uses it to skip
global reserve accounting for rescue mounts. It also reports a missing
raid stripe tree root explicitly if a later data read requires a raid
stripe lookup.

Changes in v2:
- Replace the per-root NULL checks with a dummy global block reserve for
  full read-only mounts, as suggested by Qu Wenruo.
- Move and rename fs_is_full_ro() so the global reserve code can use it.

v1:
https://lore.kernel.org/linux-btrfs/20260711051909.1313584-1-zhudongjiang@fnnas.com/

Dongjiang Zhu (3):
  btrfs: move the full read-only helper to fs.h
  btrfs: skip global block reserve accounting for rescue mounts
  btrfs: report missing raid stripe tree root during lookup

 fs/btrfs/block-rsv.c        | 19 +++++++++++++++++--
 fs/btrfs/disk-io.c          | 11 +----------
 fs/btrfs/fs.h               |  9 +++++++++
 fs/btrfs/raid-stripe-tree.c |  7 +++++++
 4 files changed, 34 insertions(+), 12 deletions(-)

-- 
2.39.5

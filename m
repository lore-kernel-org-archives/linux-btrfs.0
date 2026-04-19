Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867293081BE
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608795; cv=none; b=ZUqPiSPwp2Xrp8lJRsJx1xNDK1YcznQoixxqIvCR5zoLQmytnDnC1NAwDyXa5+ZjWEPgaS2tC21TYHjeUqlk+rreHsypjDUz7I+xUy8JT5cUY9Ur/KeOoUDoEGAGG19/WA/VGWH7J54AsuiSddLSdac30hXo1fVYuJOA6Geh8t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608795; c=relaxed/simple;
	bh=RTJKZ+/xQshh7/dWTt5uvBYdySizd8yWCzT5SoKSbgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oMQizM/oZZUQxXQ5w6xxLpedIpKe3NUdM8nD94r4pMA5wlbonHtiSRVvy/2Oje5AlBSjAXeJduAtQRCvqwpFKT+LXT8BQ+SChY774o1TjQrAXs4ddoR3OfE6RTnSPBDVJDuYuwVDhiBT4qY9kzV2rEgY5anHiY2iddXaKTwsSzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYq8PqBp; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYq8PqBp"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b93698bb57aso411009066b.0
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608792; x=1777213592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=js4/F1szIYY3tvHTwUeCU7IfM8YrLsOyAqjF8q55GQU=;
        b=VYq8PqBpflogOCqckxGBtvoUYQd1z23t3fHB2DNetlPC1ueVCAOX192HSvFo0Fugn3
         076UcaYWTc76FBi7wmExtNv1ps3474Q6/A8JKfGi4vr42jsX0708UagAVaUmdJ7ZoVvA
         npGp7G6DcKdZy0r27k3VAdst1Old2at2zor4rerqeStSTdX7p8S5g4EkBqtZqWQOuc7p
         cJR1m92ZBH6F45Zo0Av9FnyB5qcah8gavfXcUI5boDXsC7aAS1UE7IYvaNXvT0Jvd/8Q
         cRpJ1JMlsVLDhxSx1rPLVffAT1pGcGXQiLSNKuZRdOxdeP6cvKTQt3iuXU0fluw5Pbj5
         Bp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608792; x=1777213592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=js4/F1szIYY3tvHTwUeCU7IfM8YrLsOyAqjF8q55GQU=;
        b=W1Koe0+eY0IiAMQQdBURZ4cW+DRxar7vOmSuEUd2GXeFhQY3VfULwBr95prRndX5oL
         kX7XDHYVZLMVQkzhOTY9KbXcCfztjuoqLcW3NTuWF53RQpCSHKhxCZKN9ailNwuS2y6N
         IMiF8chPZagx+/9sKf2Dgytx3Ed9o9C1KOWozaHTBd5gLj8Y33BclieoUYHrSt4wixhW
         D2Fyba+dufjJRJCF5R7knykEFIt61yCcQDICfg/tjn5fVHW1rRulu/+yGOMYTC5JcsB3
         Y0skoqMoYyNiOAmPu6RQ6sptRObSR6bfNt0LQ95wA/5q8gboKJ0rEvEh1qyj8/XCjxUc
         Z2Ww==
X-Gm-Message-State: AOJu0Yxgv68zEbaZvP1o8uH/prIYSDI5g4rOZAgB9ZSRHnLGeY8n5eCV
	3sU9U3Q+STJ2JkkNTx+i6tHsuB7xUMT2gNIiZHA6MdQsGQ0QJDGqJo6Myzjhag==
X-Gm-Gg: AeBDiet+GPQ31gL70skEPM0Fm6Jd276Oq6RoPYk/mhjw3/7PNc4DxjTKP+HX3jTrPkI
	l9+a4utjxt2gyiH2BvGOuWKL5y6l6r/RPEZXGgVS5QnzX8+qiSoCzyukd3gDlUUrEvoDL+eK4jn
	kRvVYMOh8pNc9D3B1mH5BIL4A4ttWlHWSof7WJfos5q4V8RvHC3oSAZv0+dC+jSMZJpOzp2Zqbh
	6eFg9uZArq1nxlfQdNIHyt1PjIXxqqNPbVt0UbYjlvatOWEQsRuxFrfir/o+F4QNRpoEOuHdStu
	ZPQ3AGeFv3/VMphuY6UVsEZmko1mJAe6ug0KfyEtsBLHrk5kfpyCU9xgbC8rV8poW2MPdBFWGPz
	Z6X+OKgvahs3wS/G4wGo03NYxrSs1roQXrKZ2jbSEQgYvfLn1haXBNtSr2Rufu9T6ym7zMKT2GG
	ZO9GCmHkhnQ4LdJfzwAWTZbwS7typpVHRuQa4DG88I8gpBetWNCAc=
X-Received: by 2002:a17:906:ef04:b0:b9d:ec70:4ad8 with SMTP id a640c23a62f3a-ba422add0d4mr450706666b.13.1776608791646;
        Sun, 19 Apr 2026 07:26:31 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:31 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 0/5] btrfs: add persistent scrub lifetime and session counters
Date: Sun, 19 Apr 2026 16:26:12 +0200
Message-ID: <20260419142618.3147763-1-torsteine+linux@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Torstein Eide <torsteine@gmail.com>

btrfs currently exposes scrub progress only via ioctl which returns a
snapshot of a running scrub and nothing once it finishes.  There is no
persistent record of what previous scrubs found and no sysfs interface
for monitoring.

This series adds per-device scrub statistics that survive across
unmounts and are exposed via sysfs.  A new on-disk item
(BTRFS_SCRUB_STATS_OBJECTID, BTRFS_PERSISTENT_ITEM_KEY, devid) stores
14 __le64 lifetime counters per device in the device tree, following
the same dirty-counter/flush-at-commit pattern as btrfs_dev_stats.

Each device gains an in-memory session snapshot (reset at scrub
start, populated at scrub end) for the most recent run.

The sysfs layout under /sys/fs/btrfs/<UUID>/ and devinfo/<devid>/:

  scrub/lifetime/<counter>    accumulated totals across all runs
  scrub/session/<counter>     snapshot of the most recent run
  scrub/session/status        idle | running | finished | canceled
  scrub/session/duration_seconds
  scrub/reset                 write "1" to zero lifetime counters

plan is explaned her: https://github.com/kdave/btrfs-progs/issues/1108

tested with xfstests.

## Result

Bellow is table with results of a destrutive test, with two passes,  one  `dd` per devices, scrub repeat. 

| FILE                  | Total                   | Device 1                | Device  2               |
|                       | Lifetime   | Session    | Lifetime   | Session    | Lifetime   | Session    |
|-----------------------|------------|------------|------------|------------|------------|------------|
| corrected_errors      | 28736      | 13120      | 15616      | 0          | 13120      | 13120      |
| csum_discards         | 0          | 0          | 0          | 0          | 0          | 0          |
| csum_errors           | 28736      | 13120      | 15616      | 0          | 13120      | 13120      |
| data_bytes_scrubbed   | 6174015488 | 3087007744 | 3087007744 | 1543503872 | 3087007744 | 1543503872 |
| data_extents_scrubbed | 94208      | 47104      | 47104      | 23552      | 47104      | 23552      |
| duration_seconds      |            | 1          |            | 1          |            | 1          |
| last_physical         |            |            |            | 2147483648 |            | 2126643200 |
| malloc_errors         | 0          | 0          | 0          | 0          | 0          | 0          |
| no_csum               | 0          | 0          | 0          | 0          | 0          | 0          |
| read_errors           | 0          | 0          | 0          | 0          | 0          | 0          |
| status                |            | finished   |            | finished   |            | finished   |
| super_errors          | 0          | 0          | 0          | 0          | 0          | 0          |
| t_end                 |            | 1776595754 |            | 1776595754 |            | 1776595754 |
| tree_bytes_scrubbed   | 6946816    | 3473408    | 3473408    | 1736704    | 3473408    | 1736704    |
| tree_extents_scrubbed | 424        | 212        | 212        | 106        | 212        | 106        |
| t_start               |            | 1776595753 |            | 1776595753 |            | 1776595753 |
| uncorrectable_errors  | 0          | 0          | 0          | 0          | 0          | 0          |
| unverified_errors     | 0          | 0          | 0          | 0          | 0          | 0          |
| verify_errors         | 0          | 0          | 0          | 0          | 0          | 0          |


Torstein Eide (5):
  btrfs: uapi: introduce on-disk scrub stats item
  btrfs: add in-memory scrub lifetime and session fields
  btrfs: persist scrub lifetime stats to the device tree
  btrfs: hook scrub session tracking into 'btrfs_scrub_dev()'
  btrfs: expose scrub lifetime and session counters via sysfs

 fs/btrfs/disk-io.c              |   6 +
 fs/btrfs/fs.h                   |   5 +
 fs/btrfs/scrub.c                |  16 +
 fs/btrfs/sysfs.c                | 586 ++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h                |   3 +
 fs/btrfs/transaction.c          |   3 +
 fs/btrfs/volumes.c              | 239 ++++++++++++-
 fs/btrfs/volumes.h              |  79 +++++
 include/uapi/linux/btrfs_tree.h |  34 ++
 9 files changed, 969 insertions(+), 2 deletions(-)

-- 
2.48.1


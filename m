Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76ED369234
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393574; cv=none; b=TlCwvtowMH1xCkaNBgT9yYRIbUF7uO7pkUZoEKF2E0+BJ7rvdzhAuKm5oJ8imQ5aBmtaBP/P7W8O+BiXrWHBTo/JSrCg0UG0x039h8Gz3QUCkqnlggOutSOypPoTNYBdi/XJwMigKm6Jy4TTrfjpz6gurQTZWRs7s5/rs8t1DGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393574; c=relaxed/simple;
	bh=4cz7Sw0wk7c6IibS4ziQvSX127R7xc2QQl/YtCVQuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LYmCeCMGvfz+tddQ3gRZpAteayjWG46VFeZCax8Ii8d6DCd3JuN/Ib+NSOD+03ZvJ+MVgxmv+0saTfMSFGvAfMg8nN8BZ5N7LnHx+QVaZ4vosse9UeVHaa7ESdyAfVn8/J0sK+Accoss/FzKNuTUdUbBSVStEgfPmJSSgFx7Ex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dphq+i3u; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dphq+i3u"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae8177446fso14556815ad.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773393573; x=1773998373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xAHSRPaV5jntb8547c4X1OvbOQa+YH14qGnemS2ZEAw=;
        b=Dphq+i3uVTUOZjOn10IGGf87OVcOP1bdozTkTzypL61hUiLDHkbG6CcUFMWCPKCPq5
         Jctj5Sh/k9+QXiTGgay7zKgf/xUFV9/pSFOz5PHkPFLuMC3j1YGsSrY2McNnv3QIbeDE
         3a+XfP4S9pRMPztUrpB2s0W7SchAqCiqVRy1igbCw8VjF4rcHr2KX8ILEK8lnS/iVdQM
         0ngkJ4Mu82Euto4+RKJnpJJQN6N00QxFgMAgCu8fXd46dXiiCTqUj8xQlYl5YoUY4o36
         PBVQbPRWb6BjX0aA5kPDYlJzy0g5lXYvYrq9Vu3+/5oaWkbHeKo6YbXfnnAtnW5xHhhZ
         J/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773393573; x=1773998373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xAHSRPaV5jntb8547c4X1OvbOQa+YH14qGnemS2ZEAw=;
        b=fqCb9UsjT5c52MeF3WWbi8brju5eMuoHKyIzPIr3dK6ZBS7e1g5MhDBvHN5zNZ89GB
         GyuT7AHLtMlfKLq3VLLt8axPFDrMXT6sc7fU32DAT4pQHh6hZ1YuAxzfXcq+sOrvJSvZ
         F7DW7kJeUosneFiX6meXC+/J3oxZDpFQrAnIHvj6ioKly17dsImzqTv8DJ2w5CbGo5jh
         z9zh2tU6VS/UKA/WvjTi1DmsOF3rjO3GujHtra/9Jlw2EkerGhjbW8x+uvTxDFSAJs/R
         Y9EgTLzI08QGtj4tuUVDaCXsHzothy5c0SUXG+gFq/I6Z7vbLE/muW6xMeLifwX4E41U
         jVnA==
X-Forwarded-Encrypted: i=1; AJvYcCVOtiA4i6RvTyAhhDCFezMmu8BmcG569ZctF+qVrvih366LoS9my8lSkMeLQGFerBKRPsljRdTPpyBLIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbHxQg166rHy6ehnZttzShYdpag2F9s9UIYuBJyQWqP7BxyH5e
	IIYoJmsntdpIt8KgZUg6zBrDAzwMsvt8Wh90QwPOPX4npCH3QK4Gwvzt
X-Gm-Gg: ATEYQzzyHkCBZspeNDI41dHyF5ug2AkJf2jpM+XMQ7+F5pVt3jrEA3thKNdIko6pP+t
	k8iCV0NQSbb+kPOKfh1DCHCpU3z2zBEQUoiyJPm/po0/0MEGsDr2aZ2ZKI8pfgzay+Cf9koE9V0
	fxEC4jj9oigpjUG7M1D7okDpVP8NRbidrd3icocKk5PKLuYXWzx1KVKivTqgX85k7DevVbif3By
	cmeoDL+OqL3dYR6IgeHrAFrcjv2lEbXSjdxKUoG+S+Ywi19KCfwm2jzZjcPRo15JpFdkXWGx607
	iYo8ds3SDfov/lStuLyW7miQcVtqKftovRALZrjH4WmRvZxp1GY8PXnVVPpQVALQRvZk9P+Rl2H
	v/3BeXzmEU/hNiO7IBt2OBIRLnSU2SbdPPh3KrQuNCPqZ3kcGFZXoTwAIfhkeQ6dAK8dCRuF00Q
	atIq1meRZIlRUsYB0OGRjxjKyPmFSYT5HbwoDRkK/Do3FR53AWxbXf7ZT9WvU+e+teSCheHpI=
X-Received: by 2002:a17:902:db07:b0:2ae:d248:8f1d with SMTP id d9443c01a7336-2aed24891e9mr6001035ad.31.1773393573051;
        Fri, 13 Mar 2026 02:19:33 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee1d8sm16742135ad.55.2026.03.13.02.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 02:19:32 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: wqu@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2 0/2] btrfs: verify cached extent buffers against tree parent checks
Date: Fri, 13 Mar 2026 17:19:22 +0800
Message-ID: <20260313091924.570554-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a btrfs crash caused by reusing a cached extent buffer
without re-running the caller supplied tree-parent verification.

The problem happens when a tree block is first read and validated with one
expected level, then later looked up again through a path that derives a
different expected level from corrupted metadata. If the extent buffer is
already marked EXTENT_BUFFER_UPTODATE, the cached-hit path returns it
without re-validating the supplied btrfs_tree_parent_check. This can allow
an inconsistent btrfs_root to be constructed and later lead to a
null-ptr-deref during backref walking.

Patch 1/2 is a preparatory change that extends
btrfs_buffer_uptodate() to support tree-parent verification on cached
buffers. Patch 2/2 uses that support on the cached-hit path and contains
the actual fix.

Together, these changes make cache hits and fresh reads follow the same
tree-parent verification rules, turning the corruption into a read failure
instead of constructing an inconsistent root object and crashing later.

For reference, a more detailed analysis of the trigger path is available at:
https://lore.kernel.org/all/CAOmEq9U14a=pwN_dw2M70gfujhMKki434cfmegoxcyUpkYs5bQ@mail.gmail.com/

Changes since v1:
  - drop the adhoc root-specific consistency check in read_tree_root_path()
  - move the validation into the cached-hit path as suggested by Qu Wenruo
  - extend btrfs_buffer_uptodate() with an optional tree-parent check
  - make read_tree_root_path() pass its check when validating a cached root

ZhengYuan Huang (2):
  btrfs: add tree parent check to btrfs_buffer_uptodate()
  btrfs: revalidate cached tree blocks on the uptodate path

 fs/btrfs/ctree.c       |  2 +-
 fs/btrfs/disk-io.c     | 18 ++++++++++++++----
 fs/btrfs/disk-io.h     |  3 ++-
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   | 12 ++++++++++--
 fs/btrfs/tree-log.c    |  2 +-
 6 files changed, 29 insertions(+), 10 deletions(-)

-- 
2.43.0


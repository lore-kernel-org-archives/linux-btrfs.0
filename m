Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A57D3E2768
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747282; cv=none; b=jCxdGjXU/4Jbl1o0QK4KwobRHx+J07MPzX+s7wbU1o8EieB9Gh9+NuWlo0Cbol+e/TV5vAQrJW6m9L3r/I7fn25wEen0ER0s+QYA0Kfgf/+Fnc2WpWFUhU1Ik/x9/7WLfDI6uJk+2w2I3bOPiJGukhTrgi+sUgKvH3UR4kRG8GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747282; c=relaxed/simple;
	bh=mSlKojaJ/5BbVVbMlPvqSJumEQy5p12nXdcD/TldjSk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=nUk6ehZNkwrL3SQ1Lsbqs9jPUlsOYGzwtF/q5E43NL3yLdLsUREWxLOFTjeMth2tj0zwNKQP5DNDZ/V3c/CK7jM/DXMUvfvmLilzEsQMld20A/luUGtNTJoFYX8n4h1zBReIXYyXrdLHJwgBBKe9Vw+qztlhOOrfVZF5NqfEVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NENhho3U; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NENhho3U"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-16ad92569b5so1106704c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 12:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791747278; x=1792352078; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pnD0Hgtv2sGUnb5jt+kZQOEUFtoaln33lp1iRDSYtFo=;
        b=NENhho3U5lqPM+fYReD1DLaRbAmQbVhah0xAdBo9AucqXg6MsOl37gnfR6B/Tyixmg
         i3id/edLHCTpVmNCSQgfu2i4sgcS7ctHNfD3X6O+7DVYGu5aH6eENDGtH3cNG/meAVbf
         ictFhwbl7RqovjQDESW90cNPL500URgchT4B6mHpjMBKdebeLj66aWlXvZXwawXhKKvv
         ZQBWQ5WBpMOb+slmdnDiuxB4kxrwh2j+OAphJPisCY/zejWxeyxJQ6XqElfG9sGhwHpb
         eKZ+xMrXlpF+Sq6Zfmdj1QjCFQqdMwNDE0l3gEVnYlXXh1B1GF8ylabp7dQLts8VqOqM
         7Icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791747278; x=1792352078;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnD0Hgtv2sGUnb5jt+kZQOEUFtoaln33lp1iRDSYtFo=;
        b=WVP/I5a/ZunHuRHgxVDrmzzmIXsAhzfjhyOAASZdkg/zNVTZnCOiSKRzVln+MGzHHz
         N08Q72hq9Xlu4DLQ/7EoFWYFheClU0/s4Oc4EwjwzQejC/4cwcoEKTPivXCfC5jUrVUE
         cYpAgNES+89aoSLXk9mifWpfbivKr3YhtbjzaOqpUAklKPYDFyo8sbhVsXAumB1KwC71
         VNhgpRZwf2YdpSsWC205wu4MC5gztLuZcN9U7Lvo6nPzYQLZCmb+1MAv+RbkUZO82Cuk
         Y2V13xhVcEroe3dmjFa6RgF65NXRnp3DDdb9xPMAphLFIlfFtIJMMFtr0umsgcsgGBfX
         X0Bw==
X-Forwarded-Encrypted: i=1; AKwUvBzhsZ8j6b/omrJtRrymXNkcXwyANk8xpuz0d0MbdP00rq47uE5H2oH6NqpwCzU/T5mZg+JwWTr9/uatYQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK2sTNAeiV1/ghA8c8o1CkmVhpBIana54/+R3mqXUF+NM/SUB4n
	QGjzDVQnJ1eRZMo8XOyAda+mXe9JWo1D9NuSjV4l7IIbd6mG+wLuspeO
X-Gm-Gg: AYBFou2/xJqXg5kgN2k4XcDEsvoD+C9l6xGqh+8TLX6FeKudnIvE7S51f7gh7GmdoQb
	kgXfzh0eCM3jJ6PYUaP+rrVv0fVq2lUNeDGy4UQrd7zTAzVfaXWZICgwC29hpU1oPnN2fLYG6ZE
	H0YZtyZ1LJ0X7YdEk8ognZ2u4y6r4/lDz8MaKfjyJQ9H3tTBvjvSF24njkt0EYHGAZKAUdeAQM5
	oVlw8w4RFU69D/Ym/6Ar5vBtNE/sREInng7gTXNnAfchWnGFbhDm0z5L7KDWoegDK95gzWyprW0
	jeT4eAkEpR6UkRorVi1jLgAZqsLsFpwiHMWnXLFZVkACgE72NAhJGQkP8reBxeKr/eqhwUiHIag
	GUSUeEgsqMLePC510bI8XwZIA5No4U0Q8AYCNQ/VRwQz8duQDOYMr1smfktN9vSY5D49zNLtqPv
	UlRMD6qDIozyQ1f4RKcRs6eV6WYYVCKfnEdmLnCoaiwkbzvSnt8A2cWq6IESCIg5+mrMK9KkNoB
	8hjHKsD4AXrixcakqEIlWgawJdz/ONIcpkjYQ42wtNLG4rJAWCPN93BsZ0=
X-Received: by 2002:a05:701b:261b:b0:154:dc96:c1d8 with SMTP id a92af1059eb24-16a54ad2602mr14769671c88.2.1791747278258;
        Sun, 11 Oct 2026 12:34:38 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:bd42:ace4:1245:4b57? ([2406:7400:56:97af:bd42:ace4:1245:4b57])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a442ac67sm37177580c88.18.2026.10.11.12.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 12:34:37 -0700 (PDT)
Message-ID: <51964611-cd9b-48ad-b6ca-45373a96f64a@gmail.com>
Date: Mon, 12 Oct 2026 01:04:33 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH 0/3] btrfs: add NOCOMPRESS defrag regression coverage
To: fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 quwenruo.btrfs@gmx.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add regression coverage for BTRFS_DEFRAG_RANGE_NOCOMPRESS, introduced by
kernel commit 009b2056cb25 ("btrfs: defrag: add flag to force
no-compression").

The series checks bounded conversion and EOF handling, preservation of
holes and preallocated extents, and inline extent eligibility and short
EOF tails. FIEMAP assertions inspect every overlapping extent and require
complete range coverage. File contents, sizes, and extent state are
checked again after remounting.

Patch 1 adds the shared helpers and a small raw-ioctl program used for
feature probing and errno checks. Patches 2 and 3 add sparse-layout and
inline/tail coverage. The tests require 4K sectors and btrfs-progs with
--nocomp support; unsupported configurations skip.

Tested on an x86_64 QEMU/KVM guest with:

  Linux 7.3.0-rc3-next-20260918-btrfs-lab
  btrfs-progs v7.1
  4K Btrfs scratch sectors


Dhruva Gole (3):
  btrfs: exercise NOCOMPRESS range and EOF handling
  btrfs: check NOCOMPRESS preserves holes and preallocation
  btrfs: cover NOCOMPRESS inline eligibility and short tails

 .gitignore                |   1 +
 common/btrfs_nocomp       | 134 ++++++++++++++++++++++++++++++++++++++
 src/Makefile              |   2 +-
 src/btrfs_defrag_nocomp.c |  63 ++++++++++++++++++
 tests/btrfs/355           |  80 +++++++++++++++++++++++
 tests/btrfs/355.out       |   2 +
 tests/btrfs/356           |  71 ++++++++++++++++++++
 tests/btrfs/356.out       |   2 +
 tests/btrfs/357           |  59 +++++++++++++++++
 tests/btrfs/357.out       |   2 +
 10 files changed, 415 insertions(+), 1 deletion(-)
 create mode 100644 common/btrfs_nocomp
 create mode 100644 src/btrfs_defrag_nocomp.c
 create mode 100755 tests/btrfs/355
 create mode 100644 tests/btrfs/355.out
 create mode 100755 tests/btrfs/356
 create mode 100644 tests/btrfs/356.out
 create mode 100755 tests/btrfs/357
 create mode 100644 tests/btrfs/357.out


base-commit: 56c410ad0f69da5b13c5807bc47b4876dcfa02b2
-- 
2.43.0

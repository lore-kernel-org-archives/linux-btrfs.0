Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619126;
	b=Xt6YxmB51aX3pMuiGX8kvV2Phyz0LW9YMJBfs0104xTfJ9Lv5ASKulfRjr1XemUzh896
	 1GQlL47OMiRMe1GRJzCMCbuY1I8KAcv7XhQrt5mxjujV0Ffj76QYr6eakh2Ym9gB485zO
	 CXSfRkox4gqIa3AbtZDbi92cTQ+i7EgLPL17hDUVYUchT37YHLqF8eBLgehlCLkm6kkNU
	 vAHDUkLH+c8hHgy/yomxrNqUzN9SIPthqvyT2GXsGKimo8iQ8du8FSCjcccO/3XxsgY8z
	 cRFeBx9uAJRPLJo5aH0TaXeB9zgWMOTfSkNa2wySMo7BpoBWiY1bwrnLJHo10pJie7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LkkfOese71bQiC11vU9gNgC1ujD/kSIX7itoiGXpHtE=;
	b=zBaR1xXh6Wfn/YiUm9Oicv+LdlvMhfEKrMNKZW9ZtGRhJt4GPmbOHztfn7aAnnHHSOXj
	 ZEHZNasSx07pGncqexlnFfmwynj/CrT22dksDZG9nwqcXD3ufNAA+4PYeW83SMb7yGKBK
	 yt+0ADbzzhLAX/kQ9ISu9K3b1pcWtMumZtdrvC7GVA+CCz2/TH3Pi3Eks0DqiFvShM4HB
	 +zRW2SK59WrmAwRL00kwMhZH2sEt9n4SK6OusqlEGgoYb5WpDlOKRWARL1eG889Xr5cuK
	 ivVa1s17eXgXaku8THdxIteKkmSsHytZXKN5sDCsep0GwHCCUH5jmVS2QPJvZvMOg1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rrHX7rtn;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22312606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22312606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rrHX7rtn
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so4811555f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 07:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795619124; x=1796223924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LkkfOese71bQiC11vU9gNgC1ujD/kSIX7itoiGXpHtE=;
        b=rrHX7rtnD8RTVBjUKPF4wBBtpJmTSsaeZrOVG1RGIn9siMkMleZffeepMPlb6hWZtg
         qWGxeCLs4N6ziRnhsaJuEiG/oOrz+DLkHB/niuS9ImrGjIc6dlTEEzeFOnR1bJDoe8MW
         crexMC14f1YnsA02wMtbHSL0nWGeWjG8g8sL47k20+QQ9OQ2SDx5ZP/XNAbo1FHTAnYX
         wo5dsRPUUQ1q+0ffI1KViqfON+4cqThQpsFMdpWzB1QOyS0ycOCBM/EJATl6NKXFTnnA
         8Oaeq0zETze7VoL3tJeZUTRQqiwjapNo/XuleOOzrqieAV06on/6Kx5NDMjWQYicaFam
         NkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795619124; x=1796223924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LkkfOese71bQiC11vU9gNgC1ujD/kSIX7itoiGXpHtE=;
        b=Fomxaypfvi4gy4JXxeIfnEnq0U+Z5QSsSkvAkTct9y1Zz1nx2zMHJgC6ncGpNCjV2w
         Jjxqt0jqhYJxXMnFDo70Wdm/SU/OsF80lVSv0oj2N/Yfw7wpkXX1c6g+vKbxJoUuBTx+
         eGhJNQoVTRwa0rqr5tPK+iOKNy3/SE6uUTQIB8s40YcBW6cdVEc6vp90gg41hFUkBgKm
         +1m6dt/d0mDPHYIJi6kuFR27lQk8lEP4DELAK3tKUZIETac2/qSiiuWX3OvpR7RHCSHN
         ZiMmabIZBsby/GrLKZwK+33SRxkK2k8ZtFuhA+uFIpbld2oPb8EJVNVOBQHXWBONE0eU
         lAXQ==
X-Gm-Message-State: APuU4Z/WfMAhYD4ELUQ9ulwLE+F1mCF3GUa8vYitpKHhtdgtC52izsxB
	+13kn/ZZ2yw8g4y6xUMrLujTBF7CeN53bRIlA2MVN558D9bKBp/cdVx3
X-Gm-Gg: AZFdTZeZWFijK56Esv1siwKU3GPDRxKakkMV8zSm4MDY3nrnbDVFG89iEBsDwO+aHB1
	emScs4CFJwomKeW4WTFYwBEwHELF41fh+Q9Fp9iowoM8rnWSpnHGGhPUNZjx4U1NFuwtiJG1spp
	5Z1+Uph5itWz6mb4lyUSZCK2eN/oMamGc4VCEsJax8um3BcD7u2HXhIhkvQyjqab4pGGZC4lWfl
	Kqdsaar+lYcIq/1Z0AAZ3Omy2ZopOXOhrJ8rWiNfBjeqoK3yBU2Ex5M0KZjtcKOXlN8G/c4AFxL
	eTVeXRqtJ3e7WJHM0gOOCGXOEdi1PMuY9K4HyiEN2ylm40bdI9bZ3ujlB/iiL51gKh8KPKoOHIj
	76b3sQ/jf4XURdAyLkAbqXeN7KpC3k2QDkpSEMXjoZMnkC/ayqrJBqepV2jqVKkDtE90jfU4nsF
	ZGesTGxFqqVgmb7Wfa6JUyOc+q4plVZVUQi01fMlo1RTQ8uXcp9QbBdMR+2zFgD/aRjL5VHqGWJ
	yhn0lhkpClXoMFZXG1pVIJxZcxpNa5O7z+odEgTE6AlbxA+fOad3Ej9YPr/bbotl3Tw2M9uIzNF
	fya2i7BcrT16gAsDcsb0SyQ1rZPh2ekUJhek9+LB6P0Lzdvk6MIIWgV+N31t7H0AGxTkfmIm3kt
	iWCfuwXzNprTBLenf0Zy8HQWT/mvc0wrYNXtJFy20BXqZUZf7wgo=
X-Received: by 2002:a05:600c:3ba3:b0:4bb:7571:5743 with SMTP id 5b1f17b1804b1-4bb88813444mr416074485e9.27.1795619124243;
        Wed, 25 Nov 2026 07:05:24 -0800 (PST)
Received: from archlinux ([39.39.175.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm581728885e9.12.2026.11.25.07.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:05:23 -0800 (PST)
From: Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
Subject: [PATCH 0/2] btrfs: tests: fix dummy fs_info geometry setup
Date: Wed, 25 Nov 2026 20:05:16 +0500
Message-ID: <20261125150518.113966-1-abdullahzulfiqar580@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small series fixes two geometry initialization bugs in Btrfs
selftests:

1. raid-stripe-tree-tests.c passes (sectorsize, nodesize) in reversed
   order to btrfs_alloc_dummy_fs_info(nodesize, sectorsize), so
   raid-stripe-tree selftests always ran with fs_info->nodesize == 4096
   and fs_info->sectorsize > fs_info->nodesize on larger node sizes.
2. btrfs_alloc_dummy_fs_info() leaves fs_info->nodesize_bits as 0,
   causing buffer_tree entries to be indexed by raw byte offsets
   instead of (start >> nodesize_bits).

Tested by building with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y,
CONFIG_BTRFS_DEBUG=y, CONFIG_BTRFS_ASSERT=y, and CONFIG_BLK_DEV_ZONED=y
and running the full selftest suite across 4K..64K node sizes in QEMU.

Abdullah Zulfiqar (2):
  btrfs: tests: fix swapped nodesize and sectorsize in raid-stripe-tree
    tests
  btrfs: tests: initialize fs_info->nodesize_bits in dummy fs_info

 fs/btrfs/tests/btrfs-tests.c            | 1 +
 fs/btrfs/tests/raid-stripe-tree-tests.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.56.1


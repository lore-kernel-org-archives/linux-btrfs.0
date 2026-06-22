Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5C836F421
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 08:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782116572; cv=none; b=J74FTTq0n8GWESaeozzkIumDdA9pfSATaj34ssNCYxhB3Q7bz2BGkkm85kOJe0RzkYlnv6qyPAX3NH0TbMpsjbRPenvp0+7Nc6D3lgCiDz0UAuN24J+jnsHPmJkkPQt3zUpSoZTEeKBvvkbCTOOghFrZlvai9axSoXIO95ezuJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782116572; c=relaxed/simple;
	bh=Vpdj+BvkbLxPjLTjvO1y3LZzm7w4sOWwtwNmm1DDWkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n9nKtMhwyOQtttM9rRFI1yGKESyX6tPZaTry4l7kBACOKxNVrpC8FBIkfbuAhoqduW6YMxq5q9iQzO+WLz9c/B0Wi3eNT/utxmBbVVOOkTrpJS6nCl9xbXCHps+qScWOh4d/PR3CNAURHQ9Qjo/Vp4etzMmYFikiLJdDCQAYc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nme0qTg6; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nme0qTg6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782116572; x=1813652572;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vpdj+BvkbLxPjLTjvO1y3LZzm7w4sOWwtwNmm1DDWkE=;
  b=nme0qTg6KlBduLdUEjKUon1C8Ha2jRMWTnNvTcUlqNTGBbvdbox5LM38
   zfHbLxCidRBe7W/1TLjpKcCK6VBur0F4Pbnb7B07sWGjnPUbTOqj0Ln2G
   wgAAre/8zF0pwSHvFp1LR4fmdMniimF1yiD+6IRkZ0P/gQdbbFSGotrpS
   R1+EAZoc/mwEKsc+JCJhDdN2jmRmFjVMV4MzqrdWf6xNKmLybJ3Rd2mkm
   NFoxGvLT5yEUm1cD4vqNLkBncAOJjLyXteaRCRZioZ9pbq9ntK03XLyEN
   jPqrp7EARNS5qEyuR77OlGI3vcA/ve7Tc0V2O1nh13AugJ10uizT7jyC9
   Q==;
X-CSE-ConnectionGUID: s0TvdEQwRE+DjWNQyHnW8g==
X-CSE-MsgGUID: +dknLQJkS1ig8STgCQnuEw==
X-IronPort-AV: E=Sophos;i="6.24,218,1774281600"; 
   d="scan'208";a="149592552"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2026 16:22:45 +0800
X-CSE-ConnectionGUID: LWJ8fDw2S8W1t5e3ZpytyQ==
X-CSE-MsgGUID: grERTPznQM2VXT7DdzQhFw==
IronPort-SDR: 6a38f0c4_W7Ht83Ay0T2qhVo+vwhWxwAn8wMJvGZoFWSLopYkcpwOrxe
 hD/wLqBn2ltcepGpoeCz37XL9JdqgU1ZIcDM5wQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jun 2026 01:22:28 -0700
X-CSE-ConnectionGUID: M3737M8RSh+rSJVPAsKtvg==
X-CSE-MsgGUID: 0ovs62aDRWuSqcRYNuq0Pg==
WDCIronportException: Internal
Received: from wdap-5pxzmrbogy.ad.shared (HELO neo.wdc.com) ([10.224.28.104])
  by uls-op-esai2-o.wdc.com with ESMTP; 22 Jun 2026 01:22:27 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: decentralize transaction aborts in create_reloc_root
Date: Mon, 22 Jun 2026 10:22:24 +0200
Message-ID: <20260622082224.559980-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decentralize transaction aborts in create_reloc_root(), so that it is
obvious which call failed and what caused the transaction abort.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 Changes to v1:
 - don't assign ret in case btrfs_read_tree_root() fails

 fs/btrfs/relocation.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8cac49fa6f6f..73d9948b5382 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -720,21 +720,19 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_root(trans, fs_info->tree_root,
 				&root_key, root_item);
-	if (ret)
-		goto abort;
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ERR_PTR(ret);
+	}
 
 	reloc_root = btrfs_read_tree_root(fs_info->tree_root, &root_key);
 	if (IS_ERR(reloc_root)) {
-		ret = PTR_ERR(reloc_root);
-		goto abort;
+		btrfs_abort_transaction(trans, PTR_ERR(reloc_root));
+		return ERR_CAST(reloc_root);
 	}
 	set_bit(BTRFS_ROOT_SHAREABLE, &reloc_root->state);
 	btrfs_set_root_last_trans(reloc_root, trans->transid);
 	return reloc_root;
-
-abort:
-	btrfs_abort_transaction(trans, ret);
-	return ERR_PTR(ret);
 }
 
 /*
-- 
2.54.0


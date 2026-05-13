Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF541B369
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675798; cv=none; b=pvcfDZWdvf/j+rNvjxTThVK3Z7StymIQZXDwS9CsaoIhw/Gf2ofp2227OyBxvifoATVan5wUwnEkUf+/2NEgQc0RnCD/UQinAR/QcSQRBVJnt6gfqrzE6zv5aOKsCGPQOu9g4q+JzaYducY/BakYq0U6epx75BRn6gLaSY2J30k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675798; c=relaxed/simple;
	bh=3ui4rtSYEBAKgYVKs7kdE1N/QSUyXXgtBnXBglvKLEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMwxg/zogZP0bFZMUNZESfDEVreSQT2QsXnHMrsUOsPYFUU2qypkh1Tat/x4fIBnZ4gcg6WphnVlCNgQ4ReXyFgmDzBPfHSjEi+h1zLff6Xlx8A8zKzGVRX63HrpO8345VaeR/hSz2bTwc5woqeKNVYHajGuXvYxivxFJ9rjtww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=noWUj/U/; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="noWUj/U/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675797; x=1810211797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ui4rtSYEBAKgYVKs7kdE1N/QSUyXXgtBnXBglvKLEc=;
  b=noWUj/U/fXeJETxLGs34q0rwevuyk1wOSHyv2dyE8M+qNAe3wA7LIPz6
   ZT3D4d+okCvnu5yEfCGyTjOtVDuZdbb8PuY8Xm0MSGre+x58060woPjLT
   cj1Ncc6fq4FmAU1bfftohzhEHrUXj6y+MeSTqlbN6Kq8fXoraL8MIxOB/
   Bl6xZzy4bU0QFPSYwQ543uOESGIui7YdkuQOk9GZdFbzHm4botnzcPGQd
   jWDI4TcIM0wj+UWTTn2f0q2Q+Emnd2nieRCBlRmjlngB7HJYLUfSeBwsz
   svtT6fSn9ljEN37bL+FnS9rfHSG1lTzjJxy1w5OFTisYbEnrWsUE9rg9E
   Q==;
X-CSE-ConnectionGUID: BEU5JfetR0KNx/qRVzloWQ==
X-CSE-MsgGUID: 9MkSnRHkSrqyfvPQKcSxAQ==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869037"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:26 +0800
X-CSE-ConnectionGUID: lhw+gTujQtuEZ8b/roVq1g==
X-CSE-MsgGUID: NBtBzGyJTRSszxjEidfRmQ==
IronPort-SDR: 6a047002_PMSDpaCBfkIK/MJ+sV4O2+EXN1QjydQRz2ouNL1i/kB4w9S
 tLZadUKh+GJ+1/GZ6spG9K/MiqbqEONra8WY3mw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:13 -0700
X-CSE-ConnectionGUID: xQ/DXbyQQHCce7EXVAbzoA==
X-CSE-MsgGUID: hwA/isS1TRyj1d0mqJPH8Q==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:13 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in statfs
Date: Wed, 13 May 2026 14:34:43 +0200
Message-ID: <20260513123445.43197-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On zoned filesystems, space in block groups that has been freed but not
yet reset is tracked in bytes_zone_unusable. This space cannot be used for
new allocations until zone reclaim resets the zones, but it was being
reported as available space in statfs.

This caused statfs to over-report free space, leading to ENOSPC errors
when applications tried to allocate based on the reported free space.

Fix this by subtracting bytes_zone_unusable from total_free_data in the
statfs calculation for zoned filesystems.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a0dbc0d2213f..498aa3039fbe 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1752,6 +1752,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 					factor = btrfs_bg_type_to_factor(
 						btrfs_raid_array[i].bg_flag);
 			}
+
+			total_free_data -= found->bytes_zone_unusable * factor;
 		}
 
 		/*
-- 
2.54.0


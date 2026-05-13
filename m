Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1A1413240
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675796; cv=none; b=m1iRupUi5HPpfTR8/u4ezsAlqtWJELD/Da+5uSU2JAvOsYeQ+Nc+/B9eeXpuonPnKo/TS6DxxbqgYrdk2/iLk3E4Bm3ocVi/Kn+jG7ybVUZF/wdZYCwc5+zKXCnd7zjQoVDp/ZmxHdwrrZMo7Q8KZTZK/ribj5x83oUAQJzUtfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675796; c=relaxed/simple;
	bh=LSCcF5Ih97a3GlTQhpxvlbCMp05xa4n7iIdUq/EPGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OADjJpLttVIBp6/As/HrYCYx2dcisVxqcfqdDqlQR+6ycenVMAnUWaDGltIFGzyOzUr+Ep1XtpiBrAGh2kMVsI+9fShyDkDVLMvbliAfUTmHZNfB2J31W7FN1sx6EkffTAG/9ZvCazDZDm0aOhmCoL7hrMpcE/gSSW2mcElCpy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bhFDf4oS; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bhFDf4oS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675795; x=1810211795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LSCcF5Ih97a3GlTQhpxvlbCMp05xa4n7iIdUq/EPGFE=;
  b=bhFDf4oSDg5ZgAzzU0TVWwNYXR7kThbsNN1qdSA867+x8NtkZRit7NUI
   mv4XPoRj3PaIRGdDAl1xYc7mvHJDImtYeVFf8by928fZunhICVGdWwyq0
   NZ8gWHq6va8TgUyPg519Wd/yYz3TqudOYOcFql/xDVpgYO0YBpcD9HA3Q
   fh0oWJnLmt0gD1GZmb8tM0+w8YrSYn7zso3uxTidvSK5fOwyD4qOOWc6x
   lvZZbfl3Eu8TzFFiAMrP2+nxLk6GyXoY1za1siYWY0Ybi0/i9Lp2HzaCF
   5KnkbYi1FmOHnYHteuG4HRDIRKzdFGDF+xD4xldg9oNfxBaIaRZZplxhU
   w==;
X-CSE-ConnectionGUID: FOpWVZ2wTGCPsVAy0iFaQQ==
X-CSE-MsgGUID: 77RHP3AqQv6JLPXinFB5Jg==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869034"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:25 +0800
X-CSE-ConnectionGUID: 7Lz1FCiwQDORr78UQyiAoQ==
X-CSE-MsgGUID: Gev18YoFSia57+vvUeDibg==
IronPort-SDR: 6a046ffa_3+N5XLvNoPtnKxb2iOH9WYMXpkeWjdSywldXNb/Mm8uAhxs
 Fs8L5AtLhWb0WLs35zPPd2GaI2KF+KbxYsT9wEw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:05 -0700
X-CSE-ConnectionGUID: K2WfFAMwQWGByeEx7j0wvw==
X-CSE-MsgGUID: c7QcAaS2SA+YLrxoxm9GHw==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:04 -0700
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
Subject: [PATCH 2/7] btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
Date: Wed, 13 May 2026 14:34:40 +0200
Message-ID: <20260513123445.43197-3-johannes.thumshirn@wdc.com>
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

Decode the 'RECLAIM_ZONES' state in tracepoints, as of now only the
numerical state is shown in the tracepoints.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/trace/events/btrfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ec1df8b94517..ed272a100fa8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -101,6 +101,7 @@ struct find_free_extent_ctl;
 	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
 	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
 	EM( COMMIT_TRANS,		"COMMIT_TRANS")			\
+	EM( RECLAIM_ZONES,		"RECLAIM_ZONES")		\
 	EMe(RESET_ZONES,		"RESET_ZONES")
 
 /*
-- 
2.54.0


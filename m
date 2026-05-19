Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E633B6DC
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205784; cv=none; b=Dz7nk7MF/UoXaTKwLZfU1xVevrgzz/jsVd6lU2LWZnqGl8dnwfFdT5c7FJffk2QTnXlWzhEeAgeB1RxBxAnN8VjhsyM6tw9Y0sknRfnCih8DwOOsPdf5Fhbf0gGg6UFn7YcKQMGNCPYxOc7ZwiuB9q7twVqqmWmOTT0aE33+m1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205784; c=relaxed/simple;
	bh=LSCcF5Ih97a3GlTQhpxvlbCMp05xa4n7iIdUq/EPGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6uJWymPbAmE7BUCeWbz6V5z50WPlmOMojwyQwnmrlXw6YjgLYW4kEWcyn2GlWZK8PvCItJvNE+qtmgb5ohn1TwgfotKe07AQS78NFW2PkwaqKy17gI27iGC5A6fQ4TBW47fZ2BBkINJg7kO7y+11go7ZJUyjtgIt5OJjuTXpWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PUzRMytc; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PUzRMytc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205783; x=1810741783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LSCcF5Ih97a3GlTQhpxvlbCMp05xa4n7iIdUq/EPGFE=;
  b=PUzRMytcorr3gzEHMBge38vXR3Dx/lcY+FbC8w26LQCBNvqc/v9IQhAj
   6FWJCRMpYHHkxV1179b4ZGBAWNUI4hbDPaRfHa2RwrhpWwK4CBt89rh17
   cPf+lZYyd5D/LbMKI151EOceFpn6nQOJTF0OlF7bEmcaKOmU98DcE7tkQ
   NctbO+YLLpz9oa8FRF0wpcX6H/er2bJJIIhZ66+z+y6E1xwnijp+CQM+e
   Jw0ClimFqH3/SoWnVAjDY3+n+71QdGoKUez8CQnpn4i0kj2BsIFKG2Axr
   qAKbHji91hvXl3JSPlC18pq+xOxFWk2HxGUGEKmNU5Su22ofAUkftxUdR
   A==;
X-CSE-ConnectionGUID: U9wGkrMdQoqKlwDWTbkNbg==
X-CSE-MsgGUID: 5B8igN9FTIGu2pg6hrRJBQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146893472"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 23:49:35 +0800
X-CSE-ConnectionGUID: bmDaiyUVRzycJOP4Oy146Q==
X-CSE-MsgGUID: Uhxa93S9QxyGlH219xc2eg==
IronPort-SDR: 6a0c8680_2SmOTu7Nf3Mnrmx9IS9XE3bd5oPaYkvBwdjNQJmfOP3CPTc
 Fy6LKr05hluPp6poqtFEVGcuLkfmeqOKnOYAG5A==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 08:49:20 -0700
X-CSE-ConnectionGUID: htkErDdvSbu9exW5jJMT5A==
X-CSE-MsgGUID: eFVcppSRQFuN2hvYz4bsGw==
WDCIronportException: Internal
Received: from wdap-koukjqvp2n.ad.shared (HELO neo.fritz.box) ([10.224.19.38])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 May 2026 08:49:16 -0700
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
Subject: [PATCH v2 2/5] btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
Date: Tue, 19 May 2026 17:48:59 +0200
Message-ID: <20260519154902.223445-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
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


Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED433B5303
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779440594; cv=none; b=tqoGCbromOu3BUu1C0gPqBe0/dznl0QN96Pgax1RSPotKU7Q+FXAeN8Gv3WNa8fK+gY0YcVw39tW0EPIxTQPfHGYfqAgKOOGCRjWdM/phnMQo/qBS4TLVX1UO48eKlCJmowPf/Ss38cPsuR015MfnD4NemB5rnEMyp/cTdoTIMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779440594; c=relaxed/simple;
	bh=BLtATGShu6l9Wt9r5iBMBuBrZpqLc2eZ3b40x8BqzCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPCZT4NsWYQq43TAvsH99TliIKVQAP5+J51nNzaRm58+bGfLR2grfMU/Ms0hy7mncCQOtvTdqkn5wqaob63uSwF+NYZqOws/lR5eJzToyGwnvSZdYG2xmX1eCi84QNAxOk3YuwLed85BrQkrseOfOGIib29oRO/pKFF3rEdzva8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iLsY0gJo; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iLsY0gJo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779440594; x=1810976594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BLtATGShu6l9Wt9r5iBMBuBrZpqLc2eZ3b40x8BqzCo=;
  b=iLsY0gJoDB3HKKTvrg9fLQGcY5l6PudyXgvhQ2F8Ukelt3mdiHOZ3Tm+
   palOo29L704X3VCmggc0zPCB0kVNLJG1DfHaR2mZvKHEzqB/MOp5HPIhw
   sU5LVAzq6dTJtZeYSyVmubovQlRXRI4BGwgUnZGXGHrp4dUo8LGF6vVoT
   Kv1W6ZcI3pdE165FLFR20iKMYwH6a3UYuJIsLlGN4P8sLZ3OkytNMr8yI
   JdQleoMxlFFbdLPH+o+2J8jwci77nOhW4TPBjJE8cUGfejfnOlelBkcUt
   pyTsV1j2aT05CIyuIQQg8V89xJmA/gzCVvzgif0KB1BVcQqKzJj5JxM+j
   Q==;
X-CSE-ConnectionGUID: cQopwNVUQDOaS72HKy7cMg==
X-CSE-MsgGUID: HBc9LgezTQyQIKMXkmaRgA==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="147475591"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:03:06 +0800
X-CSE-ConnectionGUID: 6eNDWXUETiSqQF2sOduYOw==
X-CSE-MsgGUID: uBq/wdvySfKI5cAx/SUL1Q==
IronPort-SDR: 6a101bc7_LrCL+a2izd/FYJD904kGMiG5FL6SXTQxJhqlQR+FGEPr9cp
 h2fB1hDLRtxabH7nekAlU+Y7bJCqfg/+pHkNPDQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:03:02 -0700
X-CSE-ConnectionGUID: lAAHAOdwRiu7v/jcIIWQyQ==
X-CSE-MsgGUID: Prx+xHsEQBucFht8jPqKwA==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:03:00 -0700
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
Subject: [PATCH v3 2/5] btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
Date: Fri, 22 May 2026 11:02:44 +0200
Message-ID: <20260522090247.27445-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decode the 'RECLAIM_ZONES' state in tracepoints, as of now only the
numerical state is shown in the tracepoints.

Reviewed-by: Boris Burkov <boris@bur.io>
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


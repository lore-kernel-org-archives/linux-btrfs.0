Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BD633064D;
	Mon, 20 Jul 2026 11:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546355; cv=none; b=nTk0Ccuv5Wpc1gxqUzGkGvtRZkdzyzyIZpFciMQ7uuUmNwlfyGTqs38dkdU7dGUz/kXTJ4II5Gt3ibb8/8yeuRfAhDVzUCWJf0L+jr3XlS5qdVDIBPgrUwA4rskUUh/I00U68+gjmv1WQxY5dtuamPKNFmdm1tM81yvnRnGD8j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546355; c=relaxed/simple;
	bh=et2RKMJUv0Oo7iyCd6t5mfaDmcrRUNU8BK213aJ/isA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGxGjCeyEb/kFXKzHzqrrhNYwysm6M72H4pQkjr+iny5njTIAunDDI2KFEwoa02rLqRHuUa1lPnpV2Tlt+TxVA3wxUNzu8MKoPNujuyWBNVoGqS146TdUkQlZ73JA7bHHxBdAPm2lpk8a8YJar5a5uNXf2KPPt0pDruAMYRHReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=U5J3+6k3; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="U5J3+6k3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546354; x=1816082354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=et2RKMJUv0Oo7iyCd6t5mfaDmcrRUNU8BK213aJ/isA=;
  b=U5J3+6k3h4m/XQ+HHzBrtzaTwhN/M5r1ft+uh8GJmebpW5zuNmN3g5XN
   XxNdgIFJTKwCd2xqxl1SKdV/8rObZ1E4+nm8Q/pe8exSzpWIKIpl8fkNO
   zfTR6n3sYgg/L2XYsm8S7tnuSkO80nUY/wtDQ+fR2z93HA0VIA4oeZa9L
   IkyXdYuubqlrZ4tOh8orzgVGIkt+GSKfgFaz/yRcS0vjv6GkSuyJ/q8lO
   DAq32aVj7NYAkfbRA2bQlbTaNM1iqAc351Im37r8JUE/6OfrykCpBpgi0
   F/Uu54wAPW8HRufFW1DNaEbuk0BvF7yIu9gq2My8gWVath6ke95w8rGCj
   g==;
X-CSE-ConnectionGUID: npph7HYETkCbIAiFWUrFFw==
X-CSE-MsgGUID: PHOd7wolRVmBRAz22yvRaA==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105674"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:12 +0800
X-CSE-ConnectionGUID: iGMTrgjnQEWq7Inn5I9wmg==
X-CSE-MsgGUID: 9ilFN6DJS5eVe5W1FhSWNg==
IronPort-SDR: 6a5e0421_uRqFQG0wFLcxJaqSiOHOoKdWGBPAoQDWyC8pWTiGTPrV59W
 +NatK9k6EA8hUy1sLIvMT0PRJBjERJnPzsAu8Uw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:18:57 -0700
X-CSE-ConnectionGUID: k6+AeRJGTJysj/t1YYfmYg==
X-CSE-MsgGUID: tBmvAQYYSsG2zK5GWbOyng==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:18:56 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/5] btrfs/199: skip on zoned devices
Date: Mon, 20 Jul 2026 13:18:46 +0200
Message-ID: <20260720111849.1659111-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test detects trimmed bytes via the used space of the loopback
backing file, which requires the backing filesystem to support hole
punching triggered by loop device discards. Zoned btrfs does not
support fallocate/punch hole, so discards to the loop device are
rejected ("operation not supported") and the test cannot measure
anything meaningful.

Skip the test when the scratch device is zoned.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/199 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/199 b/tests/btrfs/199
index f161e55057ff..ec9f37830c2d 100755
--- a/tests/btrfs/199
+++ b/tests/btrfs/199
@@ -31,6 +31,7 @@ _fixed_by_kernel_commit 6b7faadd985c \
 
 _require_loop
 _require_xfs_io_command "fiemap"
+_require_non_zoned_device $SCRATCH_DEV
 
 # We need less than 2G data write, consider it 2G and double it just in case
 _require_scratch_size	$((4 * 1024 * 1024))
-- 
2.54.0


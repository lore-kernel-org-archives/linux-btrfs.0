Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C0E32E6BC;
	Mon, 20 Jul 2026 11:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546355; cv=none; b=irG+cf3kUqGFcgPZrUJZVEMaQZW2GWFHVJzfC8JBWxisiA3/TXOvpXXl+6V4bCqj1CF01H+FaNSJdlj8MSyY/QUkSuBbEQfgSKHyPGjN0IC27UhUZfC7fSPvbyNdMgRbjkhKBUoCh5ZpYkOpBc29B2DMscNDdh8VlZB4EzyVqkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546355; c=relaxed/simple;
	bh=nYo6LIe2gcgcSJopaZxE5XZ/WYGBQJnsEA4MBER7t5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwVDNRHSRZdrmIoidErAr7dGqoKLV4JMbqnL5XTI6lhAriOVr0kFc6D6xWb3VIUcnEBGGYOByOKOpxhgHoBvcBMzkRPi9nDlOeNoBIb8amnXbu1rvRxqKSQX3NKEPf0qk3Ji7Cgy7QFw0XL3Bsya+EFhHoOapGlmLE8OXGzoP2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mSv8fXmm; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mSv8fXmm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546353; x=1816082353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nYo6LIe2gcgcSJopaZxE5XZ/WYGBQJnsEA4MBER7t5s=;
  b=mSv8fXmmZabLfo4jzeIvPKrBRjKFg/8F8oIddYDDszmkl2Wirz2NxgfM
   OenS7yinfGym7o0zAhF2WOFkhPrlFaS/15SPZxyI5xKSuwWhxao3Y3jnB
   2zOOrDlfYcU2LAQjHcvGFabzUz8PcglOKdKkUpfLXDZZE78rGn7myLUXj
   oCwpasaygoSYzlG+70FRPHftZbEc5O+FAO+Ry/8YIndsn8e6jE6zfRYIg
   bQjjONQwmBXjzS8KFlNXI+Mmxl5byPn6f28IAkupk9l5JONX65Dgn6/OS
   1cXOcpG5nHTywalDvuMZ66vU9vuMUR3+NOeFRSW039lHq6L/0QJmQGVPu
   w==;
X-CSE-ConnectionGUID: C78x5/3ITCGgrXIT2/UWNg==
X-CSE-MsgGUID: dtFRs6XHTEW1EtnCUJ8v6w==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105673"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:12 +0800
X-CSE-ConnectionGUID: eegXvkoqQ0+fd9PPk9MxFg==
X-CSE-MsgGUID: sytOD3jNRliR3xRyK4OLTQ==
IronPort-SDR: 6a5e0420_kDaFUplvXeSY+jDLTkdNzsEZ6EdBX6ORxa4dKdZWTlXi44r
 JTtKuREpahOQZ2EbooIeSwYgPaMlSLGCTvSX6Aw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:18:56 -0700
X-CSE-ConnectionGUID: oy4DAY1sQl+mBwlh1Hdfnw==
X-CSE-MsgGUID: 35ki3IaZQp6xsScFOLTYlg==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:18:54 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/5] common/btrfs: fix awk field separator in _check_temp_fsid
Date: Mon, 20 Jul 2026 13:18:45 +0200
Message-ID: <20260720111849.1659111-2-johannes.thumshirn@wdc.com>
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

_check_temp_fsid() extracted the on-disk fsid with "awk -d\" \"",
but -d is gawk's --dump-variables option, not a field separator.
As a result awk tried to open a file named " " for writing and dumped
its variable list, polluting the test output with messages like:

  awk: warning: could not open ' ' for writing: Read-only file system
  awk: warning: sending variable list to standard error
  ARGC: 1
  ARGIND: 0
  ...

which made btrfs/311 (the only test currently exercising this helper)
fail. Use -F" " to set the field separator as intended.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 common/btrfs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/btrfs b/common/btrfs
index 30288f07b61a..d477bd9e38ea 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -980,7 +980,7 @@ _check_temp_fsid()
 
 	# on disk fsid
 	fsid=$($BTRFS_UTIL_PROG inspect-internal dump-super $dev1 | \
-				grep ^fsid | $AWK_PROG -d" " '{print $2}')
+				grep ^fsid | $AWK_PROG -F" " '{print $2}')
 	echo -e "On disk fsid:\t\t$fsid" | sed -e "s/$fsid/FSID/g"
 
 	# Print FSID even if it is not the same as metadata_uuid because it has
-- 
2.54.0


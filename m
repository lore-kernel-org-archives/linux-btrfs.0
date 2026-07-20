Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D4232FA1B;
	Mon, 20 Jul 2026 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546356; cv=none; b=r5awH064LQIld8KY+FSmkb9dlbVL7QQ47XECAUU7Cf3kh4LhpAuS2m6aFvlqE1SnfFsPEdRBa/EUq6I/ELR317K7LuFdozUuNsphQYfDaFrNhImlNtXCdnQRJ5Q9YMOQJ63puFEjpPZNLjpZg6H6frJRZAPF9PrBJvwwMATetOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546356; c=relaxed/simple;
	bh=0aH9HFjOGhxt4TUGrGWDZj7UvOsNfPyiCuPawssXhc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjcniGS6b6J4aw6XT/LckWU9n0rvYD7ye+sQafcTwX0T86KEFY6M0Fa8JWZ2fRGceA3KuxUT65GJwoYMi11xUukmLJsBKvoHDhlAFE7l02TbWA7x35WcMKVx3UeTf6URDRgKbR3j0d9wVbOw9O+Pc+5L+Cp1cz6BtC/uKZlLQgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZsiOFVmL; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZsiOFVmL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546355; x=1816082355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0aH9HFjOGhxt4TUGrGWDZj7UvOsNfPyiCuPawssXhc4=;
  b=ZsiOFVmLKsQJAsEm2HoJfnaIeok9p1g0nnRJE+TjbNZS2Z4J7x7dbaQd
   sw/T9F7nFEYb+FiG0MgRj70S9d0htwOkAkyTi75DEtZ7AC58+wI0c1uUm
   o1+m4/bB9zNZwYPTl2njcOM1vK5QlRngzjFkZbFVLeTs6zrkQkCAlb6bh
   Aa78R55WjryvcZk9O+rjMljQW4K3e/Vp4NytQtUln/DPkKaKNlAxc/6Wt
   W1hRXn0uj8r2aqs8X3RTJBfIubrmzEY9kCj+AuPbCqTJG6ux+cS7pNcWx
   J3ND+1djp3Kk7y/8gi6OzBQqMj57sViSnCzJM1JQiB04Q+kBS9gzRyU8u
   w==;
X-CSE-ConnectionGUID: rcSQ/z2rQ9CAscFYwBP0Pw==
X-CSE-MsgGUID: 62WAZFQpTzCAqnAC/SCT0w==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105675"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:12 +0800
X-CSE-ConnectionGUID: ggst1ZGrSN2itmwWW2PuGg==
X-CSE-MsgGUID: xA/8l6aJRtmi0UVkQ2iA6A==
IronPort-SDR: 6a5e0423_rAokqe6jgM3KeNywXSybgdf6mJTx7Zt5YXCHjiX03tVkq0L
 tJXiXEsmZy1VsiIx7LduQYi7IOQDjl1WfzH4KKg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:18:59 -0700
X-CSE-ConnectionGUID: xOb9xHAHQ3KOllLp9kcAsg==
X-CSE-MsgGUID: o017ySCERO23NkE+UMab1g==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:18:58 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/5] generic/746: skip on zoned btrfs
Date: Mon, 20 Jul 2026 13:18:47 +0200
Message-ID: <20260720111849.1659111-4-johannes.thumshirn@wdc.com>
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

The test relies on loop device discards punching holes in the backing
image file (holes are then detected via fiemap on the backing file).
Zoned btrfs does not support fallocate/punch hole, so fstrim on the
loop device cannot free space in the backing file and the test cannot
work.

Skip the test on zoned devices, but only for btrfs so that other
filesystems (e.g. zoned XFS/f2fs) can still run it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/generic/746 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/746 b/tests/generic/746
index 4eb4252b8ba0..db4e40d5cec7 100755
--- a/tests/generic/746
+++ b/tests/generic/746
@@ -11,6 +11,7 @@ _begin_fstest auto trim fiemap
 
 _require_test
 _require_loop
+[[ $FSTYP == "btrfs" ]] && _require_non_zoned_device $TEST_DEV
 _require_fstrim
 _require_xfs_io_command "fiemap"
 
-- 
2.54.0


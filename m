Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0941330D23;
	Mon, 20 Jul 2026 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546357; cv=none; b=m6IIiQnloilIMXx2vBwP2O5xoC7NK+D4fynTxprW1/muN1LQkD3pDkCjj0TdqmL5bEdKrmJHfIpP1m8KQrtVI9igy1BNGsG4Q2ishZLTveyypgvnk/1Qm7fbqfIpDV2Y9B+f+8qvddU9gBnRWyomBKPN+Xz6YO+ff/FmrxOb6v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546357; c=relaxed/simple;
	bh=Y1YBgo08FtWEigGjH3kjEosWN+xAd9QGJh8ulgdbKh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj/SVYBOme7VtufNr3w+EEmF3YxoYJ/3v0zbsDetbJQALou4K+5F/9eGzxnWa14EVPt+MFFqbya1XXCQ/XR5o3/bzo0VuV1FeBs/SMQ/ddnKhl/N72QOFhsD6nyKk0ZmGa//0GSE6LIzSAaUYOE4E+w6vp8Pz4YZuSC84Yr6Mfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jLisB1Ho; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jLisB1Ho"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546355; x=1816082355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y1YBgo08FtWEigGjH3kjEosWN+xAd9QGJh8ulgdbKh0=;
  b=jLisB1HoitqntPOUJe4Nz9x7aPtpiZanoHQzabDjCIrhVzhR7P3zuicN
   trDyfQp/q+EjOxvqhCYw8To3VGvsi/Vscvr/dzilvwgkO0bwfIRx8U8W/
   7opKS/2Es234JOaflWZmL3nRbqdoJkaZs++YiKhgW1YgaZg9PNitb3h9V
   dkdmhjNzWXG6x/7BjQbVZSc1T+oc53mhaE4BBcay0xen9rxhv7qIaWyYF
   uIawhbXln6m9XKhheYiuTwUg4GvSEUzLio3EoUrFDCZ1KcSgnvptnncSA
   5kC4eWRZ0NY9CZiFjtqcdEGOFGkiANfbzzXY78YtdtrTtEVZvJaafx0DH
   A==;
X-CSE-ConnectionGUID: ocnSA1fuT9ClAHesbzmgKQ==
X-CSE-MsgGUID: WZ++tu2TTtKInk6vBW2ahw==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105676"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:12 +0800
X-CSE-ConnectionGUID: Naxks2JwQXWAj349TVQt7w==
X-CSE-MsgGUID: N0WogduGR/2vS18p5Aygdw==
IronPort-SDR: 6a5e0425_z6YHEZRDeQDvCVnw5evMzbWD9gOz1twTYtS7sB6D1COqFLw
 AABlnrrgeFClcrYMXFoIWlulbSSVPfZ0xyNVytA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:19:01 -0700
X-CSE-ConnectionGUID: NZvFvY5yRH6JTJuCsZWSog==
X-CSE-MsgGUID: Yjybid1kQ5WG9dfxkq/C1g==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:19:00 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 4/5] btrfs/284: skip on zoned devices
Date: Mon, 20 Jul 2026 13:18:48 +0200
Message-ID: <20260720111849.1659111-5-johannes.thumshirn@wdc.com>
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

Incremental send stream v2 uses fallocate(PUNCH_HOLE) to represent
holes, which btrfs receive replays. Zoned btrfs rejects all fallocate
modes, so receiving a stream with holes fails. Skip on zoned devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/284 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/284 b/tests/btrfs/284
index ec3bc2720935..fc34df88baa7 100755
--- a/tests/btrfs/284
+++ b/tests/btrfs/284
@@ -17,6 +17,7 @@ _require_test
 # least $LOAD_FACTOR * 1G, just to be on the safe side.
 _require_scratch_size $(($LOAD_FACTOR * 1 * 1024 * 1024))
 _require_fssum
+_require_non_zoned_device $SCRATCH_DEV
 
 _fixed_by_git_commit btrfs-progs e3209f8792f4 \
 	"btrfs-progs: receive: fix a corruption when decompressing zstd extents"
-- 
2.54.0


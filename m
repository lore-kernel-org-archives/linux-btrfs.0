Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87673264C8;
	Mon, 20 Jul 2026 11:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546353; cv=none; b=BYOZyjAzKAlMP3jKVwHQUx8ZqohaEtUXEfVf+5srmvJZGpMKTEYhSy49Lhm4XI8tvIpp6XopubFqaXuoKG1hUorsQGfzVGdWkUvbCg73GDleg7xP8ABK3/HmyXMN1UoOUC9Ot82WCkLr+K29qVnGAbrvj1VNToMKkMApleVNl+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546353; c=relaxed/simple;
	bh=1xHucqtd1PBrXO6vAvwjPtkUcWoPh92zTZT0duj9aLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WvksEd76pW7wQDc+AokjynIVEoxD70MCC7YByAsEJXarqc5OZCwvKv9ylxIG7/IxZPak7VwEHMEYhIOJsXXimj4EzRfQcQb/uC1YTzofeAFKh8egSzbSjg7GM500kLFY/hkwwm4MtOe4ApOC6PJWh9vVGvc8hFdS4r3Pwwdl7ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aY6pndjB; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aY6pndjB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546352; x=1816082352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1xHucqtd1PBrXO6vAvwjPtkUcWoPh92zTZT0duj9aLI=;
  b=aY6pndjB0CALsApuQK6bR6H9LjwucY0yUHSoi7NHXD6YqANeETdEJj9n
   LGOPH8nSB1a9fTDnD7YlXlSj7NORTaJ8Mz07uyNtt9uI+22lHn4Z+mMz7
   kUjTfpieaqIDHCgSkE9Cd2DvyJ4TYs/ZIzqm02nNdfIkr2JTubZHw0nXD
   hFBnyZKPDVHhrUsyaB8jMS2JzraxeNsVWU2DkqHWxlo+0eHZ01KkkattL
   Q96gZrRFAJVaXuXTrCDu0+xy161PWmel2bFOXe2mxTjYWaOu/CfobzWSA
   aOmcEd+GjoDACGI++NZZxt48xjvcMj8diGV/wJRtjmNImVi5PzXNEz+1R
   w==;
X-CSE-ConnectionGUID: TQdhdZpkStaF7DuzT47l6Q==
X-CSE-MsgGUID: 3aE7AKtGR0OnfNR7EL8TsQ==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105672"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:11 +0800
X-CSE-ConnectionGUID: ka8TT+o6QqiQqirRddEtEw==
X-CSE-MsgGUID: 7OxnC1MOSfWE1QxFQKG6rA==
IronPort-SDR: 6a5e041e_J6Z2PmpEg7CA3L43W6m3TBGJL0k3davINzkm2jJ2F6Tyzs6
 D+CzdEbjVB879+ieOTmlNMvVCdjwuqeJVj1BnrA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:18:54 -0700
X-CSE-ConnectionGUID: FBMYS4tyQEW29zSuGZ4f6Q==
X-CSE-MsgGUID: B13ENiYNStKOXAbbJCWPZg==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:18:53 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/5] fstests: misc fixes for zoned btrfs
Date: Mon, 20 Jul 2026 13:18:44 +0200
Message-ID: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Misc fixes for test failures (and a typo) when running fstests with
zoned btrfs.

Johannes Thumshirn (5):
  common/btrfs: fix awk field separator in _check_temp_fsid
  btrfs/199: skip on zoned devices
  generic/746: skip on zoned btrfs
  btrfs/284: skip on zoned devices
  generic/781: fix copyright

 common/btrfs      | 2 +-
 tests/btrfs/199   | 1 +
 tests/btrfs/284   | 1 +
 tests/generic/746 | 1 +
 tests/generic/781 | 2 +-
 5 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.54.0


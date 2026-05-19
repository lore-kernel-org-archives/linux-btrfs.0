Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E103CF025
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 07:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175020; cv=none; b=hnzNW9JpiPG6PVbR/J1fu1+DmRuUu0MHx5a8q78of6Z19TzpG3rLvsqx5j+ohihTWRmOzeIo0T4eH7m1Wlz9dR7fgHfb+RL/rsxyn9YoJ3pAbhXp3BXO2lvEb26nEVeAGt6TBlH8Bb9NnzApbwkR8peE30GIuRX3c+k5EwbcQuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175020; c=relaxed/simple;
	bh=yfDSLK8RnLO5RVf+nlXSFdKC4dE6AbKZPgVEogbeWwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i0GhWENKffTLebcvaf9Nrw4oAxlYfs+WuQL8b+Kz21zJCPQOYGs5X45bVuWxDHAMSTmkS5U/hS3ptpg8fglazuZHNcBmQY3HMmF3U/gqGjNv41kL+9gXhQ79f3zX6iNb+y7dJbsfj5b9RA4QIhbdcHdkz3DuHxV7CuhAaSn4T2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=McqrRPNJ; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="McqrRPNJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779175017; x=1810711017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yfDSLK8RnLO5RVf+nlXSFdKC4dE6AbKZPgVEogbeWwM=;
  b=McqrRPNJXMQy0ZM8iFnXjPEL5uImN4gdl3MqtOSUr2ALBolIJJNBl+m9
   U4liHYfycIbYs5yIBy6I5gTOulc9nWSOK5UTDK5LrBs6sWtNwoDa2T2HG
   RweGM8U0bJb/1YSOubEoBtZHmYM3MoGhHgPoqnD/JuZd5G7IsJK3C6r8d
   37lQlDNl7Tb/yBGnK4fNKzLa1KyOsKWngRqxbRLpclQq8BY/sezG17Qkn
   6t3C3bqPRxCj2oWnIUnusGYFFbLHhfAS3Il4Ezlt/+66KPgwO3/rsoBDn
   XNjTrYj8h51HwXMsb4zVU7G8kZzJ+AsWXTt+NX+VUMOJesSMYIprzgb70
   w==;
X-CSE-ConnectionGUID: 7JkCxaquQ+GYVFD5CNfj/Q==
X-CSE-MsgGUID: vWKN5nEfTci5XerUuCtdaw==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="147243128"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 15:16:50 +0800
X-CSE-ConnectionGUID: Ut2zih/BSmu93vPRkqFF5Q==
X-CSE-MsgGUID: br1syrO1SGK7LJBN0epUow==
IronPort-SDR: 6a0c0e4b_pTYOZQmqZCLtSuaALrO0uDEqCW+BGWvDBJFcK/H4o98GK0E
 xl93SxQ+9yyfLlY3notceZWhTAcuwXTTIl9b7Lg==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 00:16:27 -0700
X-CSE-ConnectionGUID: x0P+TZy0RAK6irVrsDsj+A==
X-CSE-MsgGUID: rUeSlfPxQRKz/boTSo4BaA==
WDCIronportException: Internal
Received: from wdap-io7kepqecw.ad.shared (HELO neo.fritz.box) ([10.224.19.18])
  by uls-op-esai2-o.wdc.com with ESMTP; 19 May 2026 00:16:25 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 0/2] btrfs: zones: fixes and cleanups around max_active handling
Date: Tue, 19 May 2026 09:16:19 +0200
Message-ID: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One fix and one cleanup around the handling of max open/active zones on
a zoned filesystem.

The fix is for devices that do not advertise a max number of open zones
but have less overall zones than 128.

The cleanup just reflows the code so we can get rid of a goto.

---
Changes to v2:
- Remove the now pointless 'if (max_active_zones)' before validating
  nr_active <= max_active_zones
- Add patch reflowing the 'max_active > nactive' handling

Changes to v1:
- Check if the device has enough zones to run BTRFS
- Move all the setting to a seperate function
- Never run with less than BTRFS_MIN_ACTIVE_ZONES
Johannes Thumshirn (2):
  btrfs: zoned: always set max_active_zones for zoned devices
  btrfs: zoned: reflow max_active vs active checking

 fs/btrfs/zoned.c | 63 +++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

-- 
2.54.0


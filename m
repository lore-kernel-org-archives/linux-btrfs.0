Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124429;
	b=mR9x8F5P+5VWKE1K1c6O5neKX7hhDvD32+WTJVblL2ny6/C6s216rPh4dWnXQ7NMeSV/
	 22NxHbCwCwliQzHAbihZzyi4K66fo0fUDXVGwbw36AYJ57J2NQEkqmoaRavuQsj24yGpy
	 8hH12gTNqjmRUpyDZyygvNvMkoZBXei2wvWA2KkvU2bW0maXjrgQO9ClGypVtbYyKTAmS
	 Lt9nghOjZHlOfPn/K6E/o3l8RXaxgY3metuBlh5vkJ076NJsXe+r4iVXTh25Sx8RMznXM
	 LDLQmeDSojYa73nqVvqyvQIg52ieSOVMZVjOcK2HNtkzNNueFgOWF4MXoG4tFLvYP5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124429;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tmPcp/mcIivD6SjON+/+hxgToEcYqUASXdP0oo/Y9mw=;
	b=FQolOcMIaIbJa5TcxS0RWy5RgjTuXPD1AkqHUtU6Lde0YJYSHaeluB9B4w+uiwfy71VR
	 kqD/NeZGQSp09AzvGNpf6KSq9hL2dYMsOwfuNveUQZAO83xdFhZoGFd29TsIjyWtQWjRf
	 RE4GfjXSo6VKmGjtmZrC3QR438JGGpyuuZRWbLXD2hjc4ZqFuS1kh8fLsiu8npGHNXoQN
	 aWZM/RMbGVLJsD/xTNgH4AroZoIoTXn1wEpLSTbg38r0rrp3YAC6ibmzkVJ8yoh3XUZab
	 aLcj+aMbHsBCrVrKe6n4yrZPfhrxzH4X/WIV15FC+d5BSuqYMrT1AQIgmrXi7tAZCmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Xz5HJEJy;
	arc=none smtp.remote-ip=185.70.43.170
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7F260A2624
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB7F260A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Xz5HJEJy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795124426; x=1795383626;
	bh=tmPcp/mcIivD6SjON+/+hxgToEcYqUASXdP0oo/Y9mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Xz5HJEJyJsqGcSu7UH/Iqge8SmtNhrTtwChzZHUdM7CxN8T+poagZZ37SySEzaWVF
	 OevBKGPhJF/uB8VeoiR9tfPiCcxvY6lSg/vEbrCxfwuSLIxscZycoavPzlLxfiKJ7b
	 sTGbZR1NhPgTKDIGtRJ6AyKRi+Svz/6TJiC9A0uRRTYOkmddPey9Owx59oaT1PMMan
	 iEACoEvBcenV8hESM5b5Xj0WxQr+xzxh+z2+oyCaBkog3laZBNSrrZYTJ/zeJMihy8
	 i/YbvyU8D9DNDl4SXNMZkQzzlje7AevMEYBv9Z5fo3LI3+orWVi8H11wZYY8uTXME4
	 tVtB0LM1ly5Eg==
X-Pm-Submission-Id: 4jVsMY2nKBz1DDrZ
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] btrfs: zoned: take the RAID1 zone capacity from a present stripe
Date: Thu, 19 Nov 2026 21:38:34 +0000
Message-ID: <20261119213835.103131-4-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119213835.103131-1-mc@raidlab.org>
References: <20261119213835.103131-1-mc@raidlab.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_load_block_group_raid1() takes the zone capacity of the block
group from stripes 0 and 1. A missing device has a capacity of 0, which
min_not_zero() skips, but a RAID1C3 or RAID1C4 block group with both
stripes missing gets a capacity of 0. Once it has been written to, it
fails to load, and a degraded mount fails although a copy is left:

  BTRFS error (device nb4): zoned: invalid write pointer 98304 (larger than zone capacity 0) in block group 83886080
  BTRFS error (device nb4): zoned: failed to load zone info of bg 83886080
  BTRFS error (device nb4): failed to read block groups: -EIO

In that case, take the smallest non-zero capacity of the other stripes.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found in an LLM review of the previous patches. The fix and the commit
message were prepared with the help of an LLM, which also tested it. I
reviewed everything.

Taking the smallest capacity of all stripes would also cover a third or
fourth stripe with a smaller capacity, but a block group written past
it would then fail to load, so it is not done here.

 fs/btrfs/zoned.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8bd44dd260a4..5722e16a5432 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1535,6 +1535,12 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 
 	/* In case a device is missing we have a cap of 0, so don't use it. */
 	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
+	/* RAID1C3 and RAID1C4 can miss both of them, take the others then. */
+	if (!bg->zone_capacity) {
+		for (i = 2; i < map->num_stripes; i++)
+			bg->zone_capacity = min_not_zero(bg->zone_capacity,
+							 zone_info[i].capacity);
+	}
 
 	/*
 	 * When the last extent is removed, last_alloc can be smaller than the other write
-- 
2.53.0


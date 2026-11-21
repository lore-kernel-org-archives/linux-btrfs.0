Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268764;
	b=XXWE16AXVjqiYg2tUs7pSlsynGAKZiLvbnIJS4AC7hJLa4pBqQP7wkbCBOgQ9jHwF3L/
	 r/RfRl7PcoWStmgPEZEMHWnA8ubWy0XN8y0WkkDLpLsnkAB+/8dPs9x5VmZlAwrh1aoOZ
	 qg24jK8BV3meJ3t89mLz3pW5sntjKFnDGYEgul/F3+HM8OcriUKuEb6FJ4aJWqPkegqcj
	 LBRF+eLz7hgLxwGD7CQ3gKTAhWl9qZugQp4amcMFykvFfWEn+uXYkYQPDbX/DqqjXBD3H
	 Xorodyq7kNM8vSmYM0qI8MWIklZRHEu5TjNBKCHCfsLM3PNWvz9CcTs2/Lt/9huGOvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268764;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KOi2wOpsCeFttSg4VUy9msZKraS9/DHr8unBbUav/ZQ=;
	b=qTPZ4Wx8e7OKolXOq1skX+njlR/lIioV/s8fIxHAM6h6mhnU/1nsTc8GKsxGLWJfHwDi
	 jeRZXxtCipcg212/tmTXJdbFx9T5nHtW2mRQYEdBehrlGBXM1KUsT1rv/W3fjW9/iE15r
	 JE7hy7aPleRpeaeTSf483eQsjO8d+Qo8cjlLTLPkNLkubiB63ClYeCSukv53k6qsvvdxo
	 u47T8Et+trqn+JIUkxMYLX7/bE8jVEbPU9m6r+GsOwU0GVGCt8j/7q729wM9qBwnO21xZ
	 6pGR3ef281ZkH6lrQTb4BqdQGCxUfwQWe2kxNyRvLh9N0V9GGLfX5xGYIIuGvL3aNeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=H14+ixoc;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8DD606A32C
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 13:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF8DD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=H14+ixoc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268761; x=1795527961;
	bh=KOi2wOpsCeFttSg4VUy9msZKraS9/DHr8unBbUav/ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=H14+ixoca0WY3hpTVk+p4/T3t89X/qrzjQcmbdOxp2ism3hCW0izi5nXTN+C5p1xY
	 z/YAN3CeaUyWbbi2m+8Gpvhwq0zPBxi/zG243rPhXOYQL64sH1svkYqeIvRhrv+ZTv
	 PkZuKZ97dlNhKhGAs6lVBTOQtvPqPr508XOdXC85dXMxiSQ8aW9Kxz/hNGwiPFPS04
	 L87cZ5VbpaiqIvXXbQC+Qs1rgInrcaKtwpgsA5lgJMztyRf2uRwlLTOXbZZ1GU1Oke
	 xS+WAekBiWUtCtMZWUS0/nOs01BaWziLPAZzybKrJj2crLnbFt7+YaUPVZ6mJHa+7A
	 CnwHH8ypC9lNw==
X-Pm-Submission-Id: 4jWtlD1WK8z1DDnv
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] btrfs: zoned: take the RAID1 zone capacity from all present stripes
Date: Sat, 21 Nov 2026 13:45:46 +0000
Message-ID: <20261121134550.216217-3-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261121134550.216217-1-mc@raidlab.org>
References: <20261121134550.216217-1-mc@raidlab.org>
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

btrfs_load_block_group_raid1() takes the zone capacity of a block group
from stripes 0 and 1 only, also when it creates one. RAID1C3 and RAID1C4
have more stripes, and that goes wrong in two ways.

A missing device has a capacity of 0, which min_not_zero() skips, but
with stripes 0 and 1 both missing the capacity is 0. Once the block
group has been written to, it fails to load, and a degraded mount fails
although a copy is left:

  BTRFS error (device nb4): zoned: invalid write pointer 98304 (larger than zone capacity 0) in block group 83886080
  BTRFS error (device nb4): zoned: failed to load zone info of bg 83886080
  BTRFS error (device nb4): failed to read block groups: -EIO

A third or fourth stripe with a smaller capacity is ignored, so the
block group is written past the end of that stripe's zone, and those
writes fail:

  I/O error, dev nb2, sector 122880 op 0x7:(ZONE_APPEND) flags 0xc800 phys_seg 2 prio class 2

Take the smallest capacity of all present stripes.

RAID1C3 and RAID1C4 block groups already written past a smaller third or
fourth stripe failed a regular mount before. Now a degraded mount with
all devices present refuses them too, where it loaded them with the
larger capacity. A degraded mount without the device with the smaller
capacity still loads them.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
v2: was 3/4. Takes the smallest capacity of all present stripes now, not
only when stripes 0 and 1 are missing. A smaller third or fourth stripe
was ignored too.

Found in an LLM review of this series. The fix and the commit message
were prepared with the help of an LLM, which also tested it. I reviewed
everything.

The next patch takes care of full zones that report different
capacities.

 fs/btrfs/zoned.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8eac6e2283a2..ce7c535adff6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1532,7 +1532,9 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 	}
 
 	/* In case a device is missing we have a cap of 0, so don't use it. */
-	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
+	bg->zone_capacity = 0;
+	for (i = 0; i < map->num_stripes; i++)
+		bg->zone_capacity = min_not_zero(bg->zone_capacity, zone_info[i].capacity);
 
 	/*
 	 * When the last extent is removed, last_alloc can be smaller than the other write
-- 
2.53.0


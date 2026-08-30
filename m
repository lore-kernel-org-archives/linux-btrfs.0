Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B037C3A1D05;
	Sun, 30 Aug 2026 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788086627; cv=none; b=Q4+x1oayj+z74ItpSbwi3Ba40XtSPGzQYoUqEIvqMW4MQCCnWO9HVTdP4f6ixCMfD5l9ybAmZPFeVJwflnK7JF3QEvt6x+0QY0h+z5/IgWmt0mSQF+ra+ez1wC8SYHiu0JjiSa7mLWXD5nqasT0iIMp2ZHbIC+WadmPATddsofg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788086627; c=relaxed/simple;
	bh=xjTC4xWTnioS5g/Ov1tHKok+d2kWyIBA+qCPx7iGMZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfuSWVx8V4cwZ8zJW1Yb7xUPk4TBhDndG2enb5m1L6Qe5s3KX8JvILERQRVdBFXDJaGs2Ob/0W+EjU7EzCNOCnhnyVkDdz5Vc1faYdtQgDWk5+bqOY3LcqjZHlJckQx6TlibsLSQvv40ns9f4PqCq+ntSPKmcaUhCbeZlN+ghzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 781D71EAAFE; Sun, 30 Aug 2026 18:33:38 +0800 (AWST)
X-Spam-Level: 
Received: from sparky.lan (unknown [IPv6:2001:8003:8802:7000::9c4])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id C64071EAAE8;
	Sun, 30 Aug 2026 18:33:30 +0800 (AWST)
From: David Gow <david@davidgow.net>
To: Jim Cromie <jim.cromie@gmail.com>,
	"Maciej W . Rozycki" <macro@orcam.me.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Auld <matthew.auld@intel.com>,
	Arun Pravin <arunpravin.paneerselvam@amd.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Chris Mason <mason@kernel.org>,
	David Sterba <dsterba@suse.com>
Cc: David Gow <david@davidgow.net>,
	dri-devel@lists.freedesktop.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] fs:btrfs: Use the new global is_power_of_2_u64() helper
Date: Sun, 30 Aug 2026 18:33:17 +0800
Message-ID: <20260830103321.2042968-3-david@davidgow.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260830103321.2042968-1-david@davidgow.net>
References: <20260830103321.2042968-1-david@davidgow.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs currently provides its own 64-bit safe version of
is_power_of_2(), in order to handle 64-bit values on 32-bit systems.

Since other subsystems also have similar helpers, a new implementation
has been added to linux/log2.h. Use this instead of the btrfs-specific
one.

Signed-off-by: David Gow <david@davidgow.net>
---

This basically just replaces a btrfs helper with the version in patch 1.
It probably doesn't make sense for this series to go in via the btrfs
tree, so it's probably worth either accepting the posssibility for a
conflict, or sending this patch in separately after the first one lands.

Cheers,
-- David

[This patch was introduced in v2 of the series.]

---
 fs/btrfs/misc.h  | 7 +------
 fs/btrfs/zoned.c | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index 802060943180..e8be78341dc0 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -110,15 +110,10 @@ static inline u64 mult_perc(u64 num, u32 percent)
 {
 	return div_u64(num * percent, 100);
 }
-/* Copy of is_power_of_two that is 64bit safe */
-static inline bool is_power_of_two_u64(u64 n)
-{
-	return n != 0 && (n & (n - 1)) == 0;
-}
 
 static inline bool has_single_bit_set(u64 n)
 {
-	return is_power_of_two_u64(n);
+	return is_power_of_2_u64(n);
 }
 
 /*
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a016cb471beb..b90ac4ff71b8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -421,7 +421,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		zone_sectors = bdev_zone_sectors(bdev);
 	}
 
-	ASSERT(is_power_of_two_u64(zone_sectors));
+	ASSERT(is_power_of_2_u64(zone_sectors));
 	zone_info->zone_size = zone_sectors << SECTOR_SHIFT;
 
 	/* We reject devices with a zone size larger than 8GB */
-- 
2.55.0


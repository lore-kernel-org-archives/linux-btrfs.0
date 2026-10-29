Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793261814;
	b=MuTf4sUwy8vk1ZV8dDyryvCyL2XcCTO/saKhZPTF/OFSx/FW5z9Hg+fP4LaOYkMGwSqO
	 lpTQ3uccqzjj4SOAFBzU3EEvZMUFcxpG2B37EmBxnstB7NJv9eb4Lu4s5RHkMWzbTQ5Zk
	 oGnXXGkq2kq49e8LTRfZV1akPkgTao79KE3PGY/nXCWJFHY5xkW9o4f5v7JZN98GWlPch
	 Pik7YW+4trSq7/yMIfrLLf+3zbAx2PI5lrDnoJOyLir1bu4ZDOt+pGMLZWHI5nAVBJ2R3
	 j7moHBepuIJxjcBlDAJ4idb/u0cdxGOQy5D92mTplm7PRTJPOzPJ+yGIdFOsFqLYzPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261814;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wWvGp+Ky49g3ikt/sTlPE2hQLwS22Xkn7D6lKMFHSGI=;
	b=Me8rjwBuOSE7tz07snb6oombtLJgwd+/8ecXMth7vGDPEi2JtZUxwa2a+5V1UmJIz5Xz
	 Gj3CR/+37blc0mvRCIvMZVkMIZensmliz+oCga4AYiUQu4KEeoTy7oPru9rbytfFZXToz
	 0WM1u34Cl6bdEMupibr942zGFEgvAO6OgVVvF741Uo+j3NEX62ZewGMHNJISh9lt8rLiR
	 E1VDjQkRcGqPDrT2DhwS/PeWkS1LoCJjrmV81RpvE6MSl5sR5JZk8YTpU+VlwfnUYAgGM
	 w5s95GkEI8Pcz3N07Q9jNVPNSNpHwRUaH1REsKb2iE5QrQblw4IU06PzRqOcpa5Gu/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgsADFAd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007B7606A31D;
	Thu, 29 Oct 2026 08:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgsADFAd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793261813;
	b=pJPzU1tQH3V01+Ld+YKule+R6z9PHe3HCFjXUMBgxapnyU1cIiagGFxg9LovTCZ93KJc
	 ZtoH6yTnOEz0yFb6d7tF4XL5wkyHinnLdd/KworIStJOcWEidtsGxo4hRAQ4YXD5jXZGv
	 qrDQtotYSnrbS3T5cy2NYk4oogpX4MhJKOKKkSx3Y9v0oNYTxdEUbWfyHzRiiJzUmr3Am
	 famuznArVVp2TWpIBU/v/7RkLUh8ZRCsMdSOFyE5oJUf1mkRDV4oO2CmG69X+f5t0nkEs
	 zjMAtDiKVln8jvw0iaSFb8SG34pc0x8D7A5WdSU3Zuab1FnuknQbG5UPjtgsWOjr5GQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793261813;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wWvGp+Ky49g3ikt/sTlPE2hQLwS22Xkn7D6lKMFHSGI=;
	b=xL+7fW7g7GDP7XCBDhzd/j+VYWZLxw/fp39ZYsy3ldiTTobmYOolul9uhXUPu+Ckkt2p
	 jBR0zbEdhTRRvhtMTO68mi4zaZBD1uv4Z3QBdEHXLroFG9fzPyMUjaOSrYLHMoJYSVcLk
	 +yMd1X6zrh5nH5Dzjx5C3atDzOnT5abBVrsJ13wgS/OMpsrDxWKXGTca44HbonT6nkiAU
	 bp4UaVWrciCd8h6MS4zF9qht1sd+BwAAwvauxsgem+20tdCD3Fu3vdBmIpWqm6pJKzHfw
	 RP7R+gU5CR+eP4uXQc9+KWULOE1hEwxeDNdCGPi1I/iqj1lL/58kR8/GSNCJZ1MFvLw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 06D911F01825;
	Thu, 29 Oct 2026 08:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261813;
	bh=wWvGp+Ky49g3ikt/sTlPE2hQLwS22Xkn7D6lKMFHSGI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XgsADFAd9PkJg41Qpv5xdv9zd9jdwOIFu0bwvmIuGWn29/K9GA1noLsEsGtjw4Vh8
	 F9st7LHDNbljsVD0TiE5ekpEasLxU5K4/IYliQKMWfb/rnImxSijkqMayTnMTV0IYa
	 xGPXoXE7onTiVx8L7192+GA0E/bmJFeNMtaxJbBLSITUJLDXH/1qSkPZRAMqZAMDx6
	 ncpHFQQHGZ/1USt2VvtUTBTFMtscNb/K2ZW4/CuSjH9VEmO+6wovTVmu6s2mIyYV5K
	 0RRkZR144gU7ZN6qCnVtwOxJ31EH3XiYILe4X8XsMn7c8dJIIVrO7WYUdS8GnQHflG
	 KHlb/I3OL0iwQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7A73C45790;
	Thu, 29 Oct 2026 08:16:52 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Date: Thu, 29 Oct 2026 13:16:45 +0500
Subject: [PATCH 2/2] btrfs: zoned: don't treat a negative zone reservation
 as free zones
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-btrfs-zoned-active-zone-leak-v1-2-777dd01ff914@gmail.com>
References: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
In-Reply-To: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793261811; l=2969;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=/DV6VhuvZpqJeMSGpyJDetY348SVMJHO3LESTAMCiLA=;
 b=n0FwG6ZfMT+z5PqxaMtHNErkqGVg6tTpK2oqI0vXqG31LdBPqOVSRbJrYhblRrfNpT8EOyMA0
 LrEDY492yyLBZK3TfLzTCc+QN51vpOFdbqMMWleVFll5pW0VKmiAgcn
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com
Content-Transfer-Encoding: 7bit

From: Mark Korenberg <socketpair@gmail.com>

reserved_active_zones goes negative when more metadata and system block
groups are active than were reserved. btrfs_can_activate_zone() then
reports a free active zone for data even when none is left, so the
allocator neither finishes a zone nor waits for one. find_free_extent()
fails with -ENOSPC on a device with plenty of space and cow_file_range()
drops the dirty range; only the next fsync() or syncfs() reports it.

A negative reservation holds nothing back. Treat it as zero for data
block groups.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
---
 fs/btrfs/zoned.c | 15 +++++++++++----
 fs/btrfs/zoned.h |  5 ++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ce8d96a48aa3..47aba2a63bb3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2444,12 +2444,13 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (zinfo->max_active_zones == 0)
 			continue;
 
-		if (is_data)
-			reserved = zinfo->reserved_active_zones;
 		/*
 		 * For the data block group, leave active zones for one
-		 * metadata block group and one system block group.
+		 * metadata block group and one system block group. A negative
+		 * reservation holds nothing back, see btrfs_can_activate_zone().
 		 */
+		if (is_data)
+			reserved = max(zinfo->reserved_active_zones, 0);
 		if (atomic_read(&zinfo->active_zones_left) <= reserved) {
 			ret = false;
 			goto out_unlock;
@@ -2712,8 +2713,14 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 			break;
 		}
 
+		/*
+		 * A negative reservation holds nothing back. Do not count it
+		 * as free zones: the check below would pass with no active
+		 * zone left, and the caller would allocate a chunk it cannot
+		 * activate instead of finishing a zone, then fail with -ENOSPC.
+		 */
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
-			reserved = zinfo->reserved_active_zones;
+			reserved = max(zinfo->reserved_active_zones, 0);
 
 		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 		case 0: /* single */
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 700d6909ee3f..aa6fa3a0b9a3 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -38,7 +38,10 @@ struct btrfs_zoned_device_info {
 	u32 nr_zones;
 	unsigned int max_active_zones;
 	/*
-	 * Reserved active zones for one metadata and one system block group.
+	 * Reserved active zones for one metadata and one system block group:
+	 * the reservation made at mount minus the metadata and system block
+	 * groups active now. It is negative when more of them are active than
+	 * were reserved, which does not mean that there are extra active zones.
 	 * It can vary per-device depending on the allocation status.
 	 */
 	int reserved_active_zones;

-- 
2.56.0



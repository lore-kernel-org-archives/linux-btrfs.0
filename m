Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793815221;
	b=ejwvRZYYG0PUWLu1fxqQLkeeH7sqTJV2yfrB+1jNu3/zGhnFknc79BlVDCStcMvI6tcH
	 ypNM8rcVXJq7TrJNsPCZGA18ZgILxS1jbbfHG4Cp8J1Cz+xbZ3kIpZMOiWIWlFOXz+N3O
	 Vl7zy6mUr6gzWb6DF3l84sjgwPAslN+gvPrLN7RWxLBARM3tfPL4nERBXNBT/bo6J5aTg
	 GY+B5bT54vGmbPAHizQtG3m15QnODTFs3MnU7NltZaTLqLctY/GwMycMocGAL/KvRHT60
	 lfQmWlsbOSUUqc4lxP3x7Fg/YXhh3cDXM1XOhBBZNNyyiYqhHzbIpdQ0lr3Bj3yBo0Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815221;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/6MFAyPnMczn4/H2KWzcNIPgrWrhDAwcxK/e97+Kc0I=;
	b=VoMffV1zfI2QL2tnLe87WlF0R5bLOHVU39PD8CYPmfxNKAjfc0W+9Uu7qjghPOL4G41L
	 unXJnq/7SyozFun4q/TDg9/JgFZxC76GZxUw1m6deeycVP6fLsFI9zGSrMBUY6pG4A+sz
	 BFbMMnz2+dtGNdpbUY4qAxmSC3YyejYte1V2RLBj8eNt2WjIkHwNk7NmgIPwdYTbOb8Tn
	 JxuhQp9H1euW5yyMsMm2OLKMNmieILq2IJMuRdwmSrY0/PruWkr/rszwaYsWB1+kLWxL5
	 jmx6EXxCOtSy+BAQi3R9J6DrD2QnscAW4IHzNG0FL995q3TuB3naL+ANqlf/uwunKwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T+0xer1x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACB4606B206;
	Wed,  4 Nov 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T+0xer1x
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793815220;
	b=rsuGLt+i91/eD/Y69lj9WX2OAUF1+++ZAQsvNukv27UckthtUckxudB9znkXmxJBvRuy
	 UJ0PWo2tn9lgdJ0kdCqBH/aNBiCtinAzPQdq+8lljGbPEZ0eMq723ElwueeYgvtaKmfmp
	 Cf52arPD+c2yEjZyh9hki7seNHnoUXSSG3faJkBgZuJygsCw5FRRYeCHuGNyTkt1y9cQ9
	 KTSAoHpPhsXseWrepY2GrVqbfCTo2z1CYcMNzfVCV5ItnTRA84nU40gHRgid9yCX+EER4
	 dBNaoFCaM4xiDthEd4lpAM2jdGmdZCX24ReW8qRzDMvOgVrhgR+0LaqamPs6Xg/BFiw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793815220;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/6MFAyPnMczn4/H2KWzcNIPgrWrhDAwcxK/e97+Kc0I=;
	b=Y03K9WlyudzpqhVJEFxp0aNnTrzPjkJPQG66d7vR7SZP7oDewqxZdM7TgMkKdhoVuZO/
	 2CDMJuVSR192GO5GUewIF9Y+yS1HsksdpUmBp+OzdnDffSMTxwzRT9oerFL3hCS7T3RQM
	 65TGMs1BRWvzVR1ZoiUX3ubVVB1+xWr4QmcSw1Z43gOFJbr1FRCgEbNSmwfLELPa4JMfA
	 AsFBKsg+5xnAoZWKSwRqNCf1bTZ72qNHOW25SjZOLYv00uyiuiwdqayaxfwaIFp9EuJ0w
	 3hmMzhn3SCDfUNd2KQyhabOOTg6XTAGcwXC3e0mlH21CNxr6Ez3evYNzWCI1xVuzc5A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B3071F00A02;
	Wed,  4 Nov 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815220;
	bh=/6MFAyPnMczn4/H2KWzcNIPgrWrhDAwcxK/e97+Kc0I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=T+0xer1xv71icAr0Ti9lvjElbkyqUVq1C4xRD7dhgFFpqhYS65JRX6KkOf75kjJKn
	 jlAPWVeW6MdWQS4jptyvUpSa0KsgYq7EKY5dg99jfbVObUkeFeWC+tIRGNdzin0u2z
	 +zvW/JqHSvnHayaO2R/ikMn4F9DmyjaD3VjDcn44caB3cmFItZQ/RVItL8ptZnU+xd
	 nfVp4vsyldIv4RLF1KfMEtKVK3LBalxLE76m70vlP7Rs1qrS0GnFEGPFN1kp7VVXUU
	 7C3pJgs5wHEizyH2j/RjjXC+S/59yu64jS/6pvmRwij0cZUlzY4xVdlHBTg/0rzU6G
	 ObeNm45ED65qw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9E63246F01;
	Wed,  4 Nov 2026 18:00:19 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Date: Wed, 04 Nov 2026 23:00:20 +0500
Subject: [PATCH v2 2/2] btrfs: zoned: don't treat a negative zone
 reservation as free zones
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
Message-Id: <20261104-btrfs-zoned-active-zone-leak-v2-2-0cee2ef72171@gmail.com>
References: <20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com>
In-Reply-To: <20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, stable@vger.kernel.org, 
 Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793815218; l=3073;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=9ov6vcyfbxQuSIcyp1fix/LygA/f+6EOEeQPQe4ctp4=;
 b=BxSIrWkqQ7jIlbvptF0To6iRBMrgqR04oWtlTiApNObX+NDfp9ARgMOF+xNx9VoGVIFW6CB+V
 O9rjyoCzkWIBrgtPfuQzfZdT2IIlHoy4E0qAacaSxkHpEEaplKG4shY
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
Cc: stable@vger.kernel.org # 7.0.x
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
---
 fs/btrfs/zoned.c | 17 ++++++++++++-----
 fs/btrfs/zoned.h |  6 +++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1d64c6e162ca..20b99325117b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2465,12 +2465,13 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (zinfo->max_active_zones == 0)
 			continue;
 
-		if (is_data)
-			reserved = zinfo->reserved_active_zones;
 		/*
-		 * For the data block group, leave active zones for one
-		 * metadata block group and one system block group.
+		 * For the data block group, leave the active zones reserved
+		 * for metadata, tree-log and system block groups. A negative
+		 * reservation holds nothing back, see btrfs_can_activate_zone().
 		 */
+		if (is_data)
+			reserved = max(zinfo->reserved_active_zones, 0);
 		if (atomic_read(&zinfo->active_zones_left) <= reserved) {
 			ret = false;
 			goto out_unlock;
@@ -2744,8 +2745,14 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
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
index 510e9d118c7c..2225090839f3 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -38,7 +38,11 @@ struct btrfs_zoned_device_info {
 	u32 nr_zones;
 	unsigned int max_active_zones;
 	/*
-	 * Reserved active zones for one metadata and one system block group.
+	 * Reserved active zones for one metadata, one tree-log and one system
+	 * block group: the reservation made at mount minus the zones of such
+	 * block groups active on this device now. It is negative when more of
+	 * them are active than were reserved, which does not mean that there
+	 * are extra active zones.
 	 * It can vary per-device depending on the allocation status.
 	 */
 	int reserved_active_zones;

-- 
2.56.0



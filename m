Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89A4F6477
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778355; cv=none; b=eLPly2ItBWiTwZyfg6xqPJBbEfCviv5fdcCskOvX1R+B2hg20MOehsEQbEtjHSL23+j0ZsVBpTorYfRmevxX1kKzx7AzPmj4FB5lKLbbMJi64GjnhWWGhyhUTGF1Y5Ay4M9AU6J3cZDwZ5rmJEik1P1I5Y7mP5trzIBQKYUPeIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778355; c=relaxed/simple;
	bh=ucqadmAvti71Rl/Cc9YP8gPZbtixKAzPNpvToSnap+M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuQb+VIQ/jycNU4fdlvrBFryfid2faPEdoIwYIKLkIuBMbx69o+wOgV2iuXz09vBZTzK5Ep0qAE9Fn9yr22JUCLUEKgG4FXfomQYcv4AQJh82zpi7wohmfZS1Z5UhmHBvFKOS8HQlLvQuN2JdZKawCABYm78t3PrcTDaQf6ak44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExlC8Ddy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExlC8Ddy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C32B1F0089B
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778346;
	bh=psTlW9stRgIELpImcV/H6t9C7xbzWKHZxB6Y0GC6dlk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ExlC8DdycRxEOKKBen6hMG7idN7eXMpo8zlWcaIwuc47oVja4rg1AV1M209DVNhXL
	 PVCThuLTJWsGViru1gRpowISNVasglMJM1v5Qax2I0mN2lwNUJyj/0UMFTEwQ1Vq18
	 4Y7RAqsErYK6S8hpA1WDCIukwUzDmHAakPoI82IN/qlEBMXklGinB8ooQ6DXD6dlPM
	 cKkr8QzqfrIMZrBbjBnxAR9LoRm9fCaE/zzIpqBlVQhXpsMeftz95ULWAv2w659By9
	 kuEbfRD0SskHCRw6YfhcoG1jeMw0WNB5IeUchB+ZhN8onD9K/oJUwZTNyDr+d0ywpU
	 JjeQWupqhbGdA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: add missing code for no delayed iput fs state in log messages
Date: Wed, 30 Sep 2026 15:25:36 +0100
Message-ID: <11a60116458a1ea6618b8e5e648863ec98c20702.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
References: <cover.1790772326.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Add a letter code for the BTRFS_FS_STATE_NO_DELAYED_IPUT fs state, which
is currently missing and it's useful to have.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 5fe5d34ab629..2610b447165e 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -26,6 +26,7 @@ static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_NO_DATA_CSUMS]		= 'C',
 	[BTRFS_FS_STATE_SKIP_META_CSUMS]	= 'S',
 	[BTRFS_FS_STATE_LOG_CLEANUP_ERROR]	= 'L',
+	[BTRFS_FS_STATE_NO_DELAYED_IPUT]	= 'I',
 	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'H',
 };
 
-- 
2.47.2


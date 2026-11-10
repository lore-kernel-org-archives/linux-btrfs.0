Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301125;
	b=K0nZObVc1kVnzT17CKBdPFKdw5jxC0K1yFqGpeUXm72WA+3Tr8s7q53Z4NXEPdO8H/Aj
	 Lc9opqOVRJSsOaLavyA7zKKe6A6qZibh3qOkbxBYT5Ht96Swo+ZjDhnlndlDz/9qZs/+G
	 89ibyR6nmL/6IsQExm/37eyZqxABwz3PmXQyhudQbwlIiGD0Jcv1HTGC2H9vjFfvd7PCD
	 Dr8+MkjSE4REvz4Njo2IAQuy2/w9MscCrs3ON/Swuna3U6rNHt2gPLUYUwpVDgZ7MiBS/
	 g/QQjrZoCMPaI6JGc9C7T24slMeq+EWdqmFj6vK4bwsweWS8xEeuNuydXpWwLS7WPBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301125;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=ZHR54X8B1Vi2Dy1CLjO9HYKEflDtZiTBnQwfHnLfqBc=;
	b=AUt577lFxb3XvKqqqlff3s/Tuj9NAg+hftfS6uKSqZHxznFFk4Eb6F3GUalRLP63dyBU
	 HSPqPA3DzefNHw5NRqw8MoAJIvgQepPuVQwmHkO/Ub2+pXAq6LQvurUP8tKTZS4CZugUv
	 wwsq1Yr6u5WJhqAbKNga15HCaurJzX5mjk/evpcBCrenVmsxVpxvwQqbfCvVaT5eFtspq
	 TWdqN5O1C032JUA0RRGqAe70nK/HM7twZtlqpvdA92++Jzz4fF1Up15FSgD1YaUOyiZCW
	 elywNID7VEvDH8zHyL7GX7/3H/4MfhQPa9OBKy5JtWQ701uC0VCxXsu93/Ecl5Udmmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA56C606A321;
	Tue, 10 Nov 2026 08:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA56C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1794301114;
	bh=xewJGJe/xTvyxFDlC5jYEKEScDnfgx77/g3hJ9ja8vk=;
	h=From:To:Cc:Subject:Date:From;
	b=ZJpyIHekl7Rbxi/JLu0BqTdrvzht3hCK8VuY0L4AsipzUl41eoLcn5NAfqKBGhKfY
	 QNgZl9fyPqPAGOF+9fo6pF7hS+8vheNsWOHRgCmoRlsBCbg0lLsbyVqksajUApWGw4
	 V8hExTCgxv6D0Y9/Bhu2kIABwge1afthrGxhfcmwoOCv605d2Ysyj61455Svk4z8mV
	 gjbdWFtsv+4cASYVVBg1QNCBSXCeCeDwYKOs2OITcMD5HjHE0BpZqb3mdbUHvaSaXE
	 bsTzoriJ80ANUgo4AxNHlnh4wR9S7SAth4dy4ck0p7QgS7QeH2i1NBG5NI3mI8VMln
	 xBQYG+0aFYLLw==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id C76982681F;
	Tue, 10 Nov 2026 11:58:34 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Tue, 10 Nov 2026 11:58:34 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.16.187])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jP0td4ZGxz2ST;
	Tue, 10 Nov 2026 11:58:33 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Tue, 10 Nov 2026 11:57:59 +0300
Message-ID: <20261110085801.1915-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
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
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 134 0.3.134 ce9cca31102af372fedb0df49d70b90f771aea0b, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207361 [Nov 10 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/10 08:21:00 #28832117
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Qu Wenruo <wqu@suse.com>

commit 9102b179512e11644fb0489ae62010a09afa199c upstream.

In that function, we round down the start position and round up the
ending position.

But during the calculation of @len, we use "round_up(start + len,
sectorsize)", which is the rounded up end position, not the rounded up
length.

Which results a much larger length, and later we are still using
"start + len", which is completely incorrect.

Fix it by declaring a local @aligned_start and @aligned_len and use them
instead.

Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[mdmitrichenko: Rebase the first hunk onto extent_changeset_init()
 and the existing int freed declaration.]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-90259

 fs/btrfs/qgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a252f6cca0027..41edb8e0c5a3c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3819,12 +3819,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
+	const u32 sectorsize = root->fs_info->sectorsize;
+	const u64 aligned_start = round_down(start, sectorsize);
+	const u64 aligned_len = round_up(start + len, sectorsize) - aligned_start;
 	int freed = 0;
 	int ret;
 
 	extent_changeset_init(&changeset);
-	len = round_up(start + len, root->fs_info->sectorsize);
-	start = round_down(start, root->fs_info->sectorsize);
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter))) {
@@ -3836,12 +3837,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
 		extent_changeset_release(&changeset);
 
-		/* Only free range in range [start, start + len) */
-		if (range_start >= start + len ||
-		    range_start + range_len <= start)
+		/*
+		 * Only free the range within
+		 * [aligned_start, aligned_start + aligned_len).
+		 */
+		if (range_start >= aligned_start + aligned_len ||
+		    range_start + range_len <= aligned_start)
 			continue;
-		free_start = max(range_start, start);
-		free_len = min(start + len, range_start + range_len) -
+		free_start = max(range_start, aligned_start);
+		free_len = min(aligned_start + aligned_len, range_start + range_len) -
 			   free_start;
 		/*
 		 * TODO: To also modify reserved->ranges_reserved to reflect
-- 
2.43.0


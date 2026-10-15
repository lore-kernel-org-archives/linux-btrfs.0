Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFAB4A5C57;
	Thu, 15 Oct 2026 09:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056324; cv=none; b=mEgiekFdiAGiUKgitZXiWenx/3X/Jp8uOyRzNsVxxlZiJdOXH0J5AjLdoFi7koY2+NuMUYlY4tp/iTjRJFLhtzIUx06w7YY+JsbaeeBu1u2w4E2KSSMiq3ZJ0miDd7K4M+7HSCeh5C+WrbwYWnAXN5V21x0lgqYsXhwW9RkoJ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056324; c=relaxed/simple;
	bh=ZEmv9E/ZtcdpCplmU6e0iX8yxCpo6t8QDQ0J31PZxiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tKLEh1/FuDYvvC1eKX2aenZfPINR6/7j5WFO9CbniHhl7f28rRFiaX5H5pY3Kg3MXvDO+VVxgkX0q/XuwuvvI8KLTV7n+GqVyQAjAbRoSDyece2+sa5QA9nvXDxHUuUUlV2j2u3stKXnBld0efZNoKtdThYhemxuG6pqS8myDJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=EF/lL6Ua; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="EF/lL6Ua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1792056316;
	bh=ZEmv9E/ZtcdpCplmU6e0iX8yxCpo6t8QDQ0J31PZxiU=;
	h=From:To:Cc:Subject:Date:From;
	b=EF/lL6UaKpVkXjjWpONjA5upObeZFlG6FJP11dxjmMDtbw3+6Oo9GOQ4f2ZILg0QY
	 XXOsXQFnlF51GROWaWw6UhOje6+U/mMwWJgvkt/fiuLCKNcZCWUbIs8NaiSKfo1VHv
	 npW26ba/V6xs9D0ew5QeaPUZXd6fNaUmmKYeMy45EJbc/pnKbzgw4kObjcRSbflnDm
	 nX14Ix9unl+1AlEvyL+ttTK16bGAYbkpPrx1FepA+y6WXYaGU+XKxcNwPxbeqHdHQ9
	 phvjUqHRCdu0ualvf2DIeFbglPi73OzuSvqtoXC3NCkXfK/KTEBvTxPtci7wtgDath
	 PJ7OB/+cZzVPg==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 9A8B724FAC;
	Thu, 15 Oct 2026 12:25:16 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Thu, 15 Oct 2026 12:25:14 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.48.108])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4j52jQ1RJRz2JmW;
	Thu, 15 Oct 2026 12:25:14 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.6] btrfs: free path if inline extents in range_is_hole_in_parent()
Date: Thu, 15 Oct 2026 12:23:37 +0300
Message-ID: <20261015092339.1935-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/10/15 07:23:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 127 0.3.127 0884f7b061fa529b810563f359267cd65d2ec05c, {diag_burst_silent}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;new-mail.astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 206699 [Oct 15 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/15 06:31:00 #28687005
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/10/15 08:01:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Hongbo Li <lihongbo22@huawei.com>

Commit f2dc6ab3a14c ("btrfs: send: check for inline extents in
range_is_hole_in_parent()") is a patch backported directly from
mainline to 6.6, it does not free the path in the inline extents case.

The original patch in mainline does not have this problem because
the former commit 4ca6f24a52c4 ("btrfs: more trivial BTRFS_PATH_AUTO_FREE
conversions") in 6.18-rc1 introduced scope-based auto-cleanup which
avoids this issue. Since some dependencies are missing and cannot
be directly backported, we choose to use a goto statement to avoid
the memory leak in inline extents case.

Fixes: f2dc6ab3a14c ("btrfs: send: check for inline extents in range_is_hole_in_parent()")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
This is a follow-up fix for the 6.6.y backport of the CVE-2026-23141 fix.
It was posted and reviewed in February, but was not sent to stable@, so
6.6.y still has the leak:
https://lore.kernel.org/all/20260227075219.2594937-1-lihongbo22@huawei.com/

 fs/btrfs/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 099b5a2e1156..7b19b1ea29fd 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6545,8 +6545,10 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
-		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
-			return 0;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+			ret = 0;
+			goto out;
+		}
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.43.0


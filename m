Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9864756C1;
	Thu, 15 Oct 2026 09:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056452; cv=none; b=RMTu7NcwKQrEgFE23YzVSRybxYmqdl2dmUI3T9O4ks+V1iYnDlHW1GOQMVuRrWFE1ZEhVGNOldLWw7qEP+BQFUBXFvlAXVfwJcoRsdcfldDNKf5oDHn0+HkJ3TN9x/JQLVpNlglm/q3ufKKcoT1lffPnY0txsTfN+Z7mxV2wPzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056452; c=relaxed/simple;
	bh=m8BqeVLKW1NNI4OXuu485jJvCTCkQuDlWvXl7Z2Rwl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FvnlHA+L4OGzztGvet7n5ASYfvOMc/mdu6NZusnsJ2ffTadaldK1ITEuUrbz2Cv4WRSuLxHRE7DaR36dqvpY4WGubqinhne1/dtVFf7o7lOZS8jpaADbYJziotAr59FnvyBpVw/y0fwnxr2Iof1XMy6DCe3PbNb9g1bruB3YOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=E5W8SVyT; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="E5W8SVyT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1792056441;
	bh=m8BqeVLKW1NNI4OXuu485jJvCTCkQuDlWvXl7Z2Rwl4=;
	h=From:To:Cc:Subject:Date:From;
	b=E5W8SVyTk86QejG0xj+UVqquK+5aW/4daDBTKGEwxk0qvYgEY0knz9kZ/ibQl2EyR
	 xB+6FlDLND9czdt0N2QBo+CYu79+8ZiFHmYm3LfrF3sZ9XKL8IgE31sBo5XoiuD/hV
	 MgE5VinpnbA1TeesUxUQGhnGOtzggzOs9ibQR/gf7YqGVaAwY6m0MeQrb/cEMkudZR
	 2UOIHeuHaECkGDqz69BnnxHAkV1suPp8CYoFxN5qpfNQ5VuokYYpt0TLuDg+bOoEqG
	 K84RMYcYjS1DneI+O82PuJJHP7XA2P3L7oJ8FnrPQ5Q5JagkTZ/vofKRv4bMhsppfO
	 mqY18xtB44kYw==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 67FE324C83;
	Thu, 15 Oct 2026 12:27:21 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Thu, 15 Oct 2026 12:27:20 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.48.108])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4j52kJ068dzLVw;
	Thu, 15 Oct 2026 12:25:59 +0300 (MSK)
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
Subject: [PATCH 6.12] btrfs: free path if inline extents in range_is_hole_in_parent()
Date: Thu, 15 Oct 2026 12:25:25 +0300
Message-ID: <20261015092527.1172-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/10/15 09:17:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 127 0.3.127 0884f7b061fa529b810563f359267cd65d2ec05c, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;astralinux.ru:7.1.1;127.0.0.199:7.1.2;new-mail.astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 206699 [Oct 15 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/15 06:31:00 #28687005
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/10/15 09:16:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

Commit db00636643e6 ("btrfs: send: check for inline extents in
range_is_hole_in_parent()") is a patch backported directly from
mainline to 6.12, it does not free the path in the inline extents case.

The original patch in mainline does not have this problem because
commit 4ca6f24a52c4 ("btrfs: more trivial BTRFS_PATH_AUTO_FREE
conversions") in 6.18-rc1 converted range_is_hole_in_parent() to
scope-based auto-cleanup. 6.12 already provides BTRFS_PATH_AUTO_FREE,
but range_is_hole_in_parent() still frees the path manually at the out
label, so use a goto there to avoid the memory leak in the inline
extents case.

Fixes: db00636643e6 ("btrfs: send: check for inline extents in range_is_hole_in_parent()")
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
This is a follow-up fix for the 6.12.y backport of the CVE-2026-23141 fix.
The same change for 6.6.y was posted by Hongbo Li and reviewed by
Qu Wenruo there:
https://lore.kernel.org/all/20260227075219.2594937-1-lihongbo22@huawei.com/

 fs/btrfs/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6300418ce357..c9618340f09b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6549,8 +6549,10 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
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


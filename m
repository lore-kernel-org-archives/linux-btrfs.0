Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23F63F5BF5;
	Tue, 13 Oct 2026 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902601; cv=none; b=lGaNu5hs4Tc103eGJKYFPq4MG2egnRakiFuhfNfxG4kXQUeIFcToVefDpgRAmmMS+Cwf5YUGaVSwbzGBlp3AySQTePrNpQmzKsKD7AeIbVk/tUhbXTeMPlmzpHCbbxzv3tesdjp7f8cBPFIqFR144tzttP1TZVK6FEMLCzys2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902601; c=relaxed/simple;
	bh=ydtjsell2COacrg3JQln/5pKJwSQWHTBGPh3XeDjInI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P2Sm01w2wFQoncno9kZZeou1cGCK4RbWJ64EKDJNztQI4ixhiglU0xBkI/+J7LQUoxyFz7Lq2sBjPW4tT+XuqWobnwXIt4Zm0qXz8jiZue3QigwRSuEf6Aq/vdu/sAwkLceCvVCAWcWILz2SFIdv+v7xo2FcqMydPl1u6t9ft5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=XlO7bzkl; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="XlO7bzkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1791902585;
	bh=ydtjsell2COacrg3JQln/5pKJwSQWHTBGPh3XeDjInI=;
	h=From:To:Cc:Subject:Date:From;
	b=XlO7bzkl0ZMVPrr3yhkvLbbDnEZsNGJbSBWgVsDf3/XP3x9Pwz0JQvLTHNv9TVfjd
	 6pdWT04U+05KeqhKxBB8AD3vyDehk7MB28gXYVq05RS6AnLy5ZnpLlUWQ2Je80YT10
	 DPrpi+OqmLftv0mFHpwp7FZS74ZL3hq2dJtI6WgZNGUMrRrhbO5XM2hkqRmDF5k6eo
	 K0HCyyRlMERV4HgHmlrxmYdiEH6ZdCY37yq470MThFNjKTeXo7/KK9OtGzx7wTbJBE
	 iy7b5AGASEwxPpyjuZgzNauhZCNu5265CKzoPFDRzwD8/XSrqSIFC8ImOd4pyfZmrU
	 UJjQ6z5Tg0vvw==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id CA0B025A3B;
	Tue, 13 Oct 2026 17:43:05 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Tue, 13 Oct 2026 17:43:05 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.63.202])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4j3xs44QWmz8P8;
	Tue, 13 Oct 2026 17:43:04 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Tue, 13 Oct 2026 17:41:13 +0300
Message-ID: <20261013144115.1533-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 127 0.3.127 0884f7b061fa529b810563f359267cd65d2ec05c, {diag_burst_silent}, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;new-mail.astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 206637 [Oct 13 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/13 04:56:00 #28679670
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Qu Wenruo <wqu@suse.com>

commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 upstream.

Before accessing the disk_bytenr field of a file extent item we need
to check if we are dealing with an inline extent.
This is because for inline extents their data starts at the offset of
the disk_bytenr field. So accessing the disk_bytenr
means we are accessing inline data or in case the inline data is less
than 8 bytes we can actually cause an invalid
memory access if this inline extent item is the first item in the leaf
or access metadata from other items.

Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ mdmitrichenko: use { ret = 0; goto out; } instead of returning
  directly, since 5.10 has no automatic btrfs_path cleanup and the
  early return would leak the path. ]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-23141
 fs/btrfs/send.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d86b4d13cae4..92018cd48e54 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5892,6 +5892,10 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+			ret = 0;
+			goto out;
+		}
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.43.0


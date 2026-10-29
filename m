Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793286720;
	b=YBN/NZ8J13jerzKLoz2tiCgnFdgZ66E6X+BOn8kIumb/wVlZnNOdinX2fySMaLlHBQ6g
	 SUF8M9hNMeIrMo5WLVgMHjFTBE+msYnDQifnGamyfKCKzbMScSfKk2xou/svVpyNQv10E
	 l+oVF7l62o8o84FZI/2sAayfAqOB411edPfIDf62d2y+4VZU6+IwDjvzcx5gt4M3ds0oj
	 S+D897UeZ6Yz3myu2JdYrB4B/99fw06FzbOxbS0bickpdHB/2nTTOnJG5CbaQavBc+77s
	 f3dtzgC/bfiaENQHjtONLYSbGXnxKSX0oKCBg8cmOKUnyEjD54kzhETe0Yyv8uDHNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793286720;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=6OivFj7eK/2o7S42fglb8hJK44S7C9v5KM3KhCAq8U0=;
	b=gZOb1azpnthM0xIeKvOrhGhGxIlMeysUIHoSYAFW7xlW6qWYfMe646OTV0omefNxDBAE
	 Cpe3kJkpPkwNm51NBvSSU0qAvCaBDSSgCQ4aaHaZ1i/vc9rcL4HZtkBPecByuSlZ/EPUn
	 8Uq4XG2I61FUJfgo2Rle8FulKOGf9vtzWXF1V5Ke1F8pQbYUGylaKQMXONKUPIMj7da44
	 gc+/9rO/TVGF77SAPakkVZJLctFUbnYSQWJZnZhxtF5/Ch4Uit9LNN9xs6qhfzSogIdH9
	 50wqlj9nHJ/p7hyflCsMxrex2HRudEB+WhUY0SfGLF6QS+7QOEVfZoNMUyENSzszEOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=kjyUxfdf;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A1606A31A;
	Thu, 29 Oct 2026 15:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B0A1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=kjyUxfdf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793286708;
	bh=8Oepbe9O9yB6V1/MpLPmhshtyjQFBga0hDC5FctDDeI=;
	h=From:To:Cc:Subject:Date:From;
	b=kjyUxfdfrR0wq3hxAnOaHGgsa5WnkMO4Ko3UUBrKB3GkZ9ssZJ3Ae7eRD2vOw54vw
	 nnszICRL9jLkk56uEquTGnPIc+HbSMzHvh0Q8SBarqjGaGNiCywhM7PXR0oSpBtkd5
	 VGXi04CbPRzmVo9ExQZZN1+oI5DledTcv0506gTge3rzCWxghLnYGd4phd9D0IzO42
	 /aIPghJ7/wep61G1QyMA8+vMqm/LD9dLU53iJiElxawmZzVTGkums6rIva+FpxLoD/
	 a8MX3Opx0MdM/DwnIvSLuXZVdy28zQrmz7qRgr5sg9fERl/WoODI+YU3rDIFtuaiME
	 MxtsXKb8yO3ZQ==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 99B0A25C98;
	Thu, 29 Oct 2026 18:11:48 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Thu, 29 Oct 2026 18:11:47 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.28.100])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jFnkq2dccz1NyJ;
	Thu, 29 Oct 2026 18:11:47 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Chris Mason <mason@kernel.org>,
	David Lee <david.lee@trailofbits.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15] btrfs: lzo: reject inline extents without valid headers
Date: Thu, 29 Oct 2026 18:10:26 +0300
Message-ID: <20261029151028.780-1-mdmitrichenko@astralinux.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207109 [Oct 29 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/29 07:40:00 #28758333
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: David Lee <david.lee@trailofbits.com>

commit 0fa78ef637deb5dbe341582f88553a4bce496de0 upstream.

[BUG]
For a crafted btrfs image, the following KASAN can be triggered when
reading an inline lzo compressed file extent:

  BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
  Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77

  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x70
   print_report+0xd1/0x610
   kasan_report+0xe0/0x110
   __asan_report_load_n_noabort+0x13/0x20
   lzo_decompress+0x57d/0x700
   btrfs_decompress+0x140/0x1c0
   uncompress_inline+0x147/0x1b0
   btrfs_get_extent+0xb23/0x10a0
   btrfs_do_readpage.constprop.0+0x538/0x1ac0
   btrfs_readahead+0x32f/0x5f0
   read_pages+0x16f/0x850
   page_cache_ra_unbounded+0x296/0x490
   do_page_cache_ra+0xd9/0x130
   page_cache_sync_ra+0x3ee/0x6f0
   filemap_get_pages+0x306/0x15c0
   filemap_read+0x329/0xd00
   btrfs_file_read_iter+0x1f8/0x2b0
   vfs_read+0x4ef/0x720
   ksys_read+0xf8/0x1d0
   __x64_sys_read+0x71/0xb0
   x64_sys_call+0x1ab0/0x1b70
   do_syscall_64+0x61/0x470
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

[CAUSE]
For an inline lzo compressed file extent, there should always be one lzo
header, recording the total length of the compressed data, followed by
one segment header, recording the compressed lzo payload.

But if a crafted inline lzo compressed file extent contains only an lzo
header, without the segment header or payload, lzo_decompress() will
still try to read the segment header, causing a read beyond the item
boundary.

Furthermore if the inline lzo compressed file extent is the first item
of the leaf, it will be at the extent buffer boundary. The above
out-of-boundary read will go beyond the extent buffer boundary,
triggering the above KASAN report.

[FIX]
Validate the total length of the inlined lzo compressed file extent, to
make sure there is at least one LZO header and one segment header, and a
non-zero payload.

Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: David Lee <david.lee@trailofbits.com>
[ Rework the commit message to remove slop ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ mdmitrichenko: Update the existing srclen check, which returns
  -EUCLEAN directly in this version of lzo_decompress(). ]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-74723

 fs/btrfs/lzo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index aa9cd11f4b78..40647a5cab6b 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -432,7 +432,7 @@ int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	char *kaddr;
 	unsigned long bytes;
 
-	if (srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)
+	if (srclen <= LZO_LEN * 2 || srclen > max_segment_len + LZO_LEN * 2)
 		return -EUCLEAN;
 
 	in_len = read_compress_length(data_in);
-- 
2.43.0


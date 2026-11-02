Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793662290;
	b=uvwa9HqGBtnR5jDAY3shM5A+UI7Z85FdmiO2cmi/q3bQWIFqYxitQDZOTrwuLY9hviqS
	 3AYVuSs+tsMZyUVEh+eiPN7QpSCXvfI93mWd+nWt2ODc1VogLBfbx7MUMOwOxnbG6h5wX
	 9cKylO/lQdQi7RV5Ipr02kaQK/8uppxslbdlldfq2GmGcnC+jL50m9q80VxsFPgcqGkb3
	 QF9vitfTJN+e65m6xYknLoHGc4CF4b0qj4e49JvlCxHkEoxCSmR9gFWewUaKUy3Al5FHS
	 uFE5H0cEvS2c5o3DPp48tjE0QRqUwvJILzyHoEhEX99G2jmRbBVR1HHSX+DyctluQLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793662290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OoWUKvavyBp7l0yEFdfI809FcCGWR9loHYOW+zBH4zE=;
	b=Mdc8URorGQi/n5r0mCHTVtEmcSc1mbCDjxKs/tKqZQvlY2FAagnqvyZok1ERrJEYqoX7
	 YCR853AlJxv1C6Tj9CXW7DC2Qwg5Op7Ec5rY2q0cZpFGF6h/QMINiNdgHDSdNpBwawQS7
	 t46JRrA+PDwa+aJkhXZx6wafc157fwEog7pat26XH9ottoPz0I+yYUe+3nrr3D3O21+kB
	 HsSp/PqIpv/2XbzUdpkvbCb56R+JDHQR6UgGx2yZAuy+/WOuyZ+x1wxwtC46TeY/43pTP
	 yJ9RQWSN/lKAxqvq5hiC+sxYbo5PvrFbC2aHFFn9KNzUpjNAmxKNtN67w2BRp7AETUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=eXbDDDaq;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4D4606A329
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 23:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D4D4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=eXbDDDaq
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so3529073c88.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 15:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793662288; x=1794267088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OoWUKvavyBp7l0yEFdfI809FcCGWR9loHYOW+zBH4zE=;
        b=eXbDDDaqOn7p2D9K2i5RdUvuZtVV4rFbqujBe0ac7+apVn/zGAPsyZ3IIg0yADPnuz
         x3wvEdq+ELIWFEyk25Lsr4EwoCT6Ks3YkQ2Y/x1teCRbRyNziupOGnC5GhNyMqDQPwkT
         APa4xQUzsbH6VdYOeXS+Zm06Lv8d4YgC+sD3EdAME2MrNBsMgnu5S2fJf2nsmGC7tOYh
         wntG2pZ8Oz8R1okbS8eaU+0wkdsshorwEi7cI/hw8kLz5zCwqYay7sEkvE/0LluEDaPr
         1rJcRtIs0RefrMpzzG0zdcxi9tH38FAP8SI5Dvn8hwj+MRiwxGruyJh0wC5zyN4Hm4Qs
         HWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793662288; x=1794267088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OoWUKvavyBp7l0yEFdfI809FcCGWR9loHYOW+zBH4zE=;
        b=vt5dUzKdSJVF8fVovZW3MeV3RM13Y/AI1qMv7iTv1g/fkIhmh4SrNsSkv2O7OF4gsG
         dhlE47FzsgR91Nc2I9tSBO4UjBk4s+Vl61dCV6gg0WR7TrTop68VyiTkRH7i0vtvUIbM
         IpzzJFz3FpDH/oEaXc5qc8oWxeWydc/4xtpVTgY6s5FHnOojGlQW+34KWD00IGV2ZTAb
         TwPT3jyQG1zGiWJN3W3Y/ZopRJenhOr9dIlHlAOzO/9lq2stl202jaMb8PoGMMDkxFO6
         2slpBCN6OiostO2RIKaGTCRGnKv5sDHo4fEmEWCV9jHCu/BuoiMtMEv7nuQg5Evbq4tc
         rr4g==
X-Forwarded-Encrypted: i=1; AKwUvBzc3zp6hq9cAMddPCe8YOxt/BbkPYdJ6sJLNzjEm2oORdeO5IDeZM5x/7hL3+GkYjKQSzu01Ei7fYZDuw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIIOv+KzPJ5XbBN98FExZxe+DHAsEi4PFr6Vx6ONkpnNC7Wla5N
	/hDdGBKaor4neQaO5A9OxyQh0t2CW29zB0K8x3V1xAfHaAIGeyrJqAyWM07HXne/mg==
X-Gm-Gg: AYBFou2PGl9Nrx9SasOIK9tF2Yh7DtmY4qaHpwHTgfzWL3YTs760HP2O95in4Ab3EVe
	TrDktShj/iTxtCK425b7SrgjanMCHSCzISgmmFb565cpv+a9135cSZmf4Z0tmbkaS5gzkTMAALv
	MThtKvOKeYc6L3KJ/6q73m8UvMJ5LdsQ+Y3+O9VpPgag+t4ExDW8jepgsVGgJzGdtNA1mC3ZIte
	SWvri/Ghm3eGgMsSTEz3wRFYDT1tdWX5WxSXQqqkWAanVPckGTHxJJqZbOnKjYmd9nk/7OhINjk
	LUgn2AEuTAv/z9Iy+xa+iWBWQoOrrKbUkOagfQ6o90CJt6C3hASWFyZDZnXFS+pBeZ6JyVs1Y1m
	bcMU8cDgzoQQuL1SZR474zGycTNgdd/xHprcZsXNoJDNVu0MzNmr11eoJpkp2UHe7lJMxaiRXD5
	1fE3EDUxyQ2iCkyRmZg/9KYZONG98gIKpXPMT2WeccWaHhcXG5q0IB5I4KSn4PhSKiRNO9+7FJ8
	hJzo5ChsALkf+oAjqqFHUk63fCysSNSmL9Ol9EbFSGARrAnptg0RItp1vhgF8Pyj7rvQmMNAKLU
	yOKhrr0Eg2yhujRUbJTA6wseJ+xkis4EPNSJ
X-Received: by 2002:a05:701b:240f:b0:151:2e62:fe6e with SMTP id a92af1059eb24-1ac5e322fc2mr13871385c88.19.1793662288465;
        Mon, 02 Nov 2026 15:31:28 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1845817csm36527415c88.5.2026.11.02.15.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:31:28 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <brightprogrammer@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: do not check support for an invalid sectorsize
Date: Mon,  2 Nov 2026 16:30:41 -0700
Message-ID: <20261102233041.310900-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
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

From: Siddharth Mishra <brightprogrammer@asu.edu>

[BUG]
Mounting an image whose super block has an invalid sectorsize (for
example 4097) on a kernel with CONFIG_BTRFS_ASSERT=y triggers a BUG:

  BTRFS error (device loop0): invalid sectorsize 4097
  assertion failed: is_power_of_2(blocksize) &&
  blocksize >= BTRFS_MIN_BLOCKSIZE && blocksize <= BTRFS_MAX_BLOCKSIZE,
  in fs/btrfs/fs.c:137
  kernel BUG at fs/btrfs/fs.c:137!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_supported_blocksize.cold (fs/btrfs/fs.c:137)
  Call Trace:
   btrfs_validate_super (fs/btrfs/disk-io.c:2525)
   open_ctree (fs/btrfs/disk-io.c:3507)
   btrfs_get_tree.cold (fs/btrfs/super.c:2133)
   vfs_get_tree (fs/super.c:1943)
   fc_mount (fs/namespace.c:1282)
   path_mount (fs/namespace.c:4337)
   __x64_sys_mount (fs/namespace.c:4542)

[CAUSE]
btrfs_validate_super() rejects the sectorsize because it is not a power
of 2, but it does not stop there: it goes on to report all invalid
fields.  The next check passes the same sectorsize to
btrfs_supported_blocksize(), which requires a validated value and
asserts it since commit d728f2e5f8a0 ("btrfs: simplify support block
size check").

[FIX]
Only check whether a sectorsize is supported after it passed the
validity check.  An invalid sectorsize is still rejected with -EINVAL,
and the misleading second message "sectorsize 4097 not yet supported"
is no longer printed.

This bug was found by fuzzing. The cause was analysed and the fix was
written with the help of an AI tool. Tested on btrfs for-next
(d6f76ca0a70d) and on v7.4-rc1, with KASAN and CONFIG_BTRFS_ASSERT=y:
without the fix, mounting the image hits the BUG above; with the fix,
the mount fails with -EINVAL and only "invalid sectorsize 4097" is
printed.
A crafted image (22 KiB, xz) and a C reproducer are available on request.

Fixes: d728f2e5f8a0 ("btrfs: simplify support block size check")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Siddharth Mishra <brightprogrammer@asu.edu>
---
 fs/btrfs/disk-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8e8fb942d..b348591f8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2520,9 +2520,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		     sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
 		btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
 		ret = -EINVAL;
-	}
-
-	if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
+	} else if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
 		btrfs_err(fs_info,
 			"sectorsize %u not yet supported for page size %lu",
 			sectorsize, PAGE_SIZE);

base-commit: d6f76ca0a70d0c814731394a625ff0dc1feb390e
-- 
2.54.0


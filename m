Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915264;
	b=yl6UISjKsatRYNEBmO/ZEEeoU+nxOWuqB4DmMPMScdd2EUVBlABUVFdn/DfSpMwAeuXZ
	 s8RiuDI6zjYVk8IydxYmp72Gc466lMvDpD72dnI8FFFmtHo9X65fu3zOzBlADYAe4VYD8
	 ma+a1lXyUOxsZ/c8d7UUuivspsv/n6j6FwB5iU4LZNKfO9jFdsqZ2IdAm2DeA0i0TPrBe
	 PRZjg6PQJaIA8TJIzgycema5aI7hCCEV7B7FL5QpSk0DcrU0mRwStKrAdoBc8HW9uu/c+
	 1as/g2/uSn9dppGdDqXd/tODfd8fL2a5wyZIoGHhvsHbovDy28anS5UWAk0ydxkZAJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TrUPSXRCxYG5OrHwdlfM/ahh/Z1XsoY0eQpsHzAAYP8=;
	b=VkjIsVGoIGTHIrwGedoTVR7J7/PG3kyPPyyQuE3zGHbJqexMuxliyomU2RGdr3UxSt0V
	 I9JuRAHC5KAj2AKZZxsY9mfWfcpMFn/jljl7OuIocD5mCU+5eU0UytxB0wN73sVPekgen
	 +7tnTE5Rk2TgG6mlOQKzv9vyK7Cj9yWV8MxMoKdbqvS+smMlAWdTVhIHnxP3yhWTFva9R
	 qP267x3d0TMw/Pzi19HXAua1iIVzGasSwVQUQBpt1XoWy3Bvb7AusiE3pEBUER0redPQz
	 18sieuO+3WY/2581XbFyeeWiTD/Be9E7Te0Mx3r0W8jdpuokQ759Hd7uAjcsq++yOGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=BFMhJH+T;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CDC606A32E
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 21:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79CDC606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=BFMhJH+T
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33fb4680717so229940eec.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 13:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793915263; x=1794520063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TrUPSXRCxYG5OrHwdlfM/ahh/Z1XsoY0eQpsHzAAYP8=;
        b=BFMhJH+T6eP0OqS3i4JHrj8Jn0mifzZT8dg1tp/DUembJfTBmxrsdH79T4M5FEMvKs
         dMmrqd0H0hWVVCWa2Bc6PS+rm6EkQ7iB7cs3n5LhHeYIEmNSCtdFW7rXCVP9W8TPD3W/
         zEqpxMhgCGrsnyA8c2RTCHvfivSibjU21wR+fGM0CaP/O79O8HUXpdSk/kch5VduHebw
         +elKQCRJwhSztOHJwG5QP0z0HAHVxqxD0hWc7WWATS3fAHH9X9MX44PtFEHJZQgNciV3
         qXIa2oZPUJkZW0ta8xZwoH+5nzbi7RrMTWc/2t7RPFoxAZlMqqfOp+7Src0sgx//c7QR
         nOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915263; x=1794520063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TrUPSXRCxYG5OrHwdlfM/ahh/Z1XsoY0eQpsHzAAYP8=;
        b=dAsgOl/q/G27mPV4ScrXzeZz+toGnZAocc6TrCMAb42dQDusyfwp1xYYXzgPv3L+5B
         9bYJr5Wkv20zzEWPhQlAjYrU1e8kqQoAICx+9emVzuTY4SYMkam6VUlnKBa3D/QhyHCk
         +caS/jAIkyhlgG1KgufX/+9aWWYMnfExGxFvaRouAox6E1YXab0IJZbg97k8xhomXzQE
         nHzkw3RHq6Mz+OTemrcQO8sih5J8TvTrOtkW1U3xF1w+LbwlxYbXI7wIncIyWNYSibUt
         j7nRiSLE3UWQBhWkL47Nl1hkdNEnzADArNmGJvoJ7ghX1dFznoer4tpBw2BZfT86BGiB
         sEUw==
X-Forwarded-Encrypted: i=1; AKwUvBzxGpcLuVHMjL3hP7K3sil1ReFJBAU111lkVkv0h4XgQoTzccNtEzyRz3SKsXj3YnUsPJhzh+Z3VANEjw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9tzcKa6BeizpmtsrWbt0p5ksjyt29pgJ1lM2YpdV0GfQeUed37
	5nDkMUbLTG/4XuvJfD5fALTKomgfeAtJKBB+cCstL1glVIY00wUO49ZiL+JZ5Ms3Ug==
X-Gm-Gg: AYBFou1u833yTDALcvv3D+gwsScVB62I0RS7GTPQY0RqNqZ10hHQNwqpoIAbFAJzmav
	/HPVV38XKOmGmdTNti2TGxm+4UN0NsmIkj1OE9z5T5b7wF0dPzfWxV6kjTFHGSXVF9ixck2rHdh
	xwe2ov5oslDIrRMfdyJdDFl+P3dbuLtE17+jcRIKZdN+MZfEpoCp6TIGbjhF499giAuBXKvSRDh
	5Gs19KmyvjNRRdFlVH0DjFAbclOA4Lc5ET3NY3PX7sWNDm0Gao5/eHkkuRGfgzCMb3d16pxujTi
	vW5ziy/ELJvQHKn7J20pzDfNL5z+kUHjyZXBBOSqO7sbiGWgaiZ1rZ3ZaXurHgWGqshImPRyuC5
	NX8KL0WSlDNCIcSo+cubafTO2kK3QEVTssNeEmYutBZUcA8z5Zulxnt3RpnBA43lPmg6xaQxI2S
	B30Yn0L3UeqwoL5MHKPRwpu3iJYjrnsVv1dxF4DqUsD3lB19nGmlXbRsYmVCDxWXOOq9WsLZuxV
	qIpqakrvZ5HKoZ9JuijuxoxZWDSQALFwaUTozFb1L0wKGO9773QU8OXHBwVV6w9KdLcwTy+2brQ
	MdQxbN9PygKNNPkzlAZgXZ4/koMCPrwzm0uwZA==
X-Received: by 2002:a05:7300:de07:b0:36a:1489:fdf6 with SMTP id 5a478bee46e88-36f75440d6dmr589169eec.11.1793915262296;
        Thu, 05 Nov 2026 13:47:42 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f71a25c1asm2036943eec.27.2026.11.05.13.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 13:47:41 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: mason@kernel.org,
	josef@toxicpanda.com,
	wqu@suse.com,
	fdmanana@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH 0/2] btrfs: balance item fixes
Date: Thu,  5 Nov 2026 14:47:36 -0700
Message-ID: <20261105214738.111967-1-smish149@asu.edu>
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

Patch 1 fixes a BUG_ON() in btrfs_balance() on a valid filesystem.  A
balance can leave its item in the root tree when the commit after the
insert fails without an abort, and the next balance then finds the item
and hits BUG_ON(ret == -EEXIST).  syzbot reported it, see patch 1.  The
new balance now overwrites the item that no balance owns.

Patch 2 is hardening.  Nothing checks the size of the balance item, and
btrfs_recover_balance() reads past a short item at mount.  The
tree-checker now rejects a balance item with the wrong size.

Found while looking into a fuzzing report.  An AI tool helped with the
analysis and the patches.

Tested on btrfs for-next df5b88a7914e, KASAN and non-debug kernels:
- Patch 1: on a new filesystem, one failed allocation in
  btrfs_start_dirty_block_groups() during a first balance, then a
  second balance: the BUG_ON() before; with the patch the second
  balance runs to the end, no balance item is left and btrfs check is
  clean.  The same with a failed allocation at each of the first 206
  allocation points of the first balance: no BUG, KASAN report or
  assertion.  Not reproduced without fault injection.  The other way to
  the BUG_ON(), a transaction aborted with -EEXIST, is not reproduced
  on this base: the corrupted image that hit it is now refused by the
  tree-checker at mount.
- Patch 2: a crafted image with a 400 byte balance item is refused at
  mount; valid filesystems (a paused balance resumed or cancelled after
  mount, a balance paused and resumed) are not rejected.
- Both: pause, resume, cancel and skip_balance work as before;
  fstests -g balance and btrfs/220: no new failure.

The crafted image is available on request.

Siddharth Mishra (2):
  btrfs: overwrite a leftover balance item instead of BUG_ON()
  btrfs: tree-checker: add balance item size check

 fs/btrfs/tree-checker.c | 17 +++++++++++++++++
 fs/btrfs/volumes.c      | 10 ++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)


base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c
-- 
2.54.0


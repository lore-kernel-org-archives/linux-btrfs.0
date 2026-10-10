Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392D235C6B5
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 08:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621517; cv=none; b=KotWptsm6zWxTAUKLwP6/ofj6SzAEXUNvpdNEWByTLNxAKvmaGPeRk10XJWJRNrLDyqn/kioDam1901ZMEA4CA9Lzh3/zsS25byRwVDCUOQmn2QWpbdhTdysW/QwCawgj8NhVj+2grcs3K/fYXVzR6I+Wajb2nJflYOT1k9j0xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621517; c=relaxed/simple;
	bh=9xpNnQqLXytp8X44PR1h7MI2cuBxO7fOJMEPyGlkPkw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=IEXMcxPikm0De/4py3DRWNYY/NfdwXL3PQbY8xM6Fw96PJ25uigOuu25a+rujorzRkLiQO4Me3F+6Tx+jjRQDdQDdq5x1eNFDlgw1qIY+M+AflyyPs20RqDJEEvnsa4zB3oQc8nKflGWP8w34ubWrK9vivrwGpRdfiLMTofXras=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNkJHXQG; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNkJHXQG"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so820485e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 01:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791621510; x=1792226310; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Rob4i7+V27nvvWkDOfWCSkRqomqDqBc4VZBhr7ZnSA=;
        b=PNkJHXQGwNxibWP1OdapZfnHFzs0rr/O/AO7MHKLVlznxQhpHiKUQ2VcNWEGQms80C
         ItG0MqayhjooPyfets7PQUoOo2VRb2QIoJhw59LhNcdoSrfBPpg7/P5kQdUDotIhhiSR
         MrgMoIBHj5Z1jwSiJeywy2X/YvRnm812Cou7S+bvjisSz5uUeerjnFTAB9MkO6TWJjCf
         06zKJ52uVpZYYQZmhMxOZF4ekQPPfkN5/hO7+W+rIkoy/I9GABojnk07zufrU871dI5A
         sVkAFixFDchRNHRFK2bnm+Gd4rtksviHkbgo/xjzROA+GmnfftfksWzXB6MNvhtXZ/VU
         gvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621510; x=1792226310;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Rob4i7+V27nvvWkDOfWCSkRqomqDqBc4VZBhr7ZnSA=;
        b=xsEicLhZUc6TYZ/HX7F8rOV3lnDXiBoqd2+er2HwHa6PebmTgWQWRIQslpG3N6izk1
         AinINklKZ2wHxfl0jD+ArhXiCgNsy6cAxJRt12BjZ3P2SAqC1B4Twd2CMZQBsUnrsDvQ
         Y+J2zb1FVbper8pp3AvzevIId6k3G670RDxRqdcg8+EUfaR4Midg2Eg2/+CO7qjUxihG
         q89DrLLGaNENYPbJEhBQqETGWO6V3B4Qhw1MFUweGGPEybLCWrB/EWFkv6n+UICKkld/
         +slnGnZZ95yo1+Puy64PuaIqP8DauNg98sYfvirzwfprTQERMGCi3i/923So4RzjziQ7
         7aKQ==
X-Gm-Message-State: AFq9FYIA3nhYL6qUvzitNr04hNy2c58e5dw71un5NPvlMJVGiwoloQ7b
	aqnppxjVcqN1SUDtMWa6mW0ziQlcur0dbJybrhYTlamLfoep57nZA96F+wpm+A==
X-Gm-Gg: AYBFou2SB+LhPSXIhei6iTmSl31/DQNEYaXP4icfw6HiJZ/6jrF0B5MWf6YcWmb6Cmq
	w+4GxCgTDuE8sxVRtWrFR0u2xI5QIW54jNJuwnwhEvoaYvJv9hiDMdt1TYJ/5ScYjyRCdUmvdqS
	RKRDdE53L71HC8oTdrsRdM8RIG4V+G6Drhi2KrC6mCPAKmiKeLAYmWNeW2RyJN3JeD84mOJjMK1
	vZklIy4mYQZ33ZamiOkdpt/727XscrvH/KgI8OkYEvHLQ0mQpI9olF/9pBw+J0T4mJQkEv2gfQi
	Da1xFL0wuZnQtyHr2vCmDbbelESq+C/PjCR/QS2aU0oBJNIzJIaDKRMyzw7iZtjEwyWZt4zWhOm
	hcTH7jDIJSJJYHbcYdCnp0uaX53WPBOfqQkXp21SNFxULFtMN+JNePxWwW4dVy6Jam5jLv2qaQS
	RhsrP/YKF81KmJ/l1kLGe5vlCjGXVZBo7XKZundlHaANAr3r+WVh8mpkPRArC79/4r8GuLEYrvz
	UrmLNeG6np/RbEHBef+66u/M765CTG1NeulJWmY4nNUqQelKDQKtRo0zATlau5DYk8=
X-Received: by 2002:a05:600c:8a09:20b0:4a1:9687:bbd4 with SMTP id 5b1f17b1804b1-4a19687bdcamr7741535e9.31.1791621510074;
        Sat, 10 Oct 2026 01:38:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:8a0:dd02:d000:8107:32ab:9faa:8dd7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf35930sm113847525e9.13.2026.10.10.01.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 01:38:29 -0700 (PDT)
From: Tito Duarte <duartito@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: fsverity@lists.linux.dev
Subject: btrfs: spurious fs-verity "FILE CORRUPTED" with large data folios (v7.2+)
Date: Sat, 10 Oct 2026 09:38:27 +0100
Message-Id: <20261010083827.27604-1-duartito@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Since v7.2, reading fs-verity files on btrfs intermittently logs fs-verity
verification failures although the data is intact:

  fs-verity (loop0p2, inode 2980): FILE CORRUPTED! pos=1355776, level=-1,
    want_hash=sha512:8c662f97..., real_hash=sha512:2d23913d3759ef01...

The read is retried and userspace gets correct data, btrfs logs no csum
error, and a file without fs-verity on the same filesystem always reads
back correctly. Both SHA-256 and SHA-512 files are affected.

Cause
-----

end_folio_read() -> btrfs_verify_folio() calls fsverity_verify_folio(),
which verifies the whole folio; start/len are only used for the
uptodate check (fs/btrfs/extent_io.c in v7.2, unchanged in master as of
2026-10-07). With large data folios, a folio can span two extents and is
then filled by two bios. When the first bio completes, the whole folio is
hashed, including blocks the second bio has not read yet.

Large data folios came with cc38d178ff33 (v6.17-rc1, behind
CONFIG_BTRFS_EXPERIMENTAL) and became the default with 9bce95edb1b4
("btrfs: move large data folios out of experimental features", v7.2).
Neither commit is wrong in itself; they expose the whole-folio verification.
In v6.12 a data folio is one page, so whole-folio and per-block
verification are the same thing.

Evidence
--------

1. Natural occurrence, arm64 VM (Apple Virtualization, virtio-blk,
   4K pages), reproducer below, 30 mount/read cycles each:

     6.12.111 (Debian trixie)                     0 reports
     7.2.6    (Debian trixie-backports)          10
     7.2.8    (Debian testing)                   10, twice
     7.3-rc3  (Ubuntu mainline build)            10, twice
     7.2.8    (Debian) + the change below         0, three runs (90 cycles)

   On this machine real_hash was always the hash of a 4 KiB zero block
   and the failing block was always the first block of an extent (10 of
   10 checked). That fits the first bio completing first: the first
   unread block is then the start of the next extent in the folio.

2. Forced reordering, x86_64 QEMU/TCG: delaying every second read bio of
   a verity inode by 20 ms, 10 cycles each:

     9bce95edb1b4^                                  0 reports
     9bce95edb1b4                                 100
     cc38d178ff33^  (BTRFS_EXPERIMENTAL=y)          0
     cc38d178ff33   (BTRFS_EXPERIMENTAL=y)         91
     v7.2                                          99
     v7.2 + the change below                        0

   In all failures (160 logged) the folio had blocks that were not
   uptodate yet, and the failing block lay inside the folio but outside
   the range whose bio had just completed. Here real_hash was not the
   zero-block hash: the unread blocks held stale page contents.

3. Distribution kernel: openSUSE Tumbleweed kernel-default 7.2.8-1.1,
   unmodified, with dm-delay reordering reads: 13 and 12 reports in 10
   cycles. Without the delay x86_64 hits it rarely here (0 to 1 in 120
   cycles under TCG), which I attribute to TCG's timing, not to the
   architecture.

No checksum mismatches and no btrfs errors in any run.

Suggested change
----------------

Verify only the range whose read completed. Each completion then hashes
its own blocks, independent of completion order, and the folio stays
locked and not uptodate until the last range is done.

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f032f08..6b6cf0e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -482,7 +482,13 @@ static bool btrfs_verify_folio(struct fsverity_info *vi, struct folio *folio,
 
 	if (!vi || btrfs_folio_test_uptodate(fs_info, folio, start, len))
 		return true;
-	return fsverity_verify_folio(vi, folio);
+	/*
+	 * Only verify the range whose read just completed.  With large folios
+	 * the other blocks of the folio may belong to a different extent and
+	 * bio that has not completed yet, so verifying the whole folio here
+	 * would hash blocks that have not been read.
+	 */
+	return fsverity_verify_blocks(vi, folio, len, offset_in_folio(folio, start));
 }
 
 static void end_folio_read(struct fsverity_info *vi, struct folio *folio,

Not covered by my testing:
- Subpage: fsverity_verify_blocks() needs offset and length aligned to
  the Merkle tree block size. With a Merkle block larger than the sector
  size (e.g. 64K pages, 4K sectors, 64K Merkle blocks) a single-sector
  range is not aligned; that case would need verification deferred until
  the whole Merkle block is read.
- Compressed extents and holes (same end_folio_read() path, untested).

If the approach is right I can send it as a proper patch with a Fixes:
tag, or leave it to whoever prefers to handle the subpage case.

Reproducer (root, scratch machine; needs btrfs-progs, fsverity-utils)
---------------------------------------------------------------------

-----8<-----
#!/bin/bash
set -euo pipefail
CYCLES=${1:-30}
T=$(mktemp -d /var/tmp/btrfs-verity-repro.XXXX)
cleanup() { umount "$T/mnt" 2>/dev/null || true; rm -rf "$T"; }
trap cleanup EXIT
mkdir "$T/mnt"; truncate -s 2G "$T/img"; mkfs.btrfs -q "$T/img"; mount -o loop "$T/img" "$T/mnt"
head -c 40M /dev/urandom > "$T/src"
off=0; i=0
while [ $off -lt 10240 ]; do
  n=$(( 97 + (i * 137) % 331 ))          # 97..427 blocks: extent starts not folio-aligned
  for f in a b c; do
    dd if="$T/src" of="$T/mnt/$f" bs=4096 skip=$off seek=$off count=$n conv=notrunc status=none
    sync
  done
  off=$((off + n)); i=$((i + 1))
done
fsverity enable "$T/mnt/a" --hash-alg=sha512
fsverity enable "$T/mnt/b" --hash-alg=sha256   # c stays without fs-verity
sync
want=$(sha256sum < "$T/src" | cut -d' ' -f1)
reports=0; mismatches=0
for c in $(seq 1 "$CYCLES"); do
  umount "$T/mnt"; mount -o loop,ro "$T/img" "$T/mnt"
  dmesg -C; echo 3 > /proc/sys/vm/drop_caches
  for f in a b c; do
    [ "$(sha256sum < "$T/mnt/$f" | cut -d' ' -f1)" = "$want" ] || mismatches=$((mismatches + 1))
  done
  reports=$((reports + $(dmesg | grep -c 'FILE CORRUPTED' || true)))
done
echo "$(uname -r): $CYCLES cycles: $reports fs-verity reports, $mismatches checksum mismatches"
-----8<-----

Disclosure: I used an AI coding assistant (Claude) for parts of the
analysis, the test harness and this write-up. The numbers above are from
real runs on my machines; logs are available on request.

Thanks,
Tito Duarte

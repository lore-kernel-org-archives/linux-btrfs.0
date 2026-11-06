Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978797;
	b=tubN1k28oFq9IsN8wF6fOqaeIspDuMroMyU14uzpXuS7xV2ixHNWWQpi4uPwktlhiVSc
	 //igzYzrliPudJg7sC8ejwEScrd5nOZfhHgDYQ5k6/EPJyw5AcjtoY+8DFsdcxK9bJmoa
	 kkTLCMM9ulRO5G1JufQcC/7kpm43UV7dubLzlaWUN8Pdbv4HK915YZU93U/IAwsAdaNwD
	 9ii2zksTLx5v8JXkPHE55/Ir72/ekZwbUx9HpMzuz6dlHVAh0A9z6ysX+GNrjFNMiSKzt
	 P9bNwvih29QIjWdjsbVp78QlTXQnUOOQBxnfIoUQKv4oIvE+zjjbg69Q6L+bAv1dxGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978797;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=UIxBh+zRJVkTKkXW/+Fu4zhs3mLcL4i3tBZ3X/u5LeQ=;
	b=HqlY/FadSwIMmsQqEhI6QEaRX+BCiaJdqZ3Ff9W/gtK59GScZe7QooLw86WhyehrNT2r
	 nz7F0TosdDZvPeGLDVleGyRUk1848KqhwSv/ZD4if8yAUbEkHBXbMZJYmvkjyrD/FzNSw
	 B3Usev81qjR1nN85z0Tkg9XsD41736h0LQ/gubhDC4CerXV0abAUCLO+SxGGCddFkH+zm
	 Kw+6HAhJaxD2W8ujkR+HIhPPwk2ReeO+2rA00XKQqUkQlIdEwYakno67CFNjP2NbnVYGC
	 zHwuHKOyIp8pJtzkFYbPYoo+n29OjhFgCQX2AMSiPTC4HLh0QWm/R5JUyweqIJRaXDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=tzD3GYQt;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE25606A332;
	Fri,  6 Nov 2026 15:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BE25606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=tzD3GYQt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=UIxBh+zRJVkTKkXW/+Fu4zhs3mLcL4i3tBZ3X/u5LeQ=; b=tzD3GYQtC18ZlmPw4JresrP5iA
	USsHZcOQ67Fk1flH3ViDAuTvf6iMLfRizn8Ffr7GgA5yox4JAaAq144RCkadog6YvNkbzzGOv0ycf
	QRl1xxYN3KPMZFEWmxZkQ2fBJuUjCvEx0c5Md9plZZJsMcO6LYfdLqAXulFRcRcdqzjPPTDZ9kCT+
	GTv1CRIQ6OICUjGkXz/qjW2OXyROdqZHGm0oSueyKbf54XQ0tcqQh/NbXGh3leHlbLGZ4Vaf/r9Bu
	OexKkjye9RL5AemAjK1ELaOMaG4tFCUfBRnYRuarzaDxdDafgWq+VlFu9DPLvff9oGuuj/ED7fyWT
	k+4weIXw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPLpq-009NUW-1r;
	Fri, 06 Nov 2026 15:26:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 07:21:11 -0800
Subject: [PATCH v2 2/2] btrfs: drain in-flight direct IO before zeroing an
 unaligned EOF block
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-btrfs_page_cache-v2-2-f57575d0071d@debian.org>
References: <20261106-btrfs_page_cache-v2-0-f57575d0071d@debian.org>
In-Reply-To: <20261106-btrfs_page_cache-v2-0-f57575d0071d@debian.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@kernel.org>, 
 Boris Burkov <boris@bur.io>, Atish Patra <atish.patra@linux.dev>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com, stable@vger.kernel.org, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201; i=leitao@debian.org;
 h=from:subject:message-id; bh=9VDZR0ipfUyh1vgVGQArt/gpNnJfH39nLr9aJFg2lt4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7fGdnxAvTzK+p1Ov0ZlWSX5nkQcHKqGIfQtvb
 IPuwJNvogqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3xnQAKCRA1o5Of/Hh3
 bVhUEACZMXzKjxEaoHK7ypneRs2+41hPOOfbjZb18sqcHLsVXgUJwV2O+IaUb8QkVmBN4OawZaO
 1qrO+H+ka8yKydmPuLKcRW3+vCq0HUZ061OUidC7uYTyYx0kskZvInA/M089u8WWSV2kosCVDfu
 tYHJldYy7xYWQnqnzDzD03aFqpADshHBy+XZF2vHQ2yk+Ma+FlHRKl5edPE2MHzIrAdJ5UaF/PZ
 PiGNM8XkVrJtSGcfzllq3CVVjrXeFT2TFeT+Oa3y1piD9BBpw8eO78fDaXE+Pkz7Fta1KDDyOAj
 wx9p2xyij2lRQjEVl1h2fcMZtMZKydbo3WXJ1zrgjNCIl+6gq3zhCdQ0hJHWcgOqPbGZS4V1TSG
 6z8NUWD54OGgvEJn1i+0QOaAkRmS4upbxXLL5bAC4MzfUiT+G3O6YY3z5vOe9pYUGCwH2SD7MeF
 aNUB9ZixZarIAmTZrkNC29Bemo9VbdZ2Qsr41Lzi5KZdl7fevryQaroGjMiDrqvGpigCF7zBMrg
 xjde9d4R7FXwHw12iPfzOV6YjrnuUI1ot37ITs3GpKDhrideNXNJGbzTIBwVMqJfeGYSTbKUtZi
 VIVxLdciAk41uATHQLmPgqOxxpbnJXucxXh2djA5EjKqmbc4RWuiuVRsQ2Y85kYN0pSmquEXXum
 pcRkRbP30Kku1IQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A write that starts past an unaligned i_size first zeroes the rest of
the block at i_size: btrfs_write_check() calls btrfs_cont_expand(),
whose btrfs_truncate_block() reads the folio, zeroes it past i_size and
marks that block dirty.

Reading the folio waits for the ordered extents of direct writes to the
other blocks of the folio, but not for their iomap completion, which
runs separately from the ordered extent completion and is where the
page cache gets invalidated:

1) Task A has an async direct write in flight to block 0 of a folio.
2) A fallen back write or a truncate left i_size in the middle of block
   1 of the same folio. Task B issues an O_DIRECT write past i_size, and
   btrfs_truncate_block() waits for the ordered extent of Task A.
3) Task A's write completes and its ordered extent finishes, so Task B
   zeroes the rest of block 1 and dirties the folio. When iomap then
   completes Task A's write, kiocb_invalidate_post_direct_write() finds
   the folio dirty and records -EIO in the mapping, so the next fsync()
   fails.

btrfs_direct_write() calls btrfs_write_check() before it decides to fall
back to buffered IO, so this hits direct writes past EOF as well as the
unaligned ones that fall back: for those, the inode_dio_wait() in
btrfs_buffered_write() runs after the folio is dirty.

Wait for in-flight direct IO before zeroing, as XFS does in
xfs_file_write_zero_eof(). Unlike waiting for the ordered extents,
inode_dio_wait() covers the invalidation, as iomap_dio_complete() calls
inode_dio_end() after it.

Only an unaligned i_size needs the wait, as btrfs_truncate_block()
dirties nothing otherwise. Buffered and encoded writes past such an
i_size wait as well, since they share btrfs_write_check().

A reproducer keeps 4K AIO O_DIRECT writes in flight to the first 15
blocks of a folio of a NOCOW file. Another task truncates the file to
end inside the last block of that folio, then writes past EOF.

On a 64K page VM it got 56 fdatasync() EIOs in 60 seconds before this
patch, 38 when the write past EOF is 512 bytes and falls back, and none
in two runs with this patch.

Qu Wenruo pointed this path out, from a Sashiko review.

Fixes: 95ea0486b20e ("btrfs: allow read-write for 4K sectorsize on 64K page size systems")
Cc: stable@vger.kernel.org
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/btrfs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2017a96814d857..15802db7b664b8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1063,6 +1063,13 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
 		/* Expand hole size to cover write data, preventing empty gap */
 		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
 
+		/*
+		 * Zeroing the block at an unaligned EOF dirties its folio, so
+		 * drain in-flight direct IO first, see btrfs_buffered_write().
+		 */
+		if (!IS_ALIGNED(oldsize, fs_info->sectorsize))
+			inode_dio_wait(inode);
+
 		ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
 		if (ret)
 			return ret;

-- 
2.53.0-Meta


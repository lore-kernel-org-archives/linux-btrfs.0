Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978793;
	b=AQbGZoeI6tI2eWHj9i3qsKdYJOBEWAdEjqwOoVW+yG5deWVRpEPHXHIh2T4+ApGl6k3U
	 WtTfsdP5D5cEL4qOXtjVrb3A+TcxJ86oF26KQhrPBBFJ/OFcXeI3QwxTKXvq5G8l7kNxe
	 zRKProrgoMIpX6qx/51vtb3TFgYjfW5qNYqMwIzxgre34yvnQGWlyykKUI9iMSbmEaOVK
	 kORthYLx79M8D6ZQxz5sj1p2Ntah17955aIXz033gSaNZsgFbt4C6MJRDQGXe1Tt4bFF8
	 iiL8SF8IqjbNJft6PBcYWzY3vPUPgHyIjLFFJYTA7IvEGwYSEbKffrNoPP8X9ynri7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978793;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=RQAtz/m33TxBAFSUKoNroGq5UJN0w9TobNeTbUbXQyE=;
	b=D7Hom5XkTredQE9xe6vCzrklAC1KciK35xUXceR15Fxrh1SungVa+Pv8p2w5Yk2RH/E+
	 WrZJkEbCogudz7mBxIt2PD8HoBkqUF06XLfXaWLTImLBNU9+L67SQ1jBkqVPiApOm6YdL
	 BWLqf3ut8jmHym3h+Bzs5Dc5TgBP4Jjo5oBs28z7tMU5A6FLMGlA80uTNPhRAa6M560wb
	 qhjs2dDQj3MubUnjBacpQzO7x/zRGDkcqmLSzQbIKLq50ZSysxcgBrmCgq0omsBJj3U7C
	 pMvgE2Ut/DMlPIPL30ADUM0AYGU87AjIMLLfxChfInr5k/U8iyyzQL/2AksA7GVUfEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=urIhFT4E;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92417606A32C;
	Fri,  6 Nov 2026 15:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92417606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=urIhFT4E
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=RQAtz/m33TxBAFSUKoNroGq5UJN0w9TobNeTbUbXQyE=; b=urIhFT4EpYfcO1C979/kJQsmeK
	PGoGdVjQNC4ELOyUDKUfm0OyJP6cEud3WQxXT1j4fIUdB34eitUZLtgVHWke1WVItjc39z2Jhzvsm
	29JTwG6+8d3gD0oU3HXNBZ1Ga41pP3DDdtdywdjMNfwMxTwxd9MM52wbOUCIU0AbIvtbiVqVlUvCf
	WHtnpNJyvURPxfVJQU0f8s22bdBbqb1noNr2MAY9dQi5zBXy7C2ff5BXjiTpUkmysy1EMKH/ei/uP
	STs+iRcGaQNeK5k+g60JYq6MGOjjEHi9afaWgQQL9kwLG3IhqU4bVEq+nCfuavF7W9vyu45qyWV63
	SIcA2CMg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPLpm-009NUK-1h;
	Fri, 06 Nov 2026 15:26:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 07:21:10 -0800
Subject: [PATCH v2 1/2] btrfs: drain in-flight direct IO before buffered
 write fallback
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
Message-Id: <20261106-btrfs_page_cache-v2-1-f57575d0071d@debian.org>
References: <20261106-btrfs_page_cache-v2-0-f57575d0071d@debian.org>
In-Reply-To: <20261106-btrfs_page_cache-v2-0-f57575d0071d@debian.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@kernel.org>, 
 Boris Burkov <boris@bur.io>, Atish Patra <atish.patra@linux.dev>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3198; i=leitao@debian.org;
 h=from:subject:message-id; bh=51H8zXKgngaqQwgvwzrRuG8PXU+VQbw68ehg8y5PTDE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7fGd8ms27rGGThTiIg6oY20mST3+A7Nzdtfqu
 4650clhJOGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3xnQAKCRA1o5Of/Hh3
 bZqjD/9CYz26SiyrGAOIYT22++FfHKKt4SuZXbxZcEi1iChAhv5ywAY1JFBAwZ+auyQ3+k+SHXH
 BV+3hqW27cX6Xyux2+gEWB5NJsJUoLvVA8RlPzX+XhF+lDldqbiN4lEuZ/ZLJg+ZZELAChJN4zR
 AcBcnjlKAT/ikPf/VS9iPx3BxWpfSaNAjNGf0PTQy/vcrnvGsURIMrA7eXdJx1zp4+BHKO9w23m
 utZ6PvJUxUAHQQi6jxO4gLfhdSs5iOo5yU0WA6YpcdClsCrxIubU7/FycgkVivmCnGIp7pGgtwH
 hupgouRWSvMs9ZJWhG//GLVnnbRjuH8uVq1fTd69YRUQYKEJrlHcKV8qRNeGCUKqhSSiOWN9hst
 ABtmBkDcwUXcbuVYcm82hCt3T58RLaELA7uj/sbBnBr9TfMC9FQy/01/7gRhZjkteuhPQ9TmiYl
 ntChSCWuJomGMafqbe2fBUNsE9V4ablK4Aa4tv5FTmwXDhzD0sbUSyI/2L1QwVw1p6aF1ZmAFxs
 W593VTTzrkxvY72hAx+BPC/dsx+5ouRoCxz34wa4dC1gYIBypTbJ7Ql3ceaAaUJYHwoMZ5jWzQt
 otOVTNcx0rPz5OkPcYVk6jKlbWngGcye4OoEtCZj3VPt78xqx3LWkzoPzLKszsvpSxFEUARZGnn
 wIOK7xEA8AkmQDg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When btrfs_direct_write() cannot do a write as direct IO, because the
offset, the length or the user buffer is not aligned to the sectorsize,
or the range has compressed extents or page cache, it falls back to
btrfs_buffered_write(). That dirties the page cache without waiting for
direct IO still in flight from other tasks:

1) Task A submits an async direct write to block 1 of a folio. iomap
   invalidates the page cache in the range and submits the bio, and the
   inode lock is dropped.
2) Task B issues a 512 byte O_DIRECT write to block 0 of the same folio.
   btrfs_direct_write() falls back to btrfs_buffered_write(), which
   dirties the folio.
3) Task A's write completes. kiocb_invalidate_post_direct_write() finds
   the folio dirty, invalidate_inode_pages2_range() fails with -EBUSY,
   and dio_warn_stale_pagecache() logs:

   [    2.048568] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
   [    2.048574] File: /tmp/diorepro.JTCKpJ/block.img PID: 260 Comm: kworker/11:1

   It also records -EIO in the mapping, so the next fsync() fails.

The two writes do not touch the same bytes, they only share a folio.
With 4K blocks on 64K pages a folio holds 16 blocks, so this is easy to
hit there. Meta's arm64 hosts with 64K pages hit it with VM disk images
that are NOCOW files on btrfs, opened with O_DIRECT. In a test, XFS on a
loop device with direct IO on such a file gets EIO on a log write and
shuts down within seconds.

Wait for in-flight direct IO before the fallback dirties the page cache,
as ext4 does since commit 15cdefd0c052 ("ext4: drain in-flight DIO
before buffered write fallback"). btrfs_buffered_write() holds the inode
lock exclusively there, so no new direct IO can start until the write is
done. NOWAIT writes never get there, as btrfs_direct_write() returns
-EAGAIN for them before falling back.

A reproducer that keeps 4K libaio O_DIRECT writes in flight while other
threads issue 512 byte O_DIRECT writes to the same folios of a NOCOW
file got 1123 fdatasync() EIOs in 10 seconds on a 64K page VM, and none
with this patch.

Fixes: 95ea0486b20e ("btrfs: allow read-write for 4K sectorsize on 64K page size systems")
Cc: stable@vger.kernel.org
Reported-by: Atish Patra <atish.patra@linux.dev>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/btrfs/file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa03f..2017a96814d857 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1334,6 +1334,14 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * A direct write that fell back to buffered IO must not dirty folios
+	 * while direct IO is in flight: its completion fails to invalidate
+	 * them and records -EIO in the mapping.
+	 */
+	if (iocb->ki_flags & IOCB_DIRECT)
+		inode_dio_wait(inode);
+
 	/*
 	 * We can only trust the isize with inode lock held, or it can race with
 	 * other buffered writes and cause incorrect call of

-- 
2.53.0-Meta


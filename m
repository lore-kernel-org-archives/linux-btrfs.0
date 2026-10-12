Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E62368D7E;
	Mon, 12 Oct 2026 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811816; cv=none; b=jMYToVC1NRfblk/naRwjBX0aD5hhqylUIjrFJzU1V+K3cVfVwNKmNZdf84zcsIat22BW3wiF/oBCQgmbnNu5dM9fnHlQTybe+LUOIPwkzqVMpyazvDbpYxXAKRuZA533KoOcbc/e1yyWRO1yBtSFUWwjnzwH8xuwFUU46i0ocTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811816; c=relaxed/simple;
	bh=Sbsx+feZ80i7o5fv5826kgA4Rel0zblyuQEjCT3J4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLN/InmiQyz44HtPHrjrMpv/2jcci6bHxGuPlrv9g6hajJHJ3U3IlX0yUwQ8YycGogRxSEYJ80c1p1/Ta9I/vlSOEUEEdBbYZKxRshQVpsazVN1RSnWwXjqWbYMVMy1tCml8x2rvlWNwHXplKmgpEOUyy5ai7JfljsFhw8VaaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=PkcBejTi; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="PkcBejTi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=6X
	MoCoxsxJbwrxJPrcBZACpAAbXCdOzJjPbpwaSB00M=; b=PkcBejTiCF3a6277hC
	IZGOe1O6O2BTTAzgDc1uKK4mpvID7bK3UyF/BnRGZJhN0gsJ5jwh+qXPNC6dXsD6
	uLG70Aot9Wm8pf6971koBwC6+Kn+3UjrsSptTt70155htV4OFbmmR1SNjZYm1XEy
	vGFiNq0Tm0sbAkmbtsMQbtkLA=
Received: from song-MS-7E28.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3n7am4MxqMdzZBA--.33230S4;
	Mon, 12 Oct 2026 21:29:18 +0800 (CST)
From: Song Chen <chensong_2000@126.com>
To: dsterba@suse.com,
	mason@kernel.org,
	akinobu.mita@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	ees@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Chen <chensong_2000@126.com>
Subject: [PATCH v3 2/2] btrfs: Allow error injection on btrfs_data_csum_ok
Date: Tue, 13 Oct 2026 05:29:10 +0800
Message-ID: <20261012212910.54623-3-chensong_2000@126.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012212910.54623-1-chensong_2000@126.com>
References: <20261012212910.54623-1-chensong_2000@126.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n7am4MxqMdzZBA--.33230S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFWfZr4kWFykJw1UAFyxKrg_yoW8Xw1Dpr
	yUG345urWDXr97Gr4kGayv9ryFgw4DWw4vgFnxJw4UKw4a9w1Fvr92y3WxGa40krZrZa43
	Z3Z0qr17ZF1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bYVysUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBsg4xsGrM4K6yAgAA3l

btrfs_data_csum_ok validates the checksum of a data block
after a read I/O completes. A mismatch between the on-disk
checksum and the one computed from the read data indicates
silent data corruption, which can be caused by bit flips due
to DRAM errors, storage media degradation, or bus transmission
faults.

Testing the error handling path that responds to such
corruption, normally requires reproducing the hardware
fault, which is not always feasible.

Mark btrfs_data_csum_ok with ALLOW_ERROR_INJECTION so that
the fail_function infrastructure can override its return value
to false, simulating a checksum mismatch without requiring
actual data corruption. This enables validation of the full
error detection and reporting path in a controlled environment.

Usage:
        cd /sys/kernel/debug/fail_function
        echo btrfs_data_csum_ok > inject
        echo 0 > btrfs_data_csum_ok/retval
        echo 100 > probability
        echo N > times

Acked-by: David Sterba  <dsterba@suse.com>
Signed-off-by: Song Chen <chensong_2000@126.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93ef3cec191e..73c801197934 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3586,6 +3586,7 @@ bool btrfs_data_csum_ok(struct btrfs_bio *bbio, struct btrfs_device *dev,
 		memzero_page(phys_to_page(paddrs[i]), offset_in_page(paddrs[i]), step);
 	return false;
 }
+ALLOW_ERROR_INJECTION(btrfs_data_csum_ok, FALSE);
 
 /*
  * Perform a delayed iput on @inode.
-- 
2.43.0


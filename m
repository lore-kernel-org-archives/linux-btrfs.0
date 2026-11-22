Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795389805;
	b=C8l4foc+dYyLni1Ze36f/OjwXAq83HeO0acQSKjTVuVrUSKd8bYqicv5qESYPHmrdDdZ
	 y1xd7Ny0w2Xqb+/FmnF+8Nhh4VCzYDRWFHXUue41bWKLHIZMwLrwnZmh37y4qVsOPwkNu
	 micOtwf3uzy8atdxQyNamGavssSmxRFLRGsA87/cgyPJvlHeRF6JOgvcVULb46740lLpS
	 I5OIuZyxc8Ps+0AGYVB/4o/erhUYPSA7FpfcvvZtasv+8HXkYX6Od4LISHIYyKNwQl/aX
	 Nz2I+7tdSKK1hQjtAUH1xf9HuNDL5pGoP2cEzQS8sYQbGgzcMdUxSZbIR+QcqhOTQOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795389805;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qrMF8h8xKXx36b/vmmxyp6BuxuBSwpMbF6hqb6Hn1hY=;
	b=V2UrydIUvjwRxzXsak21PcKhclYm2XJ4kA/wD6kDFZOAT1O6x3KupJ/DOrReyoG1qTo/
	 O95nNlLVIKSHwxT7Lj9AEXUD7HEXFDG1XTi5cnteOMfQCsq9kDk8QGLPI2LGUQuZti60l
	 ghPLt/+C76MPUcJmtzg08sYLCIVE8wSoSck4bfCDJKZQG69Cv6uFaOojimkkwnDPLbGaM
	 ljpJk3A83j6MtCW94KkpuY0OhynxnzKExO1ghc/upZPPcyFjKNNUTGT0ObDfDsXFNCxpE
	 fS+BdpA5O+w8DnQkw/0sT9brYKRjoQ8PAouuuuIXc5NoT+INauxbjZpRGO2oIHcag5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=xfE60wMi;
	arc=none smtp.remote-ip=79.135.106.111
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F2606A335;
	Sun, 22 Nov 2026 23:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0F2606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=xfE60wMi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795389803; x=1795649003;
	bh=qrMF8h8xKXx36b/vmmxyp6BuxuBSwpMbF6hqb6Hn1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=xfE60wMiKpX3bd8ECps2MU6GtqOGzPoHneMARrh+MiT+t7n8/T99DW3/UM1xqModK
	 uNGWt+3u5Lqdd707p94QPaBHJeAB1aEe+IvMFSsNzxpPQy01QIWpNI4XWS/4cA8rM9
	 7EKtMAOlNyjMSPcQFA/uRPsbL1/Vt3syTYlJYlRIdKKxlTXpX9kR3omz6il0dut0NJ
	 FK+80u6qVEFDnCHngiblHFqHC967pXJw7Nym3+vALTF7bPzA44/XAo5nkiCFLgqDTg
	 ZoOgkbLAY8lqrS2mWz03FNLjseIzp1wG7na5umbhzfvcVQ9P9Upre3zsggHM4YyUwE
	 Q+DefWcCspBuA==
X-Pm-Submission-Id: 4jXlVy1RwJz2ScQM
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] btrfs: zoned: do not WARN when zones fail to finish before relocation
Date: Sun, 22 Nov 2026 23:23:10 +0000
Message-ID: <20261122232310.4099580-4-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122232310.4099580-1-mc@raidlab.org>
References: <20261122232310.4099580-1-mc@raidlab.org>
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

btrfs_relocate_block_group() finishes the zones of the block group
before it relocates it. Any error other than -EAGAIN hits a WARN_ON().
However, btrfs_zone_finish() also fails when a device fails ZONE_FINISH.
A device error is not a kernel bug, and relocation continues either way.

Print a warning instead.

Fixes: 7ae9bd18032e ("btrfs: zoned: finish relocating block group")
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 fs/btrfs/relocation.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c7b5a655e89f..b60d9a0c5c1d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5538,7 +5538,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->block_group);
 
 	ret = btrfs_zone_finish(rc->block_group);
-	WARN_ON(ret && ret != -EAGAIN);
+	if (ret && ret != -EAGAIN)
+		btrfs_warn(fs_info,
+			   "zoned: failed to finish zones of block group %llu before relocation: %d",
+			   rc->block_group->start, ret);
 
 	if (should_relocate_using_remap_tree(bg)) {
 		if (bg->remap_bytes != 0) {
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793036398;
	b=g+/DbTeSaBOTkll29UG8sV/o8WIiTQjKpbOyR2AHVriORcJmYMeCUmmMEHoazfWp18SQ
	 d1suWCS6EN6ZN/jPBOzdM+l3qwZAF4jR2FbDSD/vcH5mSlGJi09H4ZwK2/lNAtYBJYTIJ
	 xkzwNEelP241nxXCGlSlmfyE2U0hrBQqwDzmRU5GQtcIyfSvuqZM/tv+0rGhCWVpcMdx1
	 rax0Te0R8f7APBBwDAml9OSZR8eL1FTrqsJDmTXTQ/KKIbonTQ/G/EtQaBDAomou/yeSD
	 nfO8vBKErCQZCJjPE87o3qLrdBZ7wbsegC0rcXnNSoTGFzX80phlZ7VHPhRjo75fUWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793036398;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Vt30iYKRWh5txPwEJLo+Be5RCAkCgMAwTArYckxx5I=;
	b=YvN8AVqF4hpvVx4fteD+Imf+9XzA4f2VtIfFoRQNAYgIrh8TzigLOnjMk7T0NLy6lpPM
	 b4jXUvs9pFKl8vYnBT6+bXO5jYLNC6P1qxGgpogZTfwVph0HdF9NxNCz5F3NX4KiNAZB7
	 1gt0zRm2xo+lVn1nIYb2P7QIN00r5wtXlAXmlv8x5/xHBHliR2aho/Bzcvw5h6eQi+Jgp
	 E7GynVHyV6SsNF23m7oarRzZ/WfeEMuOL1ANZmaGoshUTc3gH+B7LrwBgQWUkfLaOQ3jy
	 7oPT11rIUjYqq2vuQ+xpYL8skJWyd4HEEBbsH8k3wmFEz2vhRk4EFCrXDhc/8yJ+YMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFYgRAN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6561606A31F
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFYgRAN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA681F01825
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793036397;
	bh=6Vt30iYKRWh5txPwEJLo+Be5RCAkCgMAwTArYckxx5I=;
	h=From:To:Subject:Date;
	b=DFYgRAN88OOvrnA6SB884jkZlDhqljQex82O0H7oCbeUo1rVirjAUCBO2rSvJPQyN
	 PLqdc02Ro+xFM1VVChFHJvK0zY11Z1x7tGvpP/51D07Ggv+OzJ/lePPOGL1t7FkkCu
	 r5axO7BP6l63oYHwWXKN3X/lVHe8iFi2vQ0Li3xy3XReObYGk/2wf1IN5URXta26S5
	 izDilZdgvOxGwRS4tFu0z5o9kGePlLvkhABl9G1b8jPaIm1gl1OJPLLgE0wUhsNGa3
	 Oc2zJsZVSh63IUdUPa5e8WXOUqy5jLDLXkgaZ7QpjlrFGmwrjtIK8JCGL2HU85b86/
	 FW6bUerog3Y/w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: lzo: use memcpy_to_folio() in copy_compressed_data_to_bio()
Date: Mon, 26 Oct 2026 17:39:54 +0000
Message-ID: <2f15acc9dd04f6a3ea6d0895f9e47ff20886df7f.1793036279.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

We are manually mapping the folio, copying to it with memcpy() and then
unmapping, but this can all simply be done with memcpy_to_folio()  that
is provided by the MM layer. So use memcpy_to_folio() instead.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/lzo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0b2d9a825543..00d3dffa1657 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -234,9 +234,8 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 				return -ENOMEM;
 		}
 
-		kaddr = kmap_local_folio(*out_folio, foffset);
-		memcpy(kaddr, compressed_data + *total_out - copy_start, copy_len);
-		kunmap_local(kaddr);
+		memcpy_to_folio(*out_folio, foffset,
+				compressed_data + *total_out - copy_start, copy_len);
 		ret = write_and_queue_folio(out_bio, out_folio, total_out, copy_len);
 		if (ret < 0)
 			return ret;
-- 
2.53.0


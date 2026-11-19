Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795121658;
	b=bYtcpYC/eOG8S3/8ws8oGVC1JXYFUCTSFda3it8gqJdN1nsQ3t0PUuSi76ysBa3BE1gB
	 /NFLPYVxaAHhpXZAoE7TJO4ATK06atiUKS692nHRNVxPqcsIPuUpMNHpciB6H2pXz12R4
	 YrycMngOvNBK6SZ34mh4ImO1Sg99s/fEoZ0LfV0ENKS0h4vcwEh22ky7LrkeTfTGSUKxE
	 97QR0Nu60UtPFO3ejY/PLW50TbtbnX3okwgmg9wl+1dhkHMF3dvQY5UIDPROmudiPWCui
	 ML1LV8MaAryHPOiFzzuGkQzSGSwuZthfhI7rkaEfXJuXZuFJIyUOxtBRVKzUeSNPxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795121658;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0p+q8IpVTNOek8hpj/iQcusogTuctDnbBAIvKsNy3fQ=;
	b=dAclDpe/HPAL47pfflaSwjTNic0VTIQ+qnye3/Gs+A1fj6EdjaUUcdphPrVsdNXPuK3E
	 5Z+X5Q07ysnXmLkjOJ8EaZ6Px9DgGyfAHfKY8xk5ddigS+MgzmqNfuQjMOzUX9cYNiSX4
	 K/z2qpNQNJJxl6L7oi2hfH7XOBLDV2/6dZUtvbjE9o+xlONWNqJQNeI3ruPE/Wxl0ZuhA
	 SNCvioIOW+GSONq+xlwdQ8Fv5+Pa0vYMsf+JnsxW0hFRfmy1dL7mVpgetpL6LxZivIRnp
	 NsPakbqIzgDpde2ZZKqIKcYrS/2+ZkD7hq3pjweQpjSerKE9pFiicXwEhHuoArM5e7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhH95VeS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B7606A901
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 20:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhH95VeS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE651F000C0
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795121658;
	bh=0p+q8IpVTNOek8hpj/iQcusogTuctDnbBAIvKsNy3fQ=;
	h=From:To:Subject:Date;
	b=fhH95VeSEC2YXsFQsTC7ZmGM9a04fqDYXa3N9gRtRp1pMYOeZIRDjd/VrP3iQf0Xs
	 vXv5Qe85C+Zy3oQjXewyIfXwOklGbnF4Zt6w7RGjdsu+tTb585jHnM3nUm0SIbw8v/
	 +djeBPrTnHH9X9y06rfeobgiB+j7VGZpb4686oKbJwxlc1VkuoNMFF/mBJ2FgiodHo
	 aZ5pzsAbUKQgpz0i8jH1Go7vsk4WMwmV4JBgYzVmhuYaUotwrYTl1/0QaBYE4LUhxt
	 BWR8EKaAsdJl0jTQCGxPcrTqnsv1DKG67jm2+lbxxxe7+lgry5d9VGh/pyI2q+1PBv
	 kWz9DpqhvRxnw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix zeroing tail of copied inline extent when reflinking
Date: Thu, 19 Nov 2026 20:54:14 +0000
Message-ID: <29d76fabcc56ab13b66b7149638348c9914221c5.1795121636.git.fdmanana@suse.com>
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

When the fs block size is smaller than the page size or we are using large
folios, we are zeroing the tail part of a block in the wrong range of the
folio because we are not taking into account that the folio can contain
multiple blocks. That is, we are ignoring the offset in the folio for
the end offset of the inline extent's data.

Fix this by computing the correct folio offset.

Link: https://sashiko.dev/#/bug/linux-7e417e9c-465a-41aa-884e-d1c65fc614cb
Fixes: 3115deb381e9 ("btrfs: reflink: make copy_inline_to_page() to be subpage compatible")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/reflink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index ecef21773027..618556cf1ba4 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -150,8 +150,12 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 	 *
 	 * So what's in the range [500, 4095] corresponds to zeroes.
 	 */
-	if (datal < block_size)
-		folio_zero_range(folio, datal, block_size - datal);
+	if (datal < block_size) {
+		const size_t foffset = offset_in_folio(folio, file_offset) + datal;
+		const size_t zero_len = round_up(foffset, block_size) - foffset;
+
+		folio_zero_range(folio, foffset, zero_len);
+	}
 
 	btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
 	btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794504783;
	b=TA3nIgtaDlg0AGBnLX4T3wfYeRGOFDQ1PlWZ6EEW8XBBULGi1L2oqexjC6tFVazrJkAi
	 Ww1U8HtuUfpDVrio6bvBuQDUhvR0vaVoi6JGDMvOlBh/iCVo+cli+7uEDP5hnfuWWn3+S
	 IKL2K0FrRPGol+MrowygVo3zvvh2gZbW7r0OaYB2Z4RMsbRN1HCeBb/Xzm08xAjzyqUXD
	 0h+uSK9Dw2kzFSUxsp63MSyo/cFFllFvct+Y6epMOFdLNRnYmCjreMSwlyuwDrQSVkSGn
	 jkPkf8iTq2V0FeKBIWvykP7AG4u7Uh/c7kVVxdFEYnMb7vDFrrkQEz5m5w+O2sF+CsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504783;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfjNEvj4b3x79cE8RccqtB7loiBnU77PpqzRIKLudEQ=;
	b=WKkqde9lQDOrP4jI7VgHgQUJKqVzfdMeJZcDN7CPONCymiFqJx7A77sKMrvkYbbveWdb
	 p8Us2Jxcumn5L1UX/YipLiExX74CLwlrEuJFaMMYojY4G0CJdoPlbL9QnmL2bzDnogXnG
	 KcvgSIXQ5F+g4BuwhluguzP7ni+VfltXEjp2cKRBTwtge6IDeFeR2jiwnZnQy1UwHVP0R
	 y4LtHTx5FAOt7MhCnkF45MjAR1AS4zqJ+YKRMt4M2gISmVy/eQTrsC9RU9ItYiKrwKhWV
	 4gH+JugSO4SDDFPhxf8iqZ1Z/Wnzdv2O6NGVIyxUjnNSR2DNLImRwFj/pmvynh+NY+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfoidE7P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E660A606A8BF
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfoidE7P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361791F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794504782;
	bh=nfjNEvj4b3x79cE8RccqtB7loiBnU77PpqzRIKLudEQ=;
	h=From:To:Subject:Date;
	b=jfoidE7P7ToXeQYQ8+BR1YcTlpA0wZkDnPcuUE76LiuLXuVaBC0yewSSZhINqMLR1
	 wrmMkUVOI77TLr9oiNmAaWzPdaOTwqQeffqybMUp2vZRpvsk0u/rZZyEQCPMuYl//D
	 V+OsBHhSkxMp+3wi/jC10gCY/Yd/Ywe1s5UjADuAV4LBqFkj1Pcs6mNdXM12tV5QtE
	 9DWiOIqjqszuymTW8vkS3YH0Vz0AfSY1TcQQuu80b8/Rl5GnMRSv9t/OOB8NiQ2gJ3
	 rNbRnfeyRxoXFiU9Hqi8d0S9cULX542yCWM+h3RbCpc+TFvZUEAtqfJUnbiHVJGilO
	 GX0bHeSGEyCVg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fiemap: deal with inline extent in fiemap_find_last_extent_offset()
Date: Thu, 12 Nov 2026 17:33:00 +0000
Message-ID: <dc3e7e3972a3d82ad871c53418a646498204400d.1794504751.git.fdmanana@suse.com>
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

In the while loop that finds the first file extent item, counting from the
end of the file, that is not a hole, we are accessing the disk_bytenr
field of each file extent item, which is wrong in case we have an item
that represents an inline extent. In that case the inline data starts at
the disk_bytenr offset and therefore we are reading user data or in case
the inline data is less than 8 bytes, we are accessing another region of
the leaf or even beyond the leaf boundaries in case it's the last item.

This should be a very rare case, as it implies having an inline extent
followed by a hole file extent item (the no-holes feature is not used).

Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/fiemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 817171028413..285398eb36dc 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -621,6 +621,8 @@ static int fiemap_find_last_extent_offset(struct btrfs_inode *inode,
 		leaf = path->nodes[0];
 		ei = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, ei) == BTRFS_FILE_EXTENT_INLINE)
+			break;
 		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, ei);
 	}
 
-- 
2.53.0


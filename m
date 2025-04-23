Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA90A27F73B
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2025 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745418015; cv=none; b=E/riMvMGhxfk2ELWNPtfALnVCWgZZ9felXwSiv2AJ+XzkU8w+4yrVr6ssrd772dm3vBXMcu/NXXlywfKdPt6nwpyXHO2DCuA2ZfLrz8AS9kth0a5iZoK45r1a6DB8xVBo70dIL2WoTxE2moNY5QO0nijNuzcNYCYEpyBlUssVR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745418015; c=relaxed/simple;
	bh=E54MjsX7piAo1fxrLqvhoWKyY9xdOeNrJekF4s0dehQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UIAESMUXuN2JIXs++6TnF/n3HUn324EAdQqtDW789w503vxGwaAvFqjAcmeAGdHx5hZ5MNuf8z/Jg6cnrlMFcV4BSoZAF7slfuFXSRyo5KnGkre6j4x/Jovk+1dfssXzjo/AcqxXnqeRI8wze2wMDy40zqdYG0rCKaGFaoQzjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQ301mRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ301mRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB3C4CEE2
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2025 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745418014;
	bh=E54MjsX7piAo1fxrLqvhoWKyY9xdOeNrJekF4s0dehQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sQ301mRA4Li5vzC79g0sAX41ieygrh24+YNlCzouxw+YMdqBcIrSlqGozs6U3jknD
	 +NRfgJCFwNWLT6o57t6UwyD5Yv1GV1rFszqO1+Q8IHM2M42grByEojZYRPPsX8BkkR
	 RrmrDHGKGjSbbcLl/b7fjsoYb6P+fjoEi6xuyKanTjLfxKqHsyb/DMY6smS6cFz9NY
	 iI+Hi1zF4D2zHzIGv4LMYEkVz74YKaUasKViXTxAMrEfVfxZbrWVOapLmuacuZwrLj
	 OH3o8QzT9G2Gohjm7B+6c8Si/vs2jwzbbCHjUIWMp5xTkU5YA39zeZGNGmBDDRQiGv
	 I92HRCcRMW0Sw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/22] btrfs: exit after state split error at btrfs_convert_extent_bit()
Date: Wed, 23 Apr 2025 15:19:48 +0100
Message-Id: <a8dae7f4335a35626d407ac99c69738bdba77fc5.1745401628.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1745401627.git.fdmanana@suse.com>
References: <cover.1745401627.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If split_state() returned an error we call extent_io_tree_panic() which
will trigger a BUG() call. However if CONFIG_BUG is disabled, which is an
uncommon and exotic scenario, then we fallthrough and hit a use after free
when calling set_state_bits() since the extent state record which the
local variable 'prealloc' points to was freed by split_state().

So jump to the label 'out' after calling extent_io_tree_panic() and set
the 'prealloc' pointer to NULL since split_state() has already freed it
when it hit an error.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 8b765ae9085f..80de8f96b08d 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1460,8 +1460,11 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 
 		ret = split_state(tree, state, prealloc, end + 1);
-		if (ret)
+		if (ret) {
 			extent_io_tree_panic(tree, state, "split", ret);
+			prealloc = NULL;
+			goto out;
+		}
 
 		set_state_bits(tree, prealloc, bits, NULL);
 		cache_state(prealloc, cached_state);
-- 
2.47.2


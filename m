Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A64389108
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734502; cv=none; b=KHD44pFfnrdtPxgdKfmAMEyJjpf9k0IF2BC3HXgELqfjX6y4rJ68Q/lMbbkJP4aLzfgIpIb6Ia7d7XALyoebH++9ZVLQUoEscHgky+fzdsbtXTuxEuiPWM8qND8j+MWZSSiDuhUIvQOnSSSf/wREI2NEWarYQHY1vXMqz5KbTlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734502; c=relaxed/simple;
	bh=MqOmhOE7nkh2n+CWZ5rRJrNrVnc2Wvpo3DmCYzxt5WM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLRwieaGQQrGT+xK4LNocpLKyfPv1cIz6etKppAG3C0/SQuvsPV8KHAWDH4lc8Kk7QYvNBVVT2fXkLT9qE9PBVcXLiNs4psMiTVJa6MQdFlMTz/m4WJGGSYtQDVZAC2VGWvDPteKBdos963eUywl1X/OO4zu8n2QAQcmMTTb1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFSsOrj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFSsOrj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9C91F00893
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734500;
	bh=aApO/CdULidAWBAOiyqRScH6kLyyxEpKwRjDCmmc0V0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=UFSsOrj5lU8qv1IAgys47dMXOTEQWztlGgUdcC9bT/UIVAZz9XFb1ssGnLCJtE/bq
	 lP/S1r6i1O3DKtaYzVYiFsfgXfnmX18stiYvH8E1Io2gD9J4Zfp7++9g6g02Fyqc99
	 rsiCdRYdwuHxwJvP1Ccr+FgUwzn4QHhnwFjUp9aAlDHpW+o0jeVK4xK796IbtFP5ym
	 jNf9ZPrtHkSZpabtmRGVGFGO53pLlMk2FGUQweZN3tnq1j2To4G6Z/Ib4T1lA+0R77
	 r+P+kWeSeZFlIxRJDmlEbotPMeFFldRT5mRw2ExuV9AxSv1lg0LeS9E6HxM0tEZUI/
	 OmOXAGyhxChDg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit from record_root_in_trans()
Date: Fri, 18 Sep 2026 13:28:09 +0100
Message-ID: <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1789734239.git.fdmanana@suse.com>
References: <cover.1789734239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we exit early because the transaction that last used the root already
matches the current transaction, we leave the BTRFS_ROOT_IN_TRANS_SETUP
bit set in the root (which we just set right before the exit). While this
does not cause any functional issue, it makes callers of
btrfs_record_root_in_trans() always lock fs_info->reloc_mutex and call
record_root_in_trans() for nothing, causing unnecessary lock contention.
One caller of btrfs_record_root_in_trans() is start_transaction(), used to
start new transaction or joining an existing one, which is a hot path.

So clear BTRFS_ROOT_IN_TRANS_SETUP on early exit.

Assisted-by: LLM
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ca114235bbe1..c1555621ae4e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -432,6 +432,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		spin_lock(&fs_info->fs_roots_radix_lock);
 		if (btrfs_get_root_last_trans(root) == trans->transid && !force) {
 			spin_unlock(&fs_info->fs_roots_radix_lock);
+			clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
 			return 0;
 		}
 		radix_tree_tag_set(&fs_info->fs_roots_radix,
-- 
2.47.2

